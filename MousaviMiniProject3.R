#The goal of this assignment is to creat a prediction model on the priority variables
# My assigned responce variable is PG5_5PHR
#The data is 1353 samples/observations and 82 different feature columns.



##### Reading in the data #######
# For nicer printing
options(digits=2);
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

####### The simple questions are ##########
# 1. Time to take entire survey? In order to get that, I get the average time for all of the observcations which is 680 seconds. (total = 680)
      total = mean(data$End - data$Start, na.rm = TRUE)
      
# 2. Question that took the longest to complete?
      submit_times <- data[, grep("Submit", colnames(data), value = TRUE)]
      #extract page 0
      submit_times = submit_times[, -c(1)]
      #average time of each question 
      submit_means = apply(submit_times, 2, mean, na.rm = TRUE)
      longest = names(submit_means[which(submit_means == max(submit_means))])
      #longest = PG5Submit which is reasonable because this is the hardet and most generic question in the survey
      
# 3. Question that took the least time?
      shortest = names(submit_means[which(submit_means == min(submit_means))])
      #shortest = PG11Submit which is asking the gender and is very easy to answer!
      
# 4. Top-ranked criteria?
      ranked = data[, grep("PG5", colnames(data), value = TRUE)]
      ordered = ranked[, grep("Order", colnames(ranked), value = TRUE)]
      means = apply(ordered, 2, mean, na.rm = TRUE)
      top_ranked = names(means[which(means == max(means))])
      #top_ranked = PG5_2Order which is 
      
# 5. Demographic distribution by age?
      library(ggplot2)
      Ages = data[,81]
      ggplot(data.frame(data[,81]), aes(x=Ages)) + geom_bar()
      #As the plot shows from the people who have answered this question the majority of the are within the range of 25-34
      

# A hypothesis:
  #I think the priority is going to be effected by the experince of the programmer.
  #For example if the programmer is a software developer they might care
  #more about the reputation of the package that they are using. I would also hink that
  #it might be effected by the level of experince and the languages that they use.
  



# Explanation how needed measures are calculated from the provided data
# descriptive analysis of the proposed measures
# transformation and cleaning statement
      
  # The following is how I extract the columns that are related to my responce variable
  # Not all of the extracted valuses are going to be used in the model though.

  # My responce variable is PG5_5PHR = data[,'PG5_5PHR']
  # remove all other variables in page 5 other than mine
      
  #fixing the name of the responce column for the 3rd question
  colnames(data)[grep("PG2Resp.1", colnames(data))] = "PG3Resp"
  #find the title of the columns
  col_names = colnames(data)
  #Find the index of columns that are in page 5
  col5_ind = c(grep("PG5", col_names))
  #Find the index of my resmonce variable 
  mine = c(grep("PG5_5PHR", col_names))
  #remove the index of my responce variable from the list of the columns that are going to be deleted
  col5_ind = col5_ind[-grep(mine, col5_ind)]
  
  #times_ind = match(c("End", "Start"), col_names)
  #times_ind= c(times_ind, grep("Submit", col_names))
  #ind = c (col5_ind, times_ind)
  
  ###Removing columns related to page 4 that I don't need.
  col4_ind = match(c("PG4Dtr0_6", "PG4Psv7_8", "PG4Prm9_10"), colnames(data))
  colOther_ind = match(c("PG7Other", "PG1Other"), colnames(data)) #remove the "other" columns
  lotsUniq_ind = match(c("PG3Resp", "PG8Resp"), colnames(data)) #remove variable with too many uniquw values
  
  ind = c(col4_ind, col5_ind, colOther_ind,lotsUniq_ind)
  
  model_data = data[,-ind]

  
  model_data<- model_data[,c(1:16,18:ncol(model_data), 17)]
  
  ## those observation that are epmty need to be removes
  model_data<- model_data[-c(which(model_data[,"PG5_5PHR"]=="")),]
  
  summary(model_data)
  
  
  # correlation analysis and a statement about whhether or not some of the measures are too correlated and need to be dropped
  #get numeric fields only for correlation
  sel = c()
  for (i in 1:dim(model_data)[2]) if (is.numeric(model_data[,i])) sel = c(sel, i);
  correlation <- cor(model_data[,sel],method="spearman",use="pairwise.complete.obs"); #OK for any: uses ranks
  hight_cor <- which(abs(correlation) > 0.7 & abs(correlation) < 0.999999, arr.ind = TRUE)
  rownames(hight_cor) #= "End"      "Start"    "PG0Shown" "PG0Dis"
  ## remove the highly correlated columns from model_data
  model_data <- model_data[,-c( match(rownames(hight_cor), colnames(model_data)))]
  
  
  model_data$PG5_5PHR<- as.factor(as.character(model_data$PG5_5PHR))
  
  #fitting of the statistical model
  #Now the data is ready and I need to split the data into train and test
  train_ind = sample(1:nrow(model_data), nrow(model_data)*0.75)
  train_data = model_data[train_ind,]
  test_data = model_data[-c(train_ind),]
  
  train = train_data[, -c(ncol(train_data))]
  train_y = train_data[, ncol(train_data)]
  # library(magrittr)
  # train = train %>% select(-PG3Resp, -PG8Resp, -PG7, -PG1)
  
  
  test = test_data[, -c(ncol(test_data))]
  test_y = test_data[, ncol(test_data)]
  
  library(rpart)
  library(AUC)
  library(randomForest)
  
  #Random Forest
  rf<- randomForest(PG5_5PHR ~ . , data=train_data, na.action = na.omit, iter = 100, ntree = 100, importance=TRUE)
  pred<- predict(rf, test_data)
  AUC::auc(roc(pred,test_y))
  varImpPlot(rf, n.var = 10, main = "Variable Importance")
  importance(rf, type = 1)


# interpretation of coefficients
  