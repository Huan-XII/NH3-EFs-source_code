# The dataset’s handling of zero-N controls introduces unresolved uncertainties for the NH₃ emission factors in the random forest model


## Dataset Information

•	In the data samples of Supplementary Table 3 provided by Xu et al., we retained only the sample data from the actual zero-N control group experiments conducted within the same experimental field plot and on this basis correspondingly supplemented the missing ammonia emission experimental data of the zero-N control group in the table. After removing four groups of abnormal observation samples with negative results from the farmland ammonia emission control group experiments, a total of 1695 data samples comprising 16 features were obtained. Following the methodology described by Xu et al., we calculated the corresponding ammonia emission factors (EFs), i.e., the dependent variable, using three relevant feature variables from the sample data. Ultimately, the dataset used for machine learning model analysis consists of 1695 data samples, including 14 features and one dependent variable EFs, where the sample features and the dependent variable of the dataset are consistent with those used by Xu et al.

## Model Details
•	The cropland NH3 emission factors regressor is trained to estimate the NH3 emission factors during crop growth season based on various factors, such as climate, soil characteristics, crop types, irrigation water, and fertilization and tillage practices. 
•	At first, one-hot encoding was applied to the five crop management-related variables in the dataset, namely Ftype, Ctype, NP, STP and FAT, to ensure that machine learning models can correctly recognize these variables. The Box-Cox transformations were used on EFs for different crops to reduce skewness, stabilize variance, and approximate Gaussian distributions. 
•	Next, the dataset was randomly split into training (80%) and test (20%) subsets. Hyperparameters were optimized via grid search on the entire training set to explore the parameter spaces of various machine learning algorithms, including ridge regression, SVR, FNN, ResNet, GBDT and RF. Except for the random forest model, Z-score normalization was used on the input features for the other models in the model training process. 
•	Finally, all model performances were evaluated on the test set with the coefficient of R² and RMSE as the metrics.

## Quantitative Analyses

• Shown in the original paper.
