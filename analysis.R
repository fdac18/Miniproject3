################
# MP3: data cleaning
################
library(tidyr)
library(useful)
library(plyr)
library(randomForest)
library(caret)
library(textclean)

# Read in the data
data <- read.csv("TechSurvey - Survey.csv",header=T);

# Convert date to unix second
for (i in c("Start", "End")) 
  data[,i] = as.numeric(as.POSIXct(strptime(data[,i], "%Y-%m-%d %H:%M:%S")))
for (i in 0:12){
  vnam = paste(c("PG",i,"Submit"), collapse="")
  data[,vnam] = as.numeric(as.POSIXct(strptime(data[,vnam], "%Y-%m-%d %H:%M:%S")))
}

# Calculate differences in time    
for (i in 12:0){
  pv = paste(c("PG",i-1,"Submit"), collapse="");
  if (i==0) 
    pv="Start";
  vnam = paste(c("PG",i,"Submit"), collapse="");
  data[,vnam] = data[,vnam] -data[,pv];
}

################
# Simple questions
################
# Total time to complete
complete_time= mean(data$End - data$Start, na.rm = TRUE)

# Extract response time columns
question_times<- data[,grep(pattern = "Submit", x= colnames(data),value=TRUE)]

# Get average time for each question
time_means<- apply(question_times[,-c(1)], 2, mean, na.rm=TRUE)

# Longest question
longQ<- names(time_means)[which(time_means==max(time_means))]

# Shortest question
shortQ<- names(time_means)[which(time_means==min(time_means))]

# Extract ranked critera columns
ranked_col<- data[,grep(pattern = "PG5", x= colnames(data),value=TRUE)]
ranked_col<- data[,grep(pattern = "Order", x= colnames(ranked_col),value=TRUE)]

# Mean ranking of each criteria
criteria_means<- apply(ranked_col, 2, mean, na.rm=TRUE)

# Highest ranked criteria
highRank<- names(criteria_means)[which(criteria_means==max(criteria_means))]

# Age distribution
age_freq <- data[,81] %>%
              count() %>%
              .[-c(1),]

# Plot distribution
ggplot(age_freq, aes(x, freq)) +
    geom_col(fill="red") +
    xlab("Age Group") +
    ylab("Number of participants") +
    ggtitle("Demographic Distribution by Age")

################
# Clean data for model
################
# Columns to drop
col_drop= c("PG4Dtr0_6", "PG4Psv7_8", "PG4Prm9_10", "PG5_1RRPQ", "PG5_1Order", "PG5_1Time", "PG5_2BNUI",
            "PG5_2Order", "PG5_2Time", "PG5_4VGP","PG5_4Order", "PG5_4Time" , "PG5_5PHR",
            "PG5_5Order", "PG5_5Time", "PG5_6SSYOP", "PG5_6Order", "PG5_6Time", "PG5_7NDYP",   
            "PG5_7Order", "PG5_7Time", "PG5_8CP", "PG5_8Order", "PG5_8Time", "PG5_9FRP",
            "PG5_9Order", "PG5_9Time", "PG5_10RPA", "PG5_10Order", "PG5_10Time", "PG5_11NSG",
            "PG5_11Order", "PG5_11Time",  "PG5_12NWG","PG5_12Order", "PG5_12Time",
            "PG5_13NFG", "PG5_13Order", "PG5_13Time")

# Drop these columns
model_data<- data[,-c(which(colnames(data) %in% col_drop))]

# Fix incorrect colname
colnames(model_data)[15]<- "PG3Resp"

# Preserve only PG5 columns needed
model_data<- model_data[,c(1:19, 22:43)]

# Rearrange df so response is far left column
model_data<- model_data[,c(19,1:18,20:ncol(model_data))]

# Remove all samples with no response value
model_data<- model_data[-c(which(model_data[,1]=="")),]

# Drop columns with too many unique responses to be useful
## i.e. PG3Resp and PG8Resp
model_data<- model_data[,-c(16, 32)]

# Explore variables
summary(model_data)

# Examine variable correlations
sel = c()
for (i in 1:dim(model_data)[2]) if (is.numeric(model_data[,i])) sel = c(sel, i);
corr<- cor(model_data[,sel],method="spearman",use="pairwise.complete.obs")

# Drop highly correlated columns
related<- which(abs(corr)>0.7 & abs(corr)<0.999999, arr.ind = TRUE)

## Of the columns returned, those highly correlated seem uninformative
## They have been dropped
model_data<- model_data[,-which(names(model_data) %in% rownames(related))]

# Fix PG1 column factor levels
model_data$PG1PsnUse<- as.character(model_data$PG1PsnUse)
model_data$PG1PsnUse[which(model_data$PG1PsnUse!="")]<- "Personal use"
model_data$PG1PsnUse<- as.factor(model_data$PG1PsnUse)

model_data$PG1WdAuth<- as.character(model_data$PG1WdAuth)
model_data$PG1WdAuth[which(model_data$PG1WdAuth!="")]<- "Wider audience"
model_data$PG1WdAuth<- as.factor(model_data$PG1WdAuth)

model_data$PG1Trn<- as.character(model_data$PG1Trn)
model_data$PG1Trn[which(model_data$PG1Trn!="")]<- "Training"
model_data$PG1Trn<- as.factor(model_data$PG1Trn)

model_data$PG1Other<- as.character(model_data$PG1Other)
model_data$PG1Other[which(model_data$PG1Other!="")]<- "Other"
model_data$PG1Other<- as.factor(model_data$PG1Other)

# Fix levels of response variable
model_data$PG5_3HDS<- as.factor(as.character(model_data$PG5_3HDS))

################
# Fit model and evaluate
################
# Split model_data into train and test
train_index<- createDataPartition(model_data$PG5_3HDS, p=0.75)
train<- model_data[train_index$Resample1,]
test<- model_data[setdiff(rownames(model_data), rownames(train)),]

# Run randomForest
rf<- randomForest(PG5_3HDS ~ . , data=train, na.action = na.omit, importance=TRUE)

# Which variables are most important
priority<- importance(rf)

# Plot variable importance
varImpPlot(rf, n.var = 10, main = "Variable Importance")

# Plot tree
plot(rf)

# Get number of nodes in each tree
treesize(rf)

# Predict and compute accuracy
pred<- predict(rf, test)
acc<- (length(which((pred==test$PG5_3HDS)==TRUE)))/nrow(test)

# Group class labels and check accuracy
pred_cond<- mgsub(pred, c("Essential", "High Priority", "Medium Priority", "Low Priority", "Not a Priority"),
                  c(3, 3, 2, 1, 1))
true_cond<- mgsub(test$PG5_3HDS, c("Essential", "High Priority", "Medium Priority", "Low Priority", "Not a Priority"),
                  c(3, 3, 2, 1, 1))
acc_cond<- (length(which((pred_cond==true_cond)==TRUE)))/nrow(test)



