import pandas as pd
import random
def numbb(x):
    if x==1:
        return random.randint(8,15)
    elif x==2:
        return random.randint(16,24)
    elif x==3:
        return random.randint(25,34)
    elif x==4:
        return random.randint(35,44)
    elif x==5:
        return random.randint(45,54)
    elif x==6:
        return random.randint(55,64)
    elif x==7:
        return random.randint(65,74)
    elif x==8:
        return random.randint(75,105)

csvv= pd.read_csv("microdata.csv")
csvv.Age.replace(to_replace =1, 
                 value = numbb(1), 
                  inplace = True)
csvv.Age.replace(to_replace =2, 
                 value = numbb(2), 
                  inplace = True)
csvv.Age.replace(to_replace =3, 
                 value = numbb(3), 
                  inplace = True)
csvv.Age.replace(to_replace =4, 
                 value = numbb(4), 
                  inplace = True)
csvv.Age.replace(to_replace =5, 
                 value = numbb(5), 
                  inplace = True)
csvv.Age.replace(to_replace =6, 
                 value = numbb(6), 
                  inplace = True)
csvv.Age.replace(to_replace =7, 
                 value = numbb(7), 
                  inplace = True)
csvv.Age.replace(to_replace =8, 
                 value = numbb(8), 
                  inplace = True)
csvv.to_csv('outputfile.csv')
