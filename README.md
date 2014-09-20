Practical Machine Learning Project Writeup
==========================================

I used the Caret package in R for analyzing the data and predicting the "classe" based on the data collected from the various sensors/devices. I use Boosted Decision Tree for building my prediction model. In particular, I use the "GBM" package in R to perform my analysis. Below I describe the different steps used in my final solution

# Data Cleaning

After downloading the pml-training.csv file and loading it into R, the first thing I wanted to do was identify columns that I believed won't be useful when predicting for other samples not in my training set. For example, one of the columns in the dataset is "user_name". If my prediction model uses this column, then it might give accurate predictions for my training set but it will not generalize to accurately predict the classe for device reading for other users not in my traning set. It was a laborious and subjective step but I was trying to understand what inform each column captures so that I can decide if it is worth keeping in my model or not. I removed the following columns in this step:
* user_name
* raw_timestamp_part_1
* raw_timestamp_part_2
* cvtd_timestamp



# Training the model
# Prediction

# Summary
