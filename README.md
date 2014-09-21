Practical Machine Learning Project Writeup
==========================================

I used the Caret package in R for analyzing the data and predicting the "classe" based on the data collected from the various sensors/devices. I use Boosted Decision Tree for building my prediction model. In particular, I use the "GBM" package in R to perform my analysis. Below I describe the different steps used in my final solution


I divided my dataset to training and testing set using createDataPartition. I divided the dataset into 75% training and 25% testing. 

# Data Cleaning

## Removing columns that will not generalize to future samples (Out-of-sample errors)
After downloading the pml-training.csv file and loading it into R, the first thing I wanted to do was identify columns that I believed won't be useful when predicting for other samples not in my training set. For example, one of the columns in the dataset is "user_name". If my prediction model uses this column, then it might give accurate predictions for my training set but it will not generalize to accurately predict the classe for device reading for other users not in my traning set. It was a laborious and subjective step but I was trying to understand what inform each column captures so that I can decide if it is worth keeping in my model or not. I removed the following columns in this step:
* X
* user_name
* raw_timestamp_part_1
* raw_timestamp_part_2
* cvtd_timestamp
*


> Note: First time around, I missed the column "X" in this step. This lead to near perfect prediction accuracy for my training and testing set (100% accuracy for both in-sampel and out-of-sample error). But, it looked too good to be true. When I ran the pml-testing.csvm and got all A's I realized my model must have some dependency on the row number because all the class samples are ordered in the pml-training.csv file.

## Cleaning the data values

I inspected the individual values in the training file and plotted the histograms of each column. I noticed that some of the cells had value "" or ""#DIV/0!". Clearly, these did not look like valid recordings and so I replaced them with NA. 

> Note: Even after replacing the above character values with NA, the R data frame continues to maintain the class of these columns as factors. I guess this is because the column type is determined at the time the data is read but not re-evaluated as the values change. So I had to manually coerce many of the columms to have type "numeric" using lapply and as.numeric


## Pre-processing

__Reducing Out-of-sample error by avoiding skewed variables__
Once convinced that individual recordings are valid, I then inspected each column to identify columns with skewed distributions or little to no variance. For this, I used the nearZeroVar function with uniqueCut=0.1 and default settings otherwise. I removed the columns that the nearZeroVar function identified.

The only outstanding issue now was the NA values because the samples with NA are ignored by the train/predict function. I used "knnImpute" preprocessing step to fill in the NA values. 

# Training the model

For training, I decided to use the Gradient Boosted Method ("gbm") for training. The first time I ran the train function with just the training data and method set to "gbm". After trying a number of options, the training function reported back that the best accuracy was obtained at n.trees=50. Next, I decided to better control my experiment by controlling the turning parameters myself by specifying the tuneGrid parameter. After trying multiple parameters, I decided on using: interaction.depth=2, n.trees=50, shrinkage=0.1. I used 10-fold cross validation to avoid over-fitting.

Using this, I got:

>  Accuracy  Kappa  Accuracy SD  Kappa SD
   0.96      0.95   0.00417      0.00527 



These results were good but a little scary because I thought I might have overfit my decision tree for my training data. I did not want to test my model on the testing data because I did not have a validation set and so I will get to run my model on the testing set only once. I performed repeated cross validation (repeatedcv) with 10 repeatitions but that did not change my accuracy, which gave me higher confidence.  

# Prediction

I performed the same preprocessing steps on my testing data as well. I got good results.

Overall Statistics
                                          
               Accuracy : 0.9619          
                 95% CI : (0.9561, 0.9671)
    No Information Rate : 0.2845          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.9518          
 Mcnemar's Test P-Value : 0.0002105       

Statistics by Class:

* Class: A Class: B Class: C Class: D Class: E
* Sensitivity            0.9835   0.9452   0.9544   0.9490   0.9645
* Specificity            0.9909   0.9871   0.9830   0.9934   0.9980
* Pos Pred Value         0.9772   0.9462   0.9220   0.9658   0.9909
* Neg Pred Value         0.9934   0.9869   0.9903   0.9900   0.9921
* Prevalence             0.2845   0.1935   0.1743   0.1639   0.1837
* Detection Rate         0.2798   0.1829   0.1664   0.1556   0.1772
* Detection Prevalence   0.2863   0.1933   0.1805   0.1611   0.1788
* Balanced Accuracy      0.9872   0.9662   0.9687   0.9712   0.9812

# Summary

In this project, the most time I spent was getting data into shape so that the training and prediction functions in Caret package would play nicely with them. Also, many of the insights/issues I identified were by manually inspecting the column titles or by plotting the histogram of each column. My intuition told me that this classification problem would be much more amenable to a decision tree that is non-linear in the feature vectors and does not depend on scaling of the individual columns instead of a linear equation of the different columns involved. The high accuracy of my model confirms that intuition.
