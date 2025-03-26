library(readxl)
library(randomForest)
library(randomForestExplainer)
library(tidyverse)
source("evaluation_metrics.R")
###########################################################
training <- read_excel("all(3.21).xlsx", sheet = 1) #读取全部数据
training <- as.data.frame(training)

new_names <- c("EFs", "Ftype(AN)", "Ftype(Manure)", "Ftype(Others)", "Ftype(U)", 
               "NP(DPM)", "NP(Mix)","NP(SBC)", "STP(CT)", "STP(NT)", "Ctype(Maize)", 
               "Ctype(Rice)", "Ctype(Wheat)", "Tem", "FAT", "Nrate", "BD", "SOC", 
               "TN", "CEC", "pH", "Clay", "Water input", "Ftype(EEF)")

names(new_names) <- c("EFs", "Ftype_AN_", "Ftype_Manure", "Ftype_Others", 
                      "Ftype_U", "NP_DPM", "NP_Mix","NP_SBC", "STP_CT", 
                      "STP_NT", "Ctype_Maize", "Ctype_Rice", "Ctype_Wheat", 
                      "Tem", "FAT", "Nrate", "BD", "SOC", "TN", "CEC", "pH", 
                      "Clay", "Water_input", "Ftype_EEF")

training <- rename(training, all_of(new_names))
###########################################################
#select the optimum parameter mtry

n_cols = floor(dim(training)[2]/2)

mse <- numeric(n_cols)
rsq <- numeric(n_cols)

n_tree <- 500

for(i in seq(n_cols)){
  fit <-randomForest(EFs ~ ., data = training, ntree = n_tree, mtry = i)
  mse[i] <- mean(fit$mse)
  rsq[i] <- mean(fit$rsq)}

plot(seq(n_cols), mse, type='b', xlab='mtry', main='OOB Errors')
abline(v=which.min(mse), lty=2)
print(c('最小误差:', round(mse[which.min(mse)],4)))
print(c('最小误差对应的可决系数:', round(rsq[which.min(mse)],2)))
###########################################################
# estimate model parameters
set.seed(123)
forest <- randomforest <- randomForest(EFs ~ .,
                                       data = training,
                                       ntree = n_tree,
                                       localImp = TRUE,
                                       mtry = which.min(mse),
                                       proximity = TRUE,
                                       importance = TRUE)

print(c('模型平均误差:', round(mean(forest$mse),4)))
print(c('模型可决系数:', round(mean(forest$rsq),2)))
###########################################################

pre_train <- predict(forest,newdata = training[,c(seq(2,length(training)))])
plot(training[[1]], pre_train, main='随机森林模型预测效果', xlab='true_train')
abline(0, 1, col='red', lty=1, lwd=2)

text(-2, 7, as.expression(
  substitute(R^2==a, list(a=round(mean(forest$rsq),2)))), cex=0.75)
text(-2, 8, as.expression(
  substitute(RMSE==a, list(a=round(mean(forest$mse),2)))), cex=0.75)
###########################################################
#feature important
varImpPlot(forest, scale=FALSE, main='Variable Importance Plot')


importance_vars <- importance(forest)
importance_vars <- tibble(var = rownames(importance_vars), 
                          IncMSE = importance_vars[,1],
                          IncNodePurity = importance_vars[,2])
importance_vars <- importance_vars[order(importance_vars$IncNodePurity, decreasing=TRUE),]
###########################################################

partialPlot(forest, training, x.var=Water_input)
partialPlot(forest, training, x.var=Tem)
###########################################################
## Distribution of minimal depth

min_depth_frame <- min_depth_distribution(forest)
head(min_depth_frame, n = which.min(mse))

plot_min_depth_distribution(min_depth_frame, 
                            mean_sample = "relevant_trees",
                            k = 16,
                            mean_scale=FALSE, 
                            main= "Distribution of minimal depth") 
###########################################################
# Various variable importance measures

importance_frame <- measure_importance(forest) 
importance_frame
###########################################################
## Multi-way importance plot

plot_multi_way_importance(importance_frame, 
                          x_measure = "mse_increase",
                          y_measure = "node_purity_increase",
                          size_measure = "p_value", 
                          min_no_of_trees = 0,
                          no_of_labels = which.min(mse))
###########################################################
# Compare different rankings

plot_importance_rankings(importance_frame,
                         measures=c("mean_min_depth", 
                                    "no_of_nodes", 
                                    "times_a_root",
                                    "node_purity_increase", 
                                    "mse_increase"))


frame_names <- c("variable", "mean_min_depth", "no_of_nodes",
                 "mse_increase", "node_purity_increase", "no_of_trees", 
                 "times_a_root","p_value")  

names(frame_names) <- c("variable", "MMD", "NON",
                        "MSEI", "NPI", "NOT", 
                        "NORT","PV")

importance_frame1 <- rename(importance_frame, all_of(frame_names))
plot_importance_rankings(importance_frame1,
                         measures=c("MMD","NON","NORT","NPI","MSEI"))
###########################################################
## Variable interactions

vars <- important_variables(forest, k = which.min(mse),
                            measures = c("mean_min_depth", "no_of_trees"))

interactions_frame <- min_depth_interactions(forest, vars, 
                                             mean_sample="relevant_trees")

head(interactions_frame[order(interactions_frame$occurrences, decreasing = TRUE), ])
plot_min_depth_interactions(interactions_frame)


#修改交互变量名称
interactions <- interactions_frame
interactions$root_variable <- gsub("Ctype_Rice", "Rice", interactions$root_variable)
interactions$root_variable <- gsub("NP_DPM", "DPM", interactions$root_variable)
interactions$root_variable <- gsub("Water_input", "Water input", interactions$root_variable)
interactions$root_variable <- gsub("Ftype_U", "U", interactions$root_variable)
interactions$root_variable <- gsub("Ftype_EEF", "EEF", interactions$root_variable)


interactions$interaction <- gsub("Ctype_Rice", "Rice", interactions$interaction)
interactions$interaction <- gsub("NP_DPM", "DPM", interactions$interaction)
interactions$interaction <- gsub("Water_input", "Water input", interactions$interaction)
interactions$interaction <- gsub("Ftype_U", "U", interactions$interaction)
interactions$interaction <- gsub("Ftype_EEF", "EEF", interactions$interaction)

plot_min_depth_interactions(interactions)


