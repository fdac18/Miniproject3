# A hypothesis "I think the priority is going to be affected by ..."
  #I think the priority is going to be effected by the experince of the programmer.
  #For example if the programmer is a software developer they might care
  #more about the reputation of the package that they are using. I would also hink that
  #it might be effected by the level of experince and the languages that they use.
  

# Explanation how needed measures are calculated from the provided data
  # The following is how I extract the columns that are related to my responce variable
  # Not all of the extracted valuses are going to be used though.

  # For nicer printing
  options(digits=2);
  # Read in the data
  data <- read.csv("TechSurvey - Survey.csv",header=T);
  data <- data[data$Start!="" & data$End!="", ]
  
  dtparts = t(as.data.frame(strsplit(as.character(data[,"Start"]), " ")))
  s = chron(dates=dtparts[,1],times=dtparts[,2], format=c('y-m-d','h:m:s'))
  
  dtparts = t(as.data.frame(strsplit(as.character(data[,"End"]), " ")))
  e = chron(dates=dtparts[,1],times=dtparts[,2], format=c('y-m-d','h:m:s'))
  
  ####### Howlong did the survey take?########
  e - s
  
  #convert date to unix second
  # for (i in c("Start", "End")) 
  #   data[,i] = as.numeric(as.POSIXct(strptime(data[,i], "%Y-%m-%d %H:%M:%S")))
  #  
  # for (i in 0:12){
  #   vnam = paste(c("PG",i,"Submit"), collapse="")
  #   data[,vnam] = as.numeric(as.POSIXct(strptime(data[,vnam], "%Y-%m-%d %H:%M:%S")))
  # }
  # #calculate differences in time    
  # for (i in 12:0){
  #   pv = paste(c("PG",i-1,"Submit"), collapse="");
  #   if (i==0) 
  #     pv="Start";
  #   vnam = paste(c("PG",i,"Submit"), collapse="");
  #   data[,vnam] = data[,vnam] -data[,pv];
  # }
  
  
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
  times = match(c("End", "Start"), col_names)
  times = c(times, grep("Submit", col_names))
  times = c(times, grep("Resp", col_names))
  ind = c (ind, times)
  my_data = data[, -ind]
  
  end = my_data[my_data$End!="", "End"]
  start = my_data[my_data$Start!="" & my_data$End!="", "Start"]
  
  #only neumeric variables
  library("dplyr")
  my_neumeric = select_if(my_data, is.numeric) #this has 20 columns but Dr. Mockus's have 34, because 14 of them are from page 5
  cor(my_neumeric,method="spearman",use="pairwise.complete.obs")
  
  SE_data <- my_neumeric[,c("Start", "End")]
  SE_data$Start <- as.Date(SE_data$Start, "%m/%d/%y")




# descriptive analysis of the proposed measures
# transformation and cleaning statement
# correlation analysis and a statement about whhether or not some of the measures are too correlated and need to be dropped
# fitting of the statistical model
# interpretation of coefficients
# Please use lectures/fdacStats.ipynb and lecture slides for guidance


############## MY NOTES IN CLASS ################

#1. Hypothesis about the effet of each variable: What you expect to happen and which packages to use. The responce variable is obvious and
##what variable to use to calculate the y from (either from the current columns or calculate from the current columns)
#2.  explanation how needed measures are calculated from the provided data
#3. get the data. Follow the steps in the example, coordinate = descriptive analysis, summary
#clean the data
#Decide what to do with the NAs
#What model to use: logistic regressio or linear regression 
#Explain the result. Whethe the fir is good or bad and how to make it better

#Note: looks like including variables that are highly coorolated can causes problem so I should not include them in the model
