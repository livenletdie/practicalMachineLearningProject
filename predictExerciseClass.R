# This file requies the pml-training.csv and pml-testing.csv to be in the same directory where the program is being run
library(caret)
library(ggplot2)

infoTable <- read.csv("pml-training.csv")
str(infoTable)
inTrain <- createDataPartition(y = infoTable$classe, p = 0.75, list = FALSE)
training <- infoTable[inTrain,]
testing <- infoTable[-inTrain,]
ignoreColumnList <- c("user_name", "raw_timestamp_part_1", "raw_timestamp_part_2", "cvtd_timestamp", "new_window", "num_window", "X")
trainingSlim <- training[, !(names(training) %in% ignoreColumnList)]
str(trainingSlim)
trainingSlim[trainingSlim == ""] = NA
trainingSlim[trainingSlim == "#DIV/0!"] = NA
trainingSlimNumeric <- as.data.frame(lapply(trainingSlim, as.numeric))
nearZeroColumns <- nearZeroVar(trainingSlimNumeric, uniqueCut=0.1)
trainingSlimVariant <- trainingSlimNumeric[,-nearZeroColumns]
str(trainingSlimVariant)


trainingSlimVariant$classe <- trainingSlim$classe
fitControl <- trainControl(method = "cv", number=10, repeats=5)
gbmGrid <- expand.grid(interaction.depth=c(4), n.trees=c(100), shrinkage=0.1)
modelFit1 <- train(classe ~ ., data = trainingSlimVariant, method = "gbm", preProcess = c("knnImpute"), na.action = na.pass, trControl = fitControl, tuneGrid = gbmGrid)
modelFit1

testingSlim <- testing[, !(names(testing) %in% ignoreColumnList)]
testingSlim[testingSlim == ""] <- NA
testingSlim[testingSlim == "#DIV/0!"] <- NA
testingSlimNumeric <- as.data.frame(lapply(testingSlim, as.numeric))
predArr <- predict(modelFit1, newdata=testingSlimNumeric, na.action = na.pass)
confusionMatrix(predArr, testing$classe)

testingFinal <- read.csv("pml-testing.csv")
testingSlim <- testingFinal[, !(names(testingFinal) %in% ignoreColumnList)]
testingSlim[testingSlim == ""] <- NA
testingSlim[testingSlim == "#DIV/0!"] <- NA
testingSlimNumeric <- as.data.frame(lapply(testingSlim, as.numeric))
predict(modelFit1, newdata=testingSlimNumeric, na.action = na.pass)
