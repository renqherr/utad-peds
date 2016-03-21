# https://archive.ics.uci.edu/ml/datasets/Bank+Marketing

# Objetivo: Construir un clasificador para predecir si el cliente
# va a contratar un depósito (variable “y” del conjunto de datos).

# Instancias
# Training 150.000
# Test     101.503

library(caret)
library(data.table)
library(corrplot)
set.seed(642)

input.folder <- "data/"
data <- fread(
  paste0(input.folder, "bank-additional-full.csv"),
  sep = ";",
  header = T,
  stringsAsFactors = T)

str(data)

sample.indexes <- createDataPartition(data$y, p = .25, list = F)
sample.data <- data[sample.indexes, ]
training.indexes <- createDataPartition(sample.data$y, p = .75, list = F)
training.data <- data[training.indexes, ]
test.data <- data[-training.indexes, ]

training.class <- training.data[["y"]]
training.data[, y := NULL]

ctrl1 <- trainControl(
  ## 5 fold CV
  method = "cv",
  number = 5,
  repeats = 10)

set.seed(992)

rf.model.001 <- train(x = training.data, y = training.class, method = "rf", trControl = ctrl1)

rf.model.001 <- train(y ~ ., data = training.data,
                      method = "gbm",
                      trControl = ctrl1,
                      verbose = F)

gbmGrid <- expand.grid(interaction.depth = c(1, 5, 9),
                        n.trees = (1:30)*50,
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
nrow(gbmGrid)

rf.model.002 <- train(y ~ ., data = training.data,
                      method = "gbm",
                      trControl = ctrl1,
                      verbose = F,
                      tuneGrid = gbmGrid)

