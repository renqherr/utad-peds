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

test_train <- rbind(train, test)

et <- fread(input = "data/event_type.csv")
st <- fread(input = "data/severity_type.csv")
rt <- fread(input = "data/resource_type.csv")
lf <- fread(input = "data/log_feature.csv")

count_et <- et[, .(count_event_type = length(unique(event_type))), by = id]
count_st <- st[, .(count_severity_type = length(unique(severity_type))), by = id]
count_rt <- rt[, .(count_resource_type = length(unique(resource_type))), by = id]
count_lf <- lf[, .(count_log_feat = length(unique(log_feature))), by = id]
count_vol <- lf[, .(count_log_vol = length(unique(volume))), by = id]

tmp <- merge(count_et, count_st, all = T, by = "id")
tmp <- merge(tmp, count_rt, all = T, by = "id")
tmp <- merge(tmp, count_lf, all = T, by = "id")
tmp <- merge(tmp, count_vol, all = T, by = "id")

colnames(tmp) <- c("id", "count_et", "count_st", "count_rt", "count_lf", "count_vol")

write.csv(tmp, file = "data/features/count_feats.csv", quote = F, row.names = F)
