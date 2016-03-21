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

splitAndMax <- function(x) {
  max(as.numeric(unlist(lapply(strsplit(x, " "), function(x) x[2]))))
}

test_train <- rbind(train, test)

et <- fread(input = "data/event_type.csv")
st <- fread(input = "data/severity_type.csv")
rt <- fread(input = "data/resource_type.csv")
lf <- fread(input = "data/log_feature.csv")

max_et <- et[, .(max_event_type = splitAndMax(event_type)), by = id]
max_st <- st[, .(max_severity_type = splitAndMax(severity_type)), by = id]
max_rt <- rt[, .(max_resource_type = splitAndMax(resource_type)), by = id]
max_lf <- lf[, .(max_log_feat = splitAndMax(log_feature)), by = id]
max_vol <- lf[, .(max_log_vol = max(volume)), by = id]

tmp <- merge(max_et, max_st, all = T, by = "id")
tmp <- merge(tmp, max_rt, all = T, by = "id")
tmp <- merge(tmp, max_lf, all = T, by = "id")
tmp <- merge(tmp, max_vol, all = T, by = "id")

colnames(tmp) <- c("id", "max_et", "max_st", "max_rt", "max_lf", "max_vol")

write.csv(tmp, file = "data/features/max_feats.csv", quote = F, row.names = F)
