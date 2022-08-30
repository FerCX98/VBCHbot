import re

curr_dis= ""
next_new=1
listEx=[]
with open('readme.txt', 'w') as c:
	f=open("example.txt").read()
	string = ""
	if f.islower():
		pass
	else:
		character_list = list(f)
	for i, g in enumerate(character_list):
		if g.isupper():
			character_list[i] =  g.lower()		
	f=string.join(character_list)
	for line in re.split(r',(?![,])', f):
		print(line)
		line=line.replace(" ","")
		line=line.replace("(vertigo)","")
		line=line.replace("(","_")
		line=line.replace(")","")
		
		if line==",,,,,,,,,,,,,,,,":
			pass

		elif next_new==1:
			next_new=0
			pass
				
			
		elif ",,,,,,,,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)
		elif ",,,,,,,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	  
		elif ",,,,,,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	  
		elif ",,,,,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	 
		elif ",,,,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	 
		elif ",,,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	
		elif ",,,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)		  		
		elif ",,,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	
		elif ",,,,," in line:
			
			next_new=1
			line=line.replace(",,,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	 
		elif ",,,," in line:
			
			next_new=1
			line=line.replace(",,,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	 
		elif ",,," in line:
			
			next_new=1
			line=line.replace(",,,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)	   
		elif ",," in line:

			next_new=1
			line=line.replace(",,","")
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)		  
			
		elif ",,,,,,,,,,,,,,,," not in line:
        
			apee=line
			if line in listEx:
				pass
			else:
				line2=line.replace("_"," ")
				line=line.replace("_","")
				c.write(line2)
				c.write(",")
				c.write(line)
				c.write("\n")
				listEx.append(apee)
					 
				
