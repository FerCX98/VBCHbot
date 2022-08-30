:-module(prolexa,
	[
		prolexa_cli/0,			% run prolexa on the command line
		prolexa/1,				% HTTP server for prolexa (for Heroku)
		mk_prolexa_intents/0	% dump all possible Alexa intents in prolexa_intents.json
	]).

:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).
:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(pcre)).
:- use_module(library(csv)).
:- consult(prolexa_engine).% meta-interpreter
:- consult(prolexa_grammar).    % NLP grammar
:- discontiguous prolexa:symptom/4.
:- discontiguous prolexa:diseases/1.
:- discontiguous prolexa:firstName/2.
:- discontiguous prolexa:lastName/2.
:- discontiguous prolexa:industry/2.
:- discontiguous prolexa:ethnic/2.
:- discontiguous prolexa:sex/2.
:- discontiguous prolexa:martial/2.
:- discontiguous prolexa:age/2.
:- dynamic stored_rule/2.% to record additions to Rulebase in a session

:-prompt(_Old,'prolexa> ').
:- ["medknowledge.pl"].
:- discontiguous symptom/4.
:- discontiguous diseases/1.
:- ["person.pl"].
%some intial stored rules
stored_rule(1,[(mortal(X):-human(X))]).
stored_rule(1,[(human(peter):-true)]).


%%% Prolexa Command Line Interface %%%

% Utterances need to be typed as strings, e.g. "Every human is mortal".
prolexa_cli:-
	read(Input),
	( Input=stop -> true
	; otherwise ->
		handle_utterance(1,Input,Output),
		writeln(Output),
		prolexa_cli
	).

% Main predicate that uses DCG as defined in prolexa_grammar.pl 
% to distinguish between sentences, questions and commands
handle_utterance(SessionId,Utterance,Answer):-
	write_debug(utterance(Utterance)),
	% normalise Utterance into list of atoms
	split_string(Utterance," ","",StringList),	% tokenize by spaces
	maplist(string_lower,StringList,StringListLow),	% all lowercase
	maplist(atom_string,UtteranceList,StringListLow),	% strings to atoms
% A. Utterance is a sentence 
	( phrase(sentence(Rule),UtteranceList),
	  write_debug(rule(Rule)),
	  ( known_rule(Rule,SessionId) -> % A1. It follows from known rules
			atomic_list_concat(['I already knew that',Utterance],' ',Answer)
	  ; otherwise -> % A2. It doesn't follow, so add to stored rules
			assertz(prolexa:stored_rule(SessionId,Rule)),
			atomic_list_concat(['I will remember that',Utterance],' ',Answer)
	  )
% B. Utterance is a question that can be answered
	; phrase(question(Query),UtteranceList),
	  write_debug(query(Query)),
	  prove_question(Query,SessionId,Answer) -> true
% C. Utterance is a command that succeeds
	; phrase(command(g(Goal,Answer)),UtteranceList),
	  write_debug(goal(Goal)),
	  call(Goal) -> true
% D. None of the above
	; otherwise -> atomic_list_concat(['I heard you say, ',Utterance,', could you rephrase that please?'],' ',Answer)
	),
	write_debug(answer(Answer)).

write_debug(Atom):-
	write(user_error,'*** '),writeln(user_error,Atom),flush_output(user_error).


%%%%% the stuff below is only relevant if you want to create a voice-driven Alexa skill %%%%%


%%% HTTP server %%%
getrand(Z,A) :- random_member(A,Z),A=A.
firsttext(1,J,A,V,FN, LN, L) :- ages(J,X), Age=X, atom_string(B,A),assertz(known(V)),atom_concat('Hello doctor, I am here today because I have ',B,T),atom_string(T,P), re_replace("_"," ",P,Q),re_replace("_"," ",Q,L), L=L.
firsttext(2,J,A,V,FN, LN, L) :- ages(J,X), Age=X, atom_string(FNA,FN),atom_string(E,A),assertz(known(V)),atom_concat('Hello doctor, I am ',FNA,B),atom_concat(', I am ',Age,C),atom_concat(C, ' and I came today because I have ',D),atom_concat(D,E,S),atom_string(S,L), L=L.
firsttext(3,J,A,V,FN, LN, L) :- ages(J,X), Age=X, atom_string(FNA,FN),atom_string(E,A),assertz(known(V)),atom_concat('Good afternoon, I am ',FNA,C),atom_concat(C,' , I am ',D),atom_concat(D,Age,F),atom_concat(F, ' ,and I came today because I have ',G),atom_concat(G,E,P),atom_string(P,L), L=L.
firsttext(4,J,A,V,FN, LN, L) :- ages(J,X), Age=X, atom_string(FNA,FN),atom_string(D,A),assertz(known(V)),atom_concat('Hello doctor, I am ',FNA,B),atom_concat(B, ' and I came today because I have ',C),atom_concat(C,D,S),atom_string(S,L), L=L.
hint(K,L) :- findall(X,known(X),Z),findall(Y,symptom(K,_,Y,_),G),length(G,M),length(Z,N),hint1(N,M,Z,G,A), L=A.
hint1(N,M,Z,G,L) :- (N=M -> L='I dont have any more symptoms.',L=L ; hint2(N,M,Z,G,0,L),L=L).
hint2(N,M,Z,G,V,L) :- hint3(V,G,A),A=A,(N>M -> L='I dont have any more symptoms.';true),(N=M -> L='I dont have any more symptoms.'; true ),Q is V+1,(N<M,memberchk(A,Z) -> hint2(N,M,Z,G,Q,L); \+(memberchk(A,Z)) -> atom_string(A,W),re_replace("_"," ",W,B),re_replace("_"," ",B,C),re_replace("_"," ",C,D),atom_string(H,D),atom_concat(' I just remembered, I have ',H,O),atom_string(O,L),assertz(known(A)),L=L).
hint3(V,G,A) :- nth0(V,G,A) .
hint4(K,L) :- findall(X,known(X),Z),findall(Y,symptom(K,_,Y,_),G),length(G,M),length(Z,N),(M=N ; N>M -> L="I dont have any more symptoms.";hint(K,L)) .
checkk(D,J) :- findall(X,symptom(D,_,_,X),Z), memberchk(J,Z).
chkkp(R,J,Answer) :- atom_string(D,R),(checkk(J,D) -> createAnswer(D,C),atom_concat('Yes, I have ' ,C,P),assertz(known(C)),atom_string(P,Z),Answer=Z ; createAnswer(D,C) ,atom_concat('No, I dont have ' ,C,T),atom_string(T,Z),Answer=Z; Answer="I didnt get that.").
chackk(I,J) :- re_replace(" ","_",I,O),re_replace(" ","_",O,D),symptom(J,D,_,_).
anss(I,J,Answer) :- ( bojo(I) -> ansss(I,J,T),Answer=T ; deci(I) -> bc(I,J,T), Answer=T   ; chkkp(I,J,T),Answer=T).
ansss(I,J,Answer) :- atom_string(T,I), (chackk(T,J) -> atom_concat('Yes, my disease is ', T,Y),atom_concat(Y,'. Thanks Doctor! If you would like to see the next patient, just say: next patient.',Q),atom_string(Q,Z),Answer=Z ; atom_concat('No, my disease is not ',T,W),atom_concat(W,' . ',G),hint4(J,K),(var(K) -> K="I dont have any more symptoms.";true), atom_concat(G,K,S),atom_string(S,Z),Answer=Z).

createAnswer(X,C):- getmefirst(Y,X),atom_string(Y,L),re_replace("_"," ",L,A),re_replace("_"," ",A,B),re_replace("_"," ",B,D),re_replace("_"," ",D,P),atom_string(C,P),C=C.
bojo(J) :- atom_string(D,J), findall(X,diseases(X),Z), memberchk(D,Z) .

getmefirst(X,Y):- symptom(_,_,X,Y),X=X,Y=Y.

deci(I) :- Z=['hint','age','old' ,'sex','marital','ethnic','industry','firstName','lastName','name'], atom_string(D,I),memberchk(D,Z).

bc(A,J,D) :- atom_string(Y,A), (Y='hint' -> hint4(J,D),(var(D)->D="I dont have any more symptoms.";true) ; Y='name' -> fName(J,D); Y= 'firstName' -> fName(J,D) ; Y='lastName' -> lName(J,D) ; Y = 'age' -> ages(J,D) ;  Y= 'old' -> ages(J,D) ; Y = 'sex' -> sexs(J,D); Y = 'married' -> marrys(J,D); Y =  'ethnicity' -> ethnicitys(J,D);Y = 'industry' -> industrys(J,D);true).

ages(J,X) :- age(J,X),X=X.
sexs(J,X) :- sex(J,Y) , (Y=1 -> X="Male"; Y=2 -> X="Female").
marrys(J,X) :- marital(J,Y) , (Y=1 -> X="Single" ;Y= 2 -> X="Married"; Y=3 -> X="Seperated"; Y=4 -> X="Divorced"; Y=5 ->X="Widowed").
ethnicitys(J,X) :- ethnic(J,Y) , (Y=1-> X="White";Y=2-> X="Mixed" ;Y=3-> X="Asian" ;Y=4-> X="Black" ;Y=5-> X="Chinese or other" ;Y= -9 -> X="Not specified" ).
industrys(J,X) :- industry(J,Y), (Y=1 -> X = "Agriculture, forestry and fishing " ;
	Y=2 -> X = "Mining and quarrying; Manufacturing; Electricity, gas, steam and air conditioning system; Water supply " ;
 	Y=3 -> X = "Construction " ;
 	Y=4 -> X = "Wholesale and retail trade; Repair of motor vehicles and motorcycles" ;
 	Y=5 -> X = "Accommodation and food service activities " ;
 	Y=6 -> X = "Transport and storage; Information and communication " ;
 	Y=7 -> X = "Financial and insurance activities; Intermediation " ;
 	Y=8 -> X = "Real estate activities; Professional, scientific and technical activities; Administrative and support service activities " ;
 	Y=9 -> X = "Public administration and defence; compulsory social security " ;
 	Y=10 -> X = "Education " ;
 	Y=11 -> X = "Human health and social work activities " ;
 	Y=12 -> X = "Other community, social and personal service activities; Private households employing domestic staff; Extra-territorial organisations and bodies").

health(Y,X) :- (Y=1 -> X ="Very good health" ;
		Y=2 -> X ="Good health" ;
 	 	Y=3 -> X ="Fair health" ;
 	 	Y=4 -> X ="Bad health" ;
 	 	Y=5 -> X ="Very bad health").
		
fName(J,N)  :- firstName(J,N).

lName(J,N) :- lastName(J,N).



prolexa(Request):-
	http_read_json_dict(Request,DictIn),
	RequestType = DictIn.request.type,
	(RequestType = "LaunchRequest" -> 
	random(1,4680,J),
	(nonvar(runID) -> abolish(runID/2);true),
	(nonvar(known) -> abolish(known/1);true),
	assertz(runID(5,J)),
	random(1,4,P),
	fName(J,FN),
	lName(J,LN),
	findall(X, symptom(J,_,X,_), Z),
	getrand(Z,E),
	re_replace("_"," ",E,F),
	re_replace("_"," ",F,H),
	re_replace("_"," ",H,G),
	re_replace("_"," ",G,A),
	firsttext(P,J,A,E,FN,LN,T);true),
	( RequestType = "LaunchRequest" -> my_json_answer(T,_DictOut)
    ; RequestType = "SessionEndedRequest" -> my_json_answer("Goodbye",_DictOut)
	; RequestType = "IntentRequest" -> 	IntentName = DictIn.request.intent.name,  
										findall(C,runID(5,C),N),nth0(0,N,V) , handle_intent(IntentName,V,DictIn,_DictOut);
	my_json_answer("I did not get that, please try saying it again.",_DictOut)
	).

my_json_answer(Message,DictOut):-

	
		( Message="" -> Message="Please try that again.";true),
	DictOut = _{
	      response: _{
	      				outputSpeech: _{
	      								type: "PlainText", 
	      								text: Message
	      							},
	      				shouldEndSession: false
	      			},
              version:"1.0"
	     },
	reply_json(DictOut).


handle_intent("utterance",V,DictIn,DictOut):-
	/* SessionId=DictIn.session.sessionId, */
	Utterance=DictIn.request.intent.slots.utteranceSlot.value,
	(Utterance="" -> my_json_answer("I didnt get that.",_DictOut);true),
	(Utterance="next" ->resett();
	re_replace("a ","",Utterance,I),
	re_replace("an ","",I,S),
	re_replace(" ","",S,U),
	re_replace(" ","",U,F),
	re_replace(" ","",F,H),
	re_replace(" ","",H,R),
	(Utterance="continue" -> my_json_answer("You can now continoue from where you left off!",DictOut);
	R="fever" , checkk(V,'mildfever') -> C="mildfever";
	R="fever" , checkk(V,'highfever') -> C="highfever";true),
	(var(C), R="fever" -> my_json_answer("No, I dont have fever.",DictOut);nonvar(C) -> anss(C,V,Answer);true),
	(var(C), not(R=fever) ->anss(R,V,Answer);true),
	my_json_answer(Answer,DictOut)).

handle_intent(_,V,DictIn,DictOut):-
	my_json_answer("Sorry, I didnt get that.",DictOut).

resett():-  
	abolish(known/1),
	abolish(runID/2),
	random(1,4680,J),
	assertz(runID(5,J)),
	random(1,4,P),
	fName(J,FN),
	lName(J,LN),
	findall(X, symptom(J,_,X,_), Z),
	getrand(Z,E),
	re_replace("_"," ",E,F),
	re_replace("_"," ",F,G),
	re_replace("_"," ",G,H),
	re_replace("_"," ",H,A),
	firsttext(P,J,A,E,FN,LN,T),
	my_json_answer(T,DictOut).


%%% generating intents from grammar %%%
% Run this if you want to test the skill on the 
% Alexa developer console

mk_prolexa_intents:-
	findall(
			_{
				%id:null,
				name:
					_{
						value:SS,
						synonyms:[]
					}
			},
		( phrase(utterance(_),S),
		  atomics_to_string(S," ",SS)
		),
		L),
	% Stream=current_output,
	open('prolexa_intents.json',write,Stream,[]),
	json_write(Stream,
				_{
				    interactionModel: _{
        				languageModel: _{
            				invocationName: "virtual patient",
            				intents: [
								_{
								  name: 'AMAZON.CancelIntent',
								  samples: []
								},
								_{
								  name: 'AMAZON.NavigateHomeIntent',
								  samples: []
								},
								_{
								  name: 'AMAZON.HelpIntent',
								  samples: []
								},
								_{
								  name: 'AMAZON.StopIntent',
								  samples: []
								},
								_{
								  name: utterance,
								  samples: [
									'{utteranceSlot}'
								  ],
								  slots: [
									_{
									  name: utteranceSlot,
									  type: utteranceSlot,
									  samples: []
									}
								  ]
							  }
							  ],
							  types: [
									_{
										name:utteranceSlot,
										values:L
									}
								]
							}
						}
				}
			   ),
		close(Stream).
