# https://archive.ics.uci.edu/ml/datasets/Bank+Marketing

# Objetivo: Construir un clasificador para predecir si el cliente
# va a contratar un depósito (variable “y” del conjunto de datos).

# Instancias
# Training 150.000
# Test     101.503

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

input.folder <- "data/"
data <- fread(
  paste0(input.folder, "bank-additional-full.csv"),
  sep = ";",
  header = T,
  stringsAsFactors = T)

summary(data)
str(data)

# Dividir el dataset en dos subconjuntos: 75% para training y 25% para test
sample.size <- floor(0.75 * nrow(data))

# Ajustamos la semilla para elegir siempre los mismos valores aleatoriamente
set.seed(1234)
train.indexes <- sample(seq_len(nrow(data)), size = sample.size)

train.data <- data[train.indexes,]
test.data <- data[-train.indexes,]

# Comprobamos las proporciones de clientes que contrataron el producto
# en nuestros datasets
table(train.data$y)
table(test.data$y)
prop.table(table(train.data$y))
prop.table(table(test.data$y))

# Generamos las features
train.class <- train.data[["y"]]

# Eliminamos las features que no son necesarias para training o aquellas que
# puedan producir resultados no reales. Como se comenta en los datos, la
# duracion de la llamada se conoce a posteriori, junto con el resultado a
# predecir, por lo que puede ser una feature muy influyente que no conocemos
# de entrada a la hora de predecir con nuestro modelo y que nos puede provocar
# resultados no esperados.
test.data[, duration := NULL]
train.data[, duration := NULL]
train.data[, y := NULL]

# Entrenamos un modelo
rf.model.000 <- trainRFModel(train.data, train.class, 100)

png("models/Importance.000.png")
varImpPlot(rf.model.000)
dev.off()

png("models/Error.000.png")
plot(rf.model.000)
dev.off()

save(rf.model.000, file = "models/rf.model.000")

# Predecimos
pred.rf <- predict(rf.model.000, test.data, type = "prob")
pred.rf2 <- predict(rf.model.000, test.data, type = "response")
CrossTable(test.data$y, pred.rf2, prop.chisq = F, prop.c = T, prop.r = F)
#submission <- data.frame(Id = 1:nrow(pred.rf), Probability = pred.rf[,1])
#write.table(
#  submission,
#  file = "submissions/000_attempt.csv",
#  quote = F,
#  sep = ",",
#  row.names = F)

# Tuneamos el valor del numero de variables por nivel en el arbol para intentar
# ajustar mejor nuestro modelo.
rf.model.001 <- tuneRF(
  train.data,
  train.class,
  mtryStart = 1,
  ntreeTry = 100,
  improve = 0.05,
  trace = T,
  plot = T,
  doBest = T)

png("models/Importance.001.png")
varImpPlot(rf.model.001)
dev.off()

png("models/Error.001.png")
plot(rf.model.001)
dev.off()

pred.rf3 <- predict(rf.model.001, test.data, type = "response")
CrossTable(test.data$y, pred.rf3, prop.chisq = F, prop.c = T, prop.r = F)


########################################################################
########################################################################

# Objetivo: Probar un modelo de regresión para predecir la
# edad (variable age) en función de las otras variables

library(data.table)
library(e1071)
library(caret)
library(corrplot)
library(gmodels)
library(kernlab)
library(ROCR)

rocplot <- function(pred, truth, ...) {
  predob <- prediction(pred, truth)
  perf <- performance(predob, "tpr", "fpr")
  plot(perf, ...)
}

rm(list = ls())

input.folder <- "data/"
data <- fread(
  paste0(input.folder, "bank-additional-full.csv"),
  sep = ";",
  header = T,
  stringsAsFactors = T)

## Dummy features from categorical
data.dummies <- with(data,
     data.frame(
       age,
       model.matrix(~job-1, data),
       model.matrix(~marital-1, data),
       model.matrix(~education-1, data),
       model.matrix(~default-1, data),
       model.matrix(~housing-1, data),
       model.matrix(~loan-1, data),
       model.matrix(~contact-1, data),
       model.matrix(~month-1, data),
       model.matrix(~day_of_week-1, data),
       duration,
       campaign,
       previous,
       model.matrix(~poutcome-1, data),
       emp.var.rate,
       cons.price.idx,
       cons.conf.idx,
       euribor3m,
       nr.employed,
       model.matrix(~y-1, data)))

# Dividir el dataset en dos subconjuntos: 75% para training y 25% para test
sample.size <- floor(0.25 * nrow(data.dummies))
sample.train <- floor(0.75 * sample.size)

# Ajustamos la semilla para elegir siempre los mismos valores aleatoriamente
set.seed(647)
sample.indexes <- sample(seq_len(nrow(data.dummies)), size = sample.size)
data.dummies.resize <- data.dummies[sample.indexes,]
train.indexes <- sample(seq_len(nrow(data.dummies.resize)), size = sample.train)

train.data <- data.dummies.resize[train.indexes,]
test.data <- data.dummies.resize[-train.indexes,]

# Comprobamos las proporciones de clientes que contrataron el producto
# en nuestros datasets
table(train.data$age)
table(test.data$age)
prop.table(table(train.data$age))
prop.table(table(test.data$age))

## DATASET UNDERSTANDING
head(data.dummies.resize)
str(data.dummies.resize)
summary(data.dummies.resize)

filter.radial <- svm(
  age ~ .,
  data = train.data,
  kernel = "radial",
  type = "eps-regression",
  gamma = 50,
  cost = 1,
  decision.values = T)

filter.linear <- svm(
  age ~ .,
  data = train.data,
  kernel = "linear",
  type = "eps-regression",
  cost = 1,
  decision.values = T)

# filter.polynomial <- ksvm(
#   age ~ .,
#   data = train.data,
#   kernel = "polydot",
#   type = "eps-svr",
#   decision.values = T)
# 
# filter.hypTangent <- ksvm(
#   age ~ .,
#   data = train.data,
#   kernel = "tanhdot",
#   type = "eps-svr",
#   decision.values = T)
# 
# filter.laplace <- ksvm(
#   age ~ .,
#   data = train.data,
#   kernel = "laplacedot",
#   type = "eps-svr",
#   decision.values = T)

fitted.radial <- attributes(
  predict(filter.radial, test.data, decision.values = T))$decision.values

# fitted.linear <- attributes(
#   predict(filter.linear, test.data, decision.values = T))$decision.values

par(mfrow = c(1, 2))
## Radial Kernel
rocplot(fitted.radial, test.data$age, main = "Training data")
## Linear Kernel
# rocplot(fitted.linear, train.data[, "age"], main = "Training data")

