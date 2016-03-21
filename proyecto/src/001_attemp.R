##########################################################################
## PEDS 2015 (Segunda edicion)
## Trabajo fin de Experto: Kaggle - Telstra Network Disruptions
## Rafael Enriquez-Herrador
##    rafael.enriquez@live.u-tad.com
##    rafenher07@gmail.com
##########################################################################

library(data.table)
library(randomForest)
library(corrplot)
library(gmodels)

## Train Random Forest
trainRFModel <- function(train.data, train.class, ntrees) {
  rf.model <- randomForest(train.data, y = train.class, method = "class", 
                           ntree = ntrees, do.trace = T, na.action = na.omit)
  return(rf.model)
}

locations_feats <- fread(input = "data/features/locations_feats.csv") # This contains train and test
count_feats <- fread(input = "data/features/count_feats.csv")
min_feats <- fread(input = "data/features/min_feats.csv")
max_feats <- fread(input = "data/features/max_feats.csv")
sum_feats <- fread(input = "data/features/sum_feats.csv")
median_feats <- fread(input = "data/features/median_feats.csv")
mean_feats <- fread(input = "data/features/mean_feats.csv")
sev_type_sort_feats <- fread(input = "data/features/sev_type_sort_feats.csv")
sd_feats <- fread(input = "data/features/sd_feats.csv")
load(file = "data/features/log_features_pca.Rdata")
log_features_pca <- lf.dt.pca
rm(lf.dt.pca)

full <- merge(locations_feats, count_feats, all = T, by = "id")
full <- merge(full, min_feats, all = T, by = "id")
full <- merge(full, max_feats, all = T, by = "id")
full <- merge(full, sum_feats, all = T, by = "id")
full <- merge(full, median_feats, all = T, by = "id")
full <- merge(full, mean_feats, all = T, by = "id")
full <- merge(full, sev_type_sort_feats, all = T, by = "id")
full <- merge(full, sd_feats, all = T, by = "id")

class(full)

train <- full[full$fault_severity != -1]
test <- full[full$fault_severity == -1]

table(train$fault_severity)
train.class <- train[["fault_severity"]]
train.id <- train[["id"]]
test.id <- test[["id"]]
train[, fault_severity := NULL]
test[, fault_severity := NULL]

rf.model.000 <- trainRFModel(train, as.factor(train.class), 100)

png(filename = "res/RFImportance.000.png")
varImpPlot(rf.model.000)
dev.off()

save(rf.model.000, file = "model/rf.model.000")

pred.rf.prob <- predict(rf.model.000, test, type = "prob")
pred.rf.resp <- predict(rf.model.000, test, type = "response")

#CrossTable(test.data$y, pred.rf.resp, prop.chisq = F, prop.c = T, prop.r = F)

submission <- fread(input = "data/sample_submission.csv")
submission <- submission[order(id)]
submission <- as.data.frame(submission)
submission[, 2:4] <- pred.rf.prob

write.csv(submission, file = "res/rf.submission.000.csv", quote = F, row.names = F)

#########################################

rf.model.001 <- tuneRF(
  train,
  as.factor(train.class),
  mtryStart = 1,
  ntreeTry = 100,
  improve = 0.05,
  trace = T,
  plot = T,
  doBest = T)

png(filename = "res/RFImportance.001.png")
varImpPlot(rf.model.001)
dev.off()

save(rf.model.001, file = "model/rf.model.001")

pred.rf.prob <- predict(rf.model.001, test, type = "prob")
pred.rf.resp <- predict(rf.model.001, test, type = "response")

#CrossTable(test.data$y, pred.rf.resp, prop.chisq = F, prop.c = T, prop.r = F)

submission <- fread(input = "data/sample_submission.csv")
submission <- submission[order(id)]
submission <- as.data.frame(submission)
submission[, 2:4] <- pred.rf.prob

write.csv(submission, file = "res/rf.submission.001.csv", quote = F, row.names = F)

#########################################

best_5_pcs <- log_features_pca[, 1:6, with = F]

full <- merge(locations_feats, count_feats, all = T, by = "id")
full <- merge(full, min_feats, all = T, by = "id")
full <- merge(full, max_feats, all = T, by = "id")
full <- merge(full, sum_feats, all = T, by = "id")
full <- merge(full, median_feats, all = T, by = "id")
full <- merge(full, mean_feats, all = T, by = "id")
full <- merge(full, sev_type_sort_feats, all = T, by = "id")
full <- merge(full, sd_feats, all = T, by = "id")
full <- merge(full, best_5_pcs, all = T, by = "id")

train <- full[full$fault_severity != -1]
test <- full[full$fault_severity == -1]

train.class <- train[["fault_severity"]]
train.id <- train[["id"]]
test.id <- test[["id"]]
train[, fault_severity := NULL]
test[, fault_severity := NULL]

rf.model.002 <- tuneRF(
  train,
  as.factor(train.class),
  mtryStart = 1,
  ntreeTry = 100,
  improve = 0.05,
  trace = T,
  plot = T,
  doBest = T)

png(filename = "res/RFImportance.002.png")
varImpPlot(rf.model.002)
dev.off()

save(rf.model.002, file = "model/rf.model.002")

pred.rf.prob <- predict(rf.model.002, test, type = "prob")
pred.rf.resp <- predict(rf.model.002, test, type = "response")

#CrossTable(test.data$y, pred.rf.resp, prop.chisq = F, prop.c = T, prop.r = F)

submission <- fread(input = "data/sample_submission.csv")
submission <- submission[order(id)]
submission <- as.data.frame(submission)
submission[, 2:4] <- pred.rf.prob

write.csv(submission, file = "res/rf.submission.002.csv", quote = F, row.names = F)

#########################################

best_5_pcs <- log_features_pca[, 1:6, with = F]

full <- merge(locations_feats, count_feats, all = T, by = "id")
full <- merge(full, min_feats, all = T, by = "id")
full <- merge(full, max_feats, all = T, by = "id")
full <- merge(full, sum_feats, all = T, by = "id")
full <- merge(full, median_feats, all = T, by = "id")
full <- merge(full, mean_feats, all = T, by = "id")
full <- merge(full, sev_type_sort_feats, all = T, by = "id")
full <- merge(full, sd_feats, all = T, by = "id")
full <- merge(full, best_5_pcs, all = T, by = "id")

train <- full[full$fault_severity != -1]
test <- full[full$fault_severity == -1]

train.class <- train[["fault_severity"]]
train.id <- train[["id"]]
test.id <- test[["id"]]
train[, fault_severity := NULL]
test[, fault_severity := NULL]

rf.model.003 <- tuneRF(
  train,
  as.factor(train.class),
  mtryStart = 1,
  ntreeTry = 1000,
  improve = 0.005,
  trace = T,
  plot = T,
  doBest = T)

png(filename = "res/RFImportance.003.png")
varImpPlot(rf.model.003)
dev.off()

save(rf.model.003, file = "model/rf.model.003")

pred.rf.prob <- predict(rf.model.003, test, type = "prob")
pred.rf.resp <- predict(rf.model.003, test, type = "response")

#CrossTable(test.data$y, pred.rf.resp, prop.chisq = F, prop.c = T, prop.r = F)

submission <- fread(input = "data/sample_submission.csv")
submission <- submission[order(id)]
submission <- as.data.frame(submission)
submission[, 2:4] <- pred.rf.prob

write.csv(submission, file = "res/rf.submission.003.csv", quote = F, row.names = F)

#########################################

require(kernlab)

best_5_pcs <- log_features_pca[, 1:6, with = F]

full <- merge(locations_feats, count_feats, all = T, by = "id")
full <- merge(full, min_feats, all = T, by = "id")
full <- merge(full, max_feats, all = T, by = "id")
full <- merge(full, sum_feats, all = T, by = "id")
full <- merge(full, median_feats, all = T, by = "id")
full <- merge(full, mean_feats, all = T, by = "id")
full <- merge(full, sev_type_sort_feats, all = T, by = "id")
full <- merge(full, sd_feats, all = T, by = "id")
full <- merge(full, best_5_pcs, all = T, by = "id")

train <- full[full$fault_severity != -1]
test <- full[full$fault_severity == -1]

train[, id := NULL]
test[, id := NULL]

svm.model.000 <- ksvm(
  as.factor(fault_severity) ~ .,
  data = train,
  cross = 5,
  kernel = "rbfdot",
  prob.model = T)

save(svm.model.000, file = "model/svm.model.000")

pred.svm.prob <- predict(svm.model.000, test, type = "prob")
pred.svm.resp <- predict(svm.model.000, test, type = "response")

submission <- fread(input = "data/sample_submission.csv")
submission <- submission[order(id)]
submission <- as.data.frame(submission)
submission[, 2:4] <- pred.svm.prob

write.csv(submission, file = "res/svm.submission.000.csv", quote = F, row.names = F)

#########################################

require(xgboost)

best_5_pcs <- log_features_pca[, 1:6, with = F]

full <- merge(locations_feats, count_feats, all = T, by = "id")
full <- merge(full, min_feats, all = T, by = "id")
full <- merge(full, max_feats, all = T, by = "id")
full <- merge(full, sum_feats, all = T, by = "id")
full <- merge(full, median_feats, all = T, by = "id")
full <- merge(full, mean_feats, all = T, by = "id")
full <- merge(full, sev_type_sort_feats, all = T, by = "id")
full <- merge(full, sd_feats, all = T, by = "id")
full <- merge(full, best_15_pcs, all = T, by = "id")

train <- full[full$fault_severity != -1]
test <- full[full$fault_severity == -1]

train.class <- train[["fault_severity"]]
train.id <- train[["id"]]
test.id <- test[["id"]]
train[, fault_severity := NULL]
test[, fault_severity := NULL]

params <- list(
  eval_metric = 'mlogloss', ## Evaluacion utilizada en la competicion
  num_class = max(train.class) + 1, ## Numero de classes a predecir
  eta = 0.05, ## Tasa de aprendizaje, valores pequeños previenen el overfitting
  subsample = 0.7, ## Proporcion de muestreo de instancias de training
  colsample_bytree = 0.85, ## Proporcion de muestreo de columnas al construir los arboles
  objective = 'multi:softprob', ## Tarea de aprendizaje. Clasificacion multiclase con resultado de probabilidades
  gamma = 0.1,
  lambda=0.9)

best.xgbcv <- xgb.cv(
  params = params,
  data = data.matrix(train),
  label = train.class, 
  nfold = 10,
  nrounds = 1000,
  print.every.n = 10,
  early.stop.round=100)

NROUNDS <- which.min(best.xgbcv$train.mlogloss.mean)

xgb.model.000 <- xgboost(
  params = params,
  data = data.matrix(train),
  label = train.class,
  nrounds=NROUNDS,
  print.every.n = 100)

xgb.save(xgb.model.000, fname = "model/xgb.model.000")
# xgb.model.000 <- xgb.load(modelfile = "model/xgb.model.000")

pred.xgb.prob <- predict(xgb.model.000, data.matrix(test))

pred.xgb.prob <- matrix(pred.xgb.prob, ncol = 3, byrow = T)

submission <- fread(input = "data/sample_submission.csv")
submission <- submission[order(id)]
submission <- as.data.frame(submission)
submission[, 2:4] <- pred.xgb.prob

write.csv(submission, file = "res/xgb.submission.000.csv", quote = F, row.names = F)

#########################################

xgb.submission.000 <- fread("res/xgb.submission.000.csv", data.table = F)
rf.submission.001 <- fread("res/rf.submission.001.csv", data.table = F)

submission <- xgb.submission.000

submission[, 2:4] <- 0.5 * xgb.submission.000[, 2:4] + 0.5 * rf.submission.001[, 2:4]
write.csv(submission, file = "res/ens.submission.000.csv", quote = F, row.names = F)

submission[, 2:4] <- 0.4 * xgb.submission.000[, 2:4] + 0.6 * rf.submission.001[, 2:4]
write.csv(submission, file = "res/ens.submission.001.csv", quote = F, row.names = F)

submission[, 2:4] <- 0.3 * xgb.submission.000[, 2:4] + 0.7 * rf.submission.001[, 2:4]
write.csv(submission, file = "res/ens.submission.002.csv", quote = F, row.names = F)

submission[, 2:4] <- 0.6 * xgb.submission.000[, 2:4] + 0.4 * rf.submission.003[, 2:4]
write.csv(submission, file = "res/ens.submission.003.csv", quote = F, row.names = F)

submission[, 2:4] <- 0.7 * xgb.submission.000[, 2:4] + 0.3 * rf.submission.003[, 2:4]
write.csv(submission, file = "res/ens.submission.004.csv", quote = F, row.names = F)

submission[, 2:4] <- 0.8 * xgb.submission.000[, 2:4] + 0.2 * rf.submission.003[, 2:4]
write.csv(submission, file = "res/ens.submission.005.csv", quote = F, row.names = F)
