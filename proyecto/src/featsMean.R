##########################################################################
## PEDS 2015 (Segunda edicion)
## Trabajo fin de Experto: Kaggle - Telstra Network Disruptions
## Rafael Enriquez-Herrador
##    rafael.enriquez@live.u-tad.com
##    rafenher07@gmail.com
##########################################################################

require(tm)
require(data.table)

train <- fread(input = "data/train.csv", data.table = F)
test <- fread(input = "data/test.csv", data.table = F)

test$fault_severity <- -1

splitAndMean <- function(x) {
  mean(as.numeric(unlist(lapply(strsplit(x, " "), function(x) x[2]))))
}

test_train <- rbind(train, test)

et <- fread(input = "data/event_type.csv")
st <- fread(input = "data/severity_type.csv")
rt <- fread(input = "data/resource_type.csv")
lf <- fread(input = "data/log_feature.csv")

mean_et <- et[, .(mean_event_type = splitAndMean(event_type)), by = id]
mean_st <- st[, .(mean_severity_type = splitAndMean(severity_type)), by = id]
mean_rt <- rt[, .(mean_resource_type = splitAndMean(resource_type)), by = id]
mean_lf <- lf[, .(mean_log_feat = splitAndMean(log_feature)), by = id]
mean_vol <- lf[, .(mean_log_vol = mean(volume)), by = id]

tmp <- merge(mean_et, mean_st, all = T, by = "id")
tmp <- merge(tmp, mean_rt, all = T, by = "id")
tmp <- merge(tmp, mean_lf, all = T, by = "id")
tmp <- merge(tmp, mean_vol, all = T, by = "id")

colnames(tmp) <- c("id", "mean_et", "mean_st", "mean_rt", "mean_lf", "mean_vol")

write.csv(tmp, file = "data/features/mean_feats.csv", quote = F, row.names = F)
