Practical Machine Learning Project Writeup
==========================================

I used the Caret package in R for analyzing the data and predicting the "classe" based on the data collected from the various sensors/devices. I use Boosted Decision Tree for building my prediction model. In particular, I use the "GBM" package in R to perform my analysis. Below I describe the different steps used in my final solution


I divided my dataset to training and testing set using createDataPartition. I divided the dataset into 75% training and 25% testing. 

# Data Cleaning

## Removing columns that will not generalize to future samples
After downloading the pml-training.csv file and loading it into R, the first thing I wanted to do was identify columns that I believed won't be useful when predicting for other samples not in my training set. For example, one of the columns in the dataset is "user_name". If my prediction model uses this column, then it might give accurate predictions for my training set but it will not generalize to accurately predict the classe for device reading for other users not in my traning set. It was a laborious and subjective step but I was trying to understand what inform each column captures so that I can decide if it is worth keeping in my model or not. I removed the following columns in this step:
* user_name
* raw_timestamp_part_1
* raw_timestamp_part_2
* cvtd_timestamp

## Cleaning the data values

I inspected the individual values in the training file. I noticed that some of the cells had value "" or ""#DIV/0!". Clearly, these did not look like valid recordings and so I replaced them with NA. 

> Note: Even after replacing the above character values with NA, the R data frame continues to maintain the class of these columns as factors. I guess this is because the column type is determined at the time the data is read but not re-evaluated as the values change. So I had to manually coerce many of the columms to have type "numeric" using lapply and as.numeric


## Pre-processing

Once convinced that individual recordings are valid, I then inspected each column to identify columns with little to no variance. For this, I used the nearZeroVar function with uniqueCut=0.1 and default settings otherwise. I removed the columns that the nearZeroVar function identified.

The only outstanding issue now was the NA values because the samples with NA are ignored by the train/predict function. I used "knnImpute" preprocessing step to fill in the NA values. 

# Training the model

For training, I decided to use the Gradient Boosted Method ("gbm") for training. The first time I ran the train function with just the training data and method set to "gbm". After trying a number of options, the training function reported back that the best accuracy was obtained at n.trees=50. Next, I decided to better control my experiment by controlling the turning parameters myself by specifying the tuneGrid parameter. After trying multiple parameters, I decided on using: interaction.depth=2, n.trees=50, shrinkage=0.1. I used 10-fold cross validation to avoid over-fitting.

Using this, I got:

  Accuracy  Kappa  Accuracy SD  Kappa SD
  1         0.999  0.000574     0.000725

These results were good but a little scary because I thought I might have overfit my decision tree for my training data. I did not want to test my model on the testing data because I did not have a validation set and so I will get to run my model on the testing set only once. I performed repeated cross validation (repeatedcv) with 10 repeatitions but that did not change my accuracy, which gave me higher confidence.  

# Prediction

I performed the same preprocessing steps on my testing data as well. I got very very good results.

* Prediction    A    B    C    D    E
* A 1395    0    0    0    0
* B    0  949    0    0    0
* C    0    0  855    0    0
* D    0    0    0  804    0
* E    0    0    0    0  901

Overall Statistics
                                     
               Accuracy : 1          
                 95% CI : (0.9992, 1)
    No Information Rate : 0.2845     
    P-Value [Acc > NIR] : < 2.2e-16  
                                     
                  Kappa : 1          
 Mcnemar's Test P-Value : NA         

Statistics by Class:

Sensitivity            1.0000   1.0000   1.0000   1.0000   1.0000
Specificity            1.0000   1.0000   1.0000   1.0000   1.0000
Pos Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
Neg Pred Value         1.0000   1.0000   1.0000   1.0000   1.0000
Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
Detection Rate         0.2845   0.1935   0.1743   0.1639   0.1837
Detection Prevalence   0.2845   0.1935   0.1743   0.1639   0.1837
Balanced Accuracy      1.0000   1.0000   1.0000   1.0000   1.0000

# Summary
