import re
next_new=1
q=1
dysS=2
curr_dis= ""
dys=["a"]
w=0
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
		# commented out for different usage: line=line.replace(" ","")
		line=line.replace("(vertigo)","")
		line=line.replace("(","_")
		line=line.replace(")","")
		if line==",,,,,,,,,,,,,,,,":
			pass
		elif next_new==1:
			if dys==["a"]:
				dysS=0
			elif dys[w]==line:
 				dysS=2
			elif dys[w]!=line:
 				dysS=0
			if dysS==0:
				curr_dis=line
				curr_dis=curr_dis.replace("\n","")
				c.write("diseases("+curr_dis+").")
				c.write("\n")
				dys.append(line)
				w=w+1
				
			next_new=0
		elif ",,,,,,,,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")	
			q=q+1			
		elif ",,,,,,,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")
			q=q+1            
		elif ",,,,,,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")		
			q=q+1            
		elif ",,,,,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")	
			q=q+1            
		elif ",,,,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")			
			q=q+1            
		elif ",,,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")		
			q=q+1			
		elif ",,,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")		
			q=q+1			
		elif ",,,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")		
			q=q+1            
		elif ",,,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")	
			q=q+1            
		elif ",,,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")
			q=q+1            
		elif ",,," in line:
			
			next_new=1
			for word in line:
				line=line.replace(",,,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")	
			q=q+1            
		elif ",," in line:

			next_new=1
			for word in line:
				line=line.replace(",,","")
			c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
			c.write("\n")              
			q=q+1           


		elif line!=",,,,,,,,,,,,,,,,":
			if line != "" and line!=curr_dis:
				c.write("symptom(" + str(q) + "," +curr_dis + "," + line + ").")
				c.write("\n")
				
