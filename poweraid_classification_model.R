# load the package
library(randomForest)
library(RColorBrewer)
library(rpart)
library(bootstrap)
library(DAAG)
library("klaR")
library("caret")
library(party)
library(lattice)

#data normalization helper function
normalize <- function(x) {
  num <- x - min(x)
  denom <- max(x) - min(x)
  return (num/denom)
}
#DataSetNorm <- as.data.frame(lapply(DataSet[1:6], normalize))

#read data set
###################### MALICIOUS ###################
##1.MailSpy
DataMailSpy1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/MailSpy_10minslog_data_screenOn.txt",
                      header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataMailSpy2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/MailSpy_10minslog_data_screenOff.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataMailSpy3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/MailSpy_10minslog_wifi_screenOn.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:580,]
DataMailSpy4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/MailSpy_10minslog_wifi_screenOff.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataMailSpyScreenOn <- rbind(DataMailSpy1, DataMailSpy3)##screen on data
DataMailSpyScreenOff <- rbind(DataMailSpy2, DataMailSpy4)##screen off data
DataMailSpy <- rbind(DataMailSpyScreenOn, DataMailSpyScreenOff)#All data

######## EXP I ####
MailSpyScreenOnTrain <- DataMailSpyScreenOn[1:944,]
MailSpyScreenOnTest <- DataMailSpyScreenOn[945:1180,]
rownames(MailSpyScreenOnTest) <- NULL

MailSpyScreenOffTrain <- DataMailSpyScreenOff[1:960,]
MailSpyScreenOffTest <- DataMailSpyScreenOff[961:1200,]
rownames(MailSpyScreenOffTest) <- NULL
  
##2.LocationSpy
DataLocationSpy1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/locationSpy_10minslog_data_screenOn.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataLocationSpy2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/locationSpy_10minslog_data_screenOff.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataLocationSpy3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/locationSpy_10minslog_wifi_screenOn.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
DataLocationSpy4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/locationSpy_10minslog_wifi_screenOff.txt",
                           header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
DataLocationSpyScreenOn <- rbind(DataLocationSpy1, DataLocationSpy3)##screen on data
DataLocationSpyScreenOff <- rbind(DataLocationSpy2, DataLocationSpy4)##screen off data
DataLocationSpy <- rbind(DataLocationSpyScreenOn, DataLocationSpyScreenOff)#All data

######## EXP I ####
LocationSpyScreenOnTrain <- DataLocationSpyScreenOn[1:955,]
LocationSpyScreenOnTest <- DataLocationSpyScreenOn[956:1194,]
rownames(LocationSpyScreenOnTest) <- NULL

LocationSpyScreenOffTrain <- DataLocationSpyScreenOff[1:950,]
LocationSpyScreenOffTest <- DataLocationSpyScreenOff[951:1187,]
rownames(LocationSpyScreenOffTest) <- NULL

##3.PaketFlood
DataPaketFlood1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/DOS_10minslog_data_screenOn.txt",
                               header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
DataPaketFlood2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/DOS_10minslog_data_screenOff.txt",
                               header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataPaketFlood3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/DOS_10minslog_wifi_screenOn.txt",
                               header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataPaketFlood4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/DOS_10minslog_wifi_screenOff.txt",
                               header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DataPaketFloodScreenOn <- rbind(DataPaketFlood1, DataPaketFlood3)##screen on data
DataPaketFloodScreenOff <- rbind(DataPaketFlood2, DataPaketFlood4)##screen off data
DataPaketFlood <- rbind(DataPaketFloodScreenOn, DataPaketFloodScreenOff)#All data

######## EXP I ####
PaketFloodScreenOnTrain <- DataPaketFloodScreenOn[1:944,]
PaketFloodScreenOnTest <- DataPaketFloodScreenOn[945:1182,]
rownames(PaketFloodScreenOnTest) <- NULL

PaketFloodScreenOffTrain <- DataPaketFloodScreenOff[1:960,]
PaketFloodScreenOffTest <- DataPaketFloodScreenOff[961:1200,]
rownames(PaketFloodScreenOffTest) <- NULL

#### combined malicious data
DataTotalMalwareScreenOn <- rbind(DataMailSpyScreenOn, DataLocationSpyScreenOn, DataPaketFloodScreenOn) #(1)->3556samples
DataTotalMalwareScreenOff <- rbind(DataMailSpyScreenOff, DataLocationSpyScreenOff, DataPaketFloodScreenOff) #(2)->3587
DataTotalMalware <- rbind(DataTotalMalwareScreenOn, DataTotalMalwareScreenOff) #(3)->7143

###################### BENIGN Utilities #######################
##Kik Messenger
Kik1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/kik_10minslog_data_screenOn.txt",
                              header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
Kik2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/kik_10minslog_wifi_screenOn.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
Kik3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/kik_10minslog_data_screenOff.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
Kik4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/kik_10minslog_wifi_screenOff.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
KikScreenOn <- rbind(Kik1, Kik2)##screen on data
KikScreenOff <- rbind(Kik3, Kik4)##screen off data
Kik <- rbind(KikScreenOn, KikScreenOff)#All data

######## EXP I ####
KikScreenOnTrain <- KikScreenOn[1:960,]
KikScreenOnTest <- KikScreenOn[961:1199,]
rownames(KikScreenOnTest) <- NULL

KikScreenOffTrain <- KikScreenOff[1:920,]
KikScreenOffTest <- KikScreenOff[921:1151,]
rownames(KikScreenOffTest) <- NULL

##Google Maps Search (GMS)
GMS1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/gms_10minslog_data_screenOn.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
GMS2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/gms_10minslog_data_screenOff.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:650,]
GMS3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/gms_10minslog_wifi_screenOn.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
GMS4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/gms_10minslog_wifi_screenOff.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
GMSScreenOn <- rbind(GMS1, GMS3)##screen on data
GMSScreenOff <- rbind(GMS2, GMS4)##screen off data
GMS <- rbind(GMSScreenOn, GMSScreenOff)#All data

######## EXP I ####
GMSScreenOnTrain <- GMSScreenOn[1:920,]
GMSScreenOnTest <- GMSScreenOn[921:1159,]
rownames(GMSScreenOnTest) <- NULL

GMSScreenOffTrain <- GMSScreenOff[1:992,]
GMSScreenOffTest <- GMSScreenOff[993:1241,]
rownames(GMSScreenOffTest) <- NULL

##Yelp
yelp1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/yelp_data_screenOn.txt",
                        header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
yelp2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/yelp_data_screenOff.txt",
                    header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
yelp3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/yelp_wifi_screenOn.txt",
                    header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
yelp4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/yelp_wifi_screenOff.txt",
                    header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
yelpScreenOn <- rbind(yelp1, yelp3)
yelpScreenOff <- rbind(yelp2, yelp4)
yelpData <- rbind(yelpScreenOn, yelpScreenOff)

######## EXP I ####
yelpScreenOnTrain <- yelpScreenOn[1:952,]
yelpScreenOnTest <- yelpScreenOn[952:1190,]
rownames(yelpScreenOnTest) <- NULL

yelpScreenOffTrain <- yelpScreenOff[1:960,]
yelpScreenOffTest <- yelpScreenOff[961:1200,]
rownames(yelpScreenOffTest) <- NULL

####combined benign utilities data
DataTotalBenignUtilScreenOn <- rbind(KikScreenOn, GMSScreenOn, yelpScreenOn) #(1)->3548
DataTotalBenignUtilScreenOff <- rbind(KikScreenOff, GMSScreenOff, yelpScreenOff) #(2)->3592
DataTotalBenignUtil <- rbind(DataTotalBenignUtilScreenOn, DataTotalBenignUtilScreenOff) #(3)->7140

###################### BENIGN Games #######################
##Drag Racing Game
DragRace1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/dragrace_10minslog_data_screenOn.txt",
                   header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
DragRace2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/dragrace_10minslog_data_screenOff.txt",
                        header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DragRace3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/dragrace_10minslog_wifi_screenOn.txt",
                        header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
DragRace4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/dragrace_10minslog_wifi_screenOff.txt",
                        header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
DragRaceScreenOn <- rbind(DragRace1, DragRace3)##screen on data
DragRaceScreenOff <- rbind(DragRace2, DragRace4)##screen off data
DragRaceData <- rbind(DragRaceScreenOn, DragRaceScreenOff)##all data

######## EXP I ####
DragRaceScreenOnTrain <- DragRaceScreenOn[1:960,]
DragRaceScreenOnTest <- DragRaceScreenOn[961:1200,]
rownames(DragRaceScreenOnTest) <- NULL

DragRaceScreenOffTrain <- DragRaceScreenOff[1:960,]
DragRaceScreenOffTest <- DragRaceScreenOff[961:1200,]
rownames(DragRaceScreenOffTest) <- NULL

##Skate Game
Skate1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/skate_10minslog_data_screenOn.txt",
                        header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
Skate2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/skate_10minslog_data_screenOff.txt",
                     header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
Skate3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/skate_10minslog_wifi_screenOn.txt",
                     header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
Skate4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/skate_10minslog_wifi_screenOff.txt",
                     header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
SkateScreenOn <- rbind(Skate1, Skate3)##screen on data
SkateScreenOff <- rbind(Skate2, Skate4)##screen off data
SkateData <- rbind(SkateScreenOn, SkateScreenOff)#all data

######## EXP I ####
SkateScreenOnTrain <- SkateScreenOn[1:960,]
SkateScreenOnTest <- SkateScreenOn[961:1210,]
rownames(SkateScreenOnTest) <- NULL

SkateScreenOffTrain <- SkateScreenOff[1:960,]
SkateScreenOffTest <- SkateScreenOff[961:1198,]
rownames(SkateScreenOffTest) <- NULL

##Teeter game
teeter1 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/teeter_wifi_screenOn.txt",
                     header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
teeter2 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/teeter_wifi_screenOff.txt",
                      header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
teeter3 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/teeter_data_screenOn.txt",
                      header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))
teeter4 <- read.table(file="/Users/flairyparagon/Desktop/202B-Project/DataSet/BenignAppsData/teeter_data_screenOff.txt",
                      header=TRUE, sep='\t', col.names=c('Plcd','Pcpu','Pwifi','Pdata','Pgps','type'))[1:600,]
teeterScreenOn <- rbind(teeter1, teeter3)
teeterScreenOff <- rbind(teeter2, teeter4)
teeterData <- rbind(teeterScreenOn, teeterScreenOff)

######## EXP I ####
teeterScreenOnTrain <- teeterScreenOn[1:906,]
teeterScreenOnTest <- teeterScreenOn[907:1133,]
rownames(teeterScreenOnTest) <- NULL

teeterScreenOffTrain <- teeterScreenOff[1:960,]
teeterScreenOffTest <- teeterScreenOff[961:1200,]
rownames(teeterScreenOffTest) <- NULL

####combined benign games data
DataTotalBenignGamesScreenOn <- rbind(DragRaceScreenOn, SkateScreenOn, teeterScreenOn) #(1)->3543
DataTotalBenignGamesScreenOff <- rbind(DragRaceScreenOff, SkateScreenOff, teeterScreenOff) #(2)->3598
DataTotalBenignGames <- rbind(DataTotalBenignGamesScreenOn, DataTotalBenignGamesScreenOff) #(3)->7141

################## Final Training data ###############
######## EXP 3 ####
DataTotalBenignScreenOn <- DataTotalBenignGamesScreenOn #Or DataTotalBenignUtilScreenOn
DataTotalBenignScreenOff <- DataTotalBenignGamesScreenOff #Or DataTotalBenignUtilScreenOff
dataSetScreenOn <- rbind(DataTotalMalwareScreenOn, DataTotalBenignScreenOn) #(1)
dataSetScreenOff <- rbind(DataTotalMalwareScreenOff, DataTotalBenignScreenOff) #(2)

######## EXP 4 ####
dataSetWhole <- rbind(dataSetScreenOn, dataSetScreenOff) #(3)
write.table(dataSet, file="/Users/flairyparagon/Desktop/202b_data", sep="\t")

######## EXP I ####
exp1_ScreenOn_dataSet1 <- rbind(MailSpyScreenOnTrain, LocationSpyScreenOnTrain, PaketFloodScreenOnTrain,
                                DragRaceScreenOnTrain, SkateScreenOnTrain, teeterScreenOnTrain)#games
exp1_ScreenOn_dataSet2 <- rbind(MailSpyScreenOnTrain, LocationSpyScreenOnTrain, PaketFloodScreenOnTrain,
                                KikScreenOnTrain, GMSScreenOnTrain, yelpScreenOnTrain)#utilities
exp1_ScreenOff_dataSet1 <- rbind(MailSpyScreenOffTrain, LocationSpyScreenOffTrain, PaketFloodScreenOffTrain,
                                DragRaceScreenOffTrain, SkateScreenOffTrain, teeterScreenOffTrain)#games
exp1_ScreenOff_dataSet2 <- rbind(MailSpyScreenOffTrain, LocationSpyScreenOffTrain, PaketFloodScreenOffTrain,
                                KikScreenOffTrain, GMSScreenOffTrain, yelpScreenOffTrain)#utilities

######### EXP 2 ###
exp2_ScreenOn_dataSet1 <- rbind(DataMailSpyScreenOn, DataLocationSpyScreenOn,
                                DragRaceScreenOn, SkateScreenOn)
exp2_ScreenOn_dataSet2 <- rbind(DataMailSpyScreenOn, DataLocationSpyScreenOn,
                                KikScreenOn, GMSScreenOn)  
exp2_ScreenOff_dataSet1 <- rbind(DataMailSpyScreenOff, DataLocationSpyScreenOff,
                                DragRaceScreenOff, SkateScreenOff)
exp2_ScreenOff_dataSet2 <- rbind(DataMailSpyScreenOff, DataLocationSpyScreenOff,
                                KikScreenOff, GMSScreenOff) 

dataSet <- exp1_ScreenOff_dataSet2
dataSet$type <- as.factor(dataSet$type)

################# Final Test Set ###################
######## EXP 3 ####
testSetScreenOn <- DataTotalBenignUtilScreenOn #Or DataTotalBenignGamesScreenOn
testSetScreenOff <- DataTotalBenignUtilScreenOff #Or DataTotalBenignGamesScreenOff

######## EXP 4 ####
testSetWhole <- rbind(testSetScreenOn, testSetScreenOff)

######## EXP I ####
exp1_ScreenOn_testSet1 <- rbind(MailSpyScreenOnTest, LocationSpyScreenOnTest, PaketFloodScreenOnTest,
                                DragRaceScreenOnTest, SkateScreenOnTest, teeterScreenOnTest)#games
exp1_ScreenOn_testSet2 <- rbind(MailSpyScreenOnTest, LocationSpyScreenOnTest, PaketFloodScreenOnTest,
                                KikScreenOnTest, GMSScreenOnTest, yelpScreenOnTest)#utilities
exp1_ScreenOff_testSet1 <- rbind(MailSpyScreenOffTest, LocationSpyScreenOffTest, PaketFloodScreenOffTest,
                                 DragRaceScreenOffTest, SkateScreenOffTest, teeterScreenOffTest)#games
exp1_ScreenOff_testSet2 <- rbind(MailSpyScreenOffTest, LocationSpyScreenOffTest, PaketFloodScreenOffTest,
                                 KikScreenOffTest, GMSScreenOffTest, yelpScreenOffTest)#utilities
######### EXP 2 ###
exp2_ScreenOn_testSet1 <- rbind(DataPaketFloodScreenOn, teeterScreenOn)
exp2_ScreenOn_testSet2 <- rbind(DataPaketFloodScreenOn, yelpScreenOn)  
exp2_ScreenOff_testSet1 <- rbind(DataPaketFloodScreenOff, teeterScreenOff)
exp2_ScreenOff_testSet2 <- rbind(DataPaketFloodScreenOff, yelpScreenOff) 

testSet <- exp1_ScreenOff_testSet2[,1:5]
##TODO: 
##1. Train using screen on data and then test using screen on test data
##2. repeat same for screen off data
##3. repeat same for all data
###################### RANDOM FOREST ####################
fit <- randomForest(type~., data=dataSet, proximity=TRUE)
plot(margin(fit))
plot(fit, log="y")
partialPlot(fit, dataSet, Pcpu, "malicious")
MDSplot(fit, dataSet$type, k=2) #stucks
plot(getTree(fit))
plot(fit, type="l")
# summarize the fit
summary(fit)
print(fit$importance)

###################### DECISION TREE #####################
# grow tree 
fit <- rpart(type~., method="class", data=dataSet)
fit <- ctree(type~., data=dataSet)
plot(fit)
printcp(fit) # display the results 
plotcp(fit) # visualize cross-validation results 
summary(fit) # detailed summary of splits

# plot tree 
plot(fit, uniform=TRUE, main="Classification Tree")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

# create attractive postscript plot of tree 
post(fit, file = "/Users/flairyparagon/Desktop/202B-Project/Trees/tree.ps", title = "Classification Tree")

# prune the tree 
pfit<- prune(fit, cp=fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])
printcp(pfit)

# plot the pruned tree 
plot(pfit, uniform=TRUE, main="Pruned Classification Tree")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)
post(pfit, file = "/Users/flairyparagon/Desktop/ptree.ps", title = "Pruned Classification Tree")

###################### LINEAR REGRESSION #################
fit <- lm(type~., data=dataSet)
fitted(fit)
# diagnostic plots 
layout(matrix(c(1,2,3,4),2,2)) # 4 graphs/page 
plot(fit) 

#summarize the fit
summary(fit)

#calculate goodness of fit
#k-fold cross validation
cv.lm(df=dataSet, fit, m=3) # DRAW 3 fold cross-validation

theta.fit <- function(x,y){lsfit(x,y)}
theta.predict <- function(fit,x){cbind(1,x)%*%fit$coef} 
# matrix of predictors
X <- as.matrix(dataSet[,1:5])
# vector of predicted values
y <- as.matrix(dataSet[,6]) 

results <- crossval(X,y,theta.fit,theta.predict,ngroup=10)
cor(y, fit$fitted.values) # raw correlation
cor(y,results$cv.fit) # cross-validated correlation

###################### NAIVE BAYES #####################
fit = train(dataSet[,1:5], dataSet[,6],'nb',trControl=trainControl(method='cv',number=10))

###################### PREDICTION #####################
predictions <- as.numeric(as.vector(predict(fit, testSet)))
original <- exp1_ScreenOff_testSet2[,6]
print(predictions)
print(original)
#plot(predictions)

###################### CALCULATE GOODNESS #####################
cor(original, predictions)
true_instances <- length(which(original == predictions))
total_instances <- length(original)
Accuracy <- true_instances/total_instances
print(Accuracy)
###################### VISUALIZE ####################
res <- stack(data.frame(Observed = original, Predicted = predictions))
res <- cbind(res, x=seq(1:length(predictions)))
head(res)
xyplot(values ~ x, data = res, group = ind, auto.key=TRUE)

boxplot(type~., data=dataSet
        notch=T, varwidth=T, las=1, tcl=.5,
        xlab=expression("B minus V"),
        ylab=expression("V magnitude"),
        main="Can you find the red giants?",
        cex=1, cex.lab=1.4, cex.axis=.8, cex.main=1)
#axis(2, labels=F, at=0:12, tcl=-.25)
#axis(4, at=3*(0:4))

###Display Results
## EXP 1 ##
x<-1:3
models = c("randomForest", "decisionTree", "Naive Bayes")
accuracies_exp1_a = c(0.90909, 0.8965035, 0.6125874)
accuracies_exp1_b = c(0.7629371, 0.7307692, 0.6307692)
accuracies_exp1_c = c(0.7344948, 0.7344948, 0.5045296)
accuracies_exp1_d = c(0.7028532, 0.704245, 0.6416145)

plot(x, accuracies_exp1_a, xlab='', xaxt='n', ylim=c(0.3,1), pch=21, ylab="Accuracy", cex.lab=0.7, cex.axis=0.7)
title(main="Experiment 1: Train set: 80%, Test set: 20%", cex.main=0.6)
axis(1, at=x, labels=models, cex.axis=0.6)
grid()
lines(x,accuracies_exp1_a, col="red", type="b", lwd=1.5, lty=2)
points(x, accuracies_exp1_b, col="blue", pch=22)
lines(x, accuracies_exp1_b, col="blue", type="b", lwd=1.5, lty=1)
points(x, accuracies_exp1_c, col="green", pch=24)
lines(x, accuracies_exp1_c, col="green", type="b", lwd=1.5, lty=3)
points(x, accuracies_exp1_d, col="purple", pch=23)
lines(x, accuracies_exp1_d, col="purple", type="b", lwd=1.5, lty=4)
legend(2.4, 1, c("screen on, game data","screen on, util data","screen off, game data","screen off, util data"), 
       cex=0.4, col=c("red","blue","green","purple"), pch=c(21,22,24,23), lty=c(2,1,3,4), bty="n")

## EXP 2 ##
accuracies_exp2_a = c(0.6146868, 0.6220302, 0.7356371)
accuracies_exp2_b = c(0.7554806, 0.6382799, 0.5952782)
accuracies_exp2_c = c(0.6275, 0.7475, 0.5533333)
accuracies_exp2_d = c(0.6179167, 0.55125, 0.4995833)

plot(x, accuracies_exp2_a, xlab='', xaxt='n', ylim=c(0.3,1), pch=21, ylab="Accuracy", cex.lab=0.7, cex.axis=0.7)
title(main="Experiment 2: Train Test: 2 malware + 2 games, Test set: 1 malware + 1 game", cex.main=0.55)
axis(1, at=x, labels=models, cex.axis=0.6)
grid()
lines(x,accuracies_exp2_a, col="red", type="b", lwd=1.5, lty=2)
points(x, accuracies_exp2_b, col="blue", pch=22)
lines(x, accuracies_exp2_b, col="blue", type="b", lwd=1.5, lty=1)
points(x, accuracies_exp2_c, col="green", pch=24)
lines(x, accuracies_exp2_c, col="green", type="b", lwd=1.5, lty=3)
points(x, accuracies_exp2_d, col="purple", pch=23)
lines(x, accuracies_exp2_d, col="purple", type="b", lwd=1.5, lty=4)
legend(2.4, 1, c("screen on, game data","screen on, util data","screen off, game data","screen off, util data"), 
       cex=0.4, col=c("red","blue","green","purple"), pch=c(21,22,24,23), lty=c(2,1,3,4), bty="n")

## EXP 3 ##
accuracies_exp3_a = c(0.3260992, 0.2770575, 0.9901353)
accuracies_exp3_b = c(0.7686526, 0.9075724, 0.9966592)
## EXP 4 ##
accuracies_exp4 = c(0.539916, 0.6215686, 0.9897759)

plot(x, accuracies_exp3_a, xlab='', xaxt='n', ylim=c(0.3,1), pch=21, ylab="Accuracy", cex.lab=0.7, cex.axis=0.7)
title(main="Experiment 3 & 4: Train Test: all malware + all games, Test set: all utils", cex.main=0.55)
axis(1, at=x, labels=models, cex.axis=0.6)
grid()
lines(x,accuracies_exp3_a, col="red", type="b", lwd=1.5, lty=2)
points(x, accuracies_exp3_b, col="blue", pch=22)
lines(x, accuracies_exp3_b, col="blue", type="b", lwd=1.5, lty=1)
points(x, accuracies_exp4, col="purple", pch=23)
lines(x, accuracies_exp4, col="purple", type="b", lwd=1.5, lty=3)
legend(1, 1, c("screen on","screen off","screen on + off"), 
       cex=0.4, col=c("red","blue","purple"), pch=c(21,22,23), lty=c(2,1,3), bty="n")
