# Unquantified observational uncertainty obscures major feature importances of the random forest model for the NH3 emission factors


## Dataset Information

•	Based on the literature information in Supporting Information Table 3 provided by Xu et al., we excluded Reference 186 (lacking titles), Reference 100 and 252 (with restricted access), and Reference 190 (unlocatable by title search). Then a total of 2676 data samples comprising 14 features and one dependent variable EF were obtained from the remaining 307 articles formed the comprehensive dataset D6, where the sample features and the dependent variable of the dataset are consistent with those used by Xu et al. Additionally, according to the e-mail communications with the corresponding author Professor Zheng, the total dataset was partitioned into five subsets and recombined to form five subdatasets (D0, D1, D2, D3, and D4). Detailed information on the combined datasets is presented in Supplementary Table 1.

•	Compared with the multi-way importance plots of datasets D0, D1, D2, D3, and D4, only that of dataset D2 showed substantial changes. The multi-way importance plots of dataset D2 reveal that when using MSE increases, node purity increases, and P values as evaluation metrics, the feature Tem is the most significant. 

•	Considering that the average EF value for dataset D2 (0.105) is slightly higher than that of dataset D0 (0.098), and that high temperatures significantly promote ammonia volatilization from fertilizers, leading to an increase in ammonia emission factors, we excluded samples that were both in the top 20% of temperature observations and the top 1% of EF observation samples from dataset D2 (see Supplementary Fig. 29). The excluded samples involve all 9 samples from reference 54 and 3 samples from reference 287. Further inspection of these samples revealed significant differences in the EF values of Reference 287 under nearly identical input feature conditions. Finally, we excluded all samples from references 54 and 287. Therefore, we removed samples originating from References 54 and 287 (which severely affected the results) from dataset D6 (a total of 41 samples, accounting for 1.53%) to obtain dataset D5.

•	Samples of rice, wheat, and maize accounted for 41.63%, 23.69%, and 34.68% of the total data items in the dataset D6, respectively. A total of 66.03% and 33.97% of the data samples came from China and non-China regions, respectively.

•	The better results with higher R2 and lower RMSE values for all six methods (Supplementary Fig. 1a) relative to those in Supplementary Fig. 7a of Xu et al.1 suggest that the empirical results of Xu et al.1 may not be robust because of the systematic biases from their zero-N methodologies.

•	Our relationships between the feature importance rankings produced according to various measures show higher Pearson correlation coefficients between two compared indicators for Case a (see Supplementary Fig. 4) than those in Supplementary Fig. 10 of Xu et al.1.

•	For example, a control plot with higher native soil nitrogen mineralization (e.g. organic-rich soil) would underestimate fertilizer-induced NH3, artificially lowering EFs8, and a zero-N control from a prior year may not reflect current soil N mineralization rates, especially under changing climatic conditions.  


## Model Details

•	The cropland NH3 emission factor regressor is trained to estimate the NH3 emission factors during crop growth season based on various factors, such as climate, soil characteristics, crop types, irrigation water, and fertilization and tillage practices. 

•	All six different classic ML models were each trained on dataset D0 through D6.

•	At first, one-hot encoding was applied to the five crop management-related variables in the dataset, namely Ftype, Ctype, NP, STP and FAT, to ensure that machine learning models can correctly recognize these variables. The Box-Cox transformations were used on EFs for different crops to reduce skewness, stabilize variance, and approximate Gaussian distributions. 

•	Next, the dataset was randomly split into training (80%) and test (20%) subsets. Hyperparameters were optimized via grid search on the entire training set to explore the parameter spaces of various machine learning algorithms, including ridge regression, SVR, FNN, ResNet, GBDT and RF. Except for the random forest model, Z-score normalization was used as the input features for the other models in the model training process. 

•	Finally, the performances of all models were evaluated on the test sets of datasets D0, D1, D2, D3, D4, D5 and D6, with both the coefficient of determination (R²) and the root mean square error (RMSE) as the metrics.

•	On each training set of datasets D0, D1, D2, D3, D4, D5 and D6, the RF model comprising 100 regression trees was trained, and meanwhile the performance achieved on the Out-of-Bag dataset was shown, respectively.

•	We used the model performance achieved on the test set as the final evaluation metric because the RF model did not learn the test set during the training process. To evaluate the ML model performance on the test set, we apply the inverse Box-Cox transformation to both observed values of the Box-Cox transformed EFs and their predictions, then assess the prediction accuracy against the original EFs data.

•	With each dataset, we use the pre-trained random forest model to evaluate the prediction performance of EFs for samples from Chinese and non-Chinese experimental fields. 

## Quantitative Analyses

• Shown in the original paper.
