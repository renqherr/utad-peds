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

splitAndMin <- function(x) {
  min(as.numeric(unlist(lapply(strsplit(x, " "), function(x) x[2]))))
}

test_train <- rbind(train, test)

et <- fread(input = "data/event_type.csv")
st <- fread(input = "data/severity_type.csv")
rt <- fread(input = "data/resource_type.csv")
lf <- fread(input = "data/log_feature.csv")

min_et <- et[, .(min_event_type = splitAndMin(event_type)), by = id]
min_st <- st[, .(min_severity_type = splitAndMin(severity_type)), by = id]
min_rt <- rt[, .(min_resource_type = splitAndMin(resource_type)), by = id]
min_lf <- lf[, .(min_log_feat = splitAndMin(log_feature)), by = id]
min_vol <- lf[, .(min_log_vol = min(volume)), by = id]

tmp <- merge(min_et, min_st, all = T, by = "id")
tmp <- merge(tmp, min_rt, all = T, by = "id")
tmp <- merge(tmp, min_lf, all = T, by = "id")
tmp <- merge(tmp, min_vol, all = T, by = "id")

colnames(tmp) <- c("id", "min_et", "min_st", "min_rt", "min_lf", "min_vol")

write.csv(tmp, file = "data/features/min_feats.csv", quote = F, row.names = F)
