##########################################################################
## PEDS 2015 (Segunda edicion)
## Trabajo fin de Experto: Kaggle - Telstra Network Disruptions
## Rafael Enriquez-Herrador
##    rafael.enriquez@live.u-tad.com
##    rafenher07@gmail.com
##########################################################################

# install.packages(devtools)
library(devtools)
# Visualizacion PCA/clustering
# install_github("sinhrks/ggfortify")
# install_github("ggbiplot", "vqv")
library(ggbiplot)
# install.packages(corrplot)
library(corrplot)
library(ggplot2)
library(plyr)
require(reshape2)
##library(data.table)
library(dplyr)
require(stringr)
require(data.table)

stringToValue <- function(x) {
  for (i in 1:length(x)) {
    if (is.na(x[i]))
      x[i] <- 0
  }
  
  return(x)
}

lf.df <- read.table(
  file = "data/log_feature.csv",
  header = T,
  sep = ",",
  stringsAsFactors = F)


lf.df <- dcast(
  data = lf.df,
  formula = id ~ log_feature,
  value.var = "volume")

lf.df[, 2:ncol(lf.df)] <- as.numeric(
  apply(
    lf.df[, 2:ncol(lf.df)],
    2,
    stringToValue))

lf.dt <- as.data.table(lf.df)

lf.df.pca <- prcomp(lf.df[, 2:ncol(lf.df)])
lf.df.pca.var <- lf.df.pca$sdev^2
lf.df.pca.pve <- lf.df.pca.var/sum(lf.df.pca.var)

png(filename = "res/accPCA.png")
qplot(seq_along(lf.df.pca.pve),
      cumsum(lf.df.pca.pve),
      geom = c("point", "path"),
      xlab = "Componentes principales",
      ylab = "Proporción acumulada de Varianzas Explicadas")
dev.off()

tmp <- as.matrix(lf.df[, 2:ncol(lf.df)]) %*% lf.df.pca$rotation

tmp <- cbind(lf.df$id, tmp, 1)

colnames(tmp)[1] <- "id"

lf.dt.pca <- as.data.table(tmp)

write.csv(lf.dt.pca, file = "data/features/log_features_pca.csv", quote = F, row.names = F)
save(lf.dt.pca, file = "data/features/log_features_pca.Rdata")

################################################
# Find out what are the most important features
################################################

class(lf.df.pca)

head(lf.df.pca$rotation)[, 1:5]

tmp <- lf.df.pca$rotation

rownames(tmp) <- as.numeric(
  unlist(lapply(strsplit(rownames(tmp), " "), function(x) x[2])))

tmp <- cbind(as.numeric(rownames(tmp)), tmp)
colnames(tmp)[1] <- "id"

tmp.dt <- as.data.table(tmp)

tmp.dt.sum <- abs(tmp.dt)
tmp.dt.sum$sum <- rowSums(tmp.dt.sum[, 2:6, with = F])
write.csv(tmp.dt.sum, file = "data/features/log_features_pca_imp.csv", quote = F, row.names = F)
tmp.dt.sum[order(-sum)][1:15, c(1,388), with = F]
