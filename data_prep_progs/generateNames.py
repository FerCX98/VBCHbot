import pandas
from faker import Faker

i=0
j=0
fake = Faker()
Faker.seed(0)
out=[]
df=pandas.read_csv("outputfile.csv")

for index, row in df.iterrows():
    if row["Sex"] ==1:  
        if i < 2340 :
            row['Lastname']= fake.last_name_male()
            row['Firstname']= fake.first_name_male()
            out.append(row)
            i=i+1
    if row["Sex"] == 2 :
        if j < 2340 :
            row['Lastname']= fake.last_name_female()
            row['Firstname']= fake.first_name_female()
            out.append(row)
            j=j+1
df=pandas.DataFrame(out, columns=["Person ID",	"Family Composition",	"Sex",	"Age",	"Marital Status", "Health" ,	"Ethnic Group",	"Economic Activity",	"Industry", "Firstname","Lastname"])
df.to_csv ("out.csv", index = False, header=False)
            