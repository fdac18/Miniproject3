# For nicer printing
options(digits=2);
# Read in the data
data <- read.csv("TechSurvey - Survey.csv",header=T);

#convert date to unix second
for (i in c("Start", "End")) 
  data[,i] = as.numeric(as.POSIXct(strptime(data[,i], "%Y-%m-%d %H:%M:%S")))
for (i in 0:12){
  vnam = paste(c("PG",i,"Submit"), collapse="")
  data[,vnam] = as.numeric(as.POSIXct(strptime(data[,vnam], "%Y-%m-%d %H:%M:%S")))
}
#calculate differences in time    
for (i in 12:0){
  pv = paste(c("PG",i-1,"Submit"), collapse="");
  if (i==0) 
    pv="Start";
  vnam = paste(c("PG",i,"Submit"), collapse="");
  data[,vnam] = data[,vnam] -data[,pv];
}

#My responce variable is PG5_5PHR = data[,'PG5_5PHR']
#####remove all other variables in page 5 other than mine

#find the title of the columns
col_names = colnames(data)
#Find the index of columns that are in page 5
ind = c(grep("PG5", col_names))
#Find the index of my resmonce variable 
mine = c(grep("PG5_5PHR", col_names))
#remove the index of my responce variable from the list of the columns that are going to be deleted
ind = ind[-grep(mine, ind)]
my_data = data[, -ind]

#only neumeric variables
library("dplyr")
my_neumeric = select_if(my_data, is.numeric) #this has 20 columns but Dr. Mockus's have 34, because 14 of them are from page 5
cor(my_neumeric,method="spearman",use="pairwise.complete.obs")

