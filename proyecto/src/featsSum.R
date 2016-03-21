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

splitAndSum <- function(x) {
  sum(as.numeric(unlist(lapply(strsplit(x, " "), function(x) x[2]))))
}

test_train <- rbind(train, test)

et <- fread(input = "data/event_type.csv")
st <- fread(input = "data/severity_type.csv")
rt <- fread(input = "data/resource_type.csv")
lf <- fread(input = "data/log_feature.csv")

sum_et <- et[, .(sum_event_type = splitAndSum(event_type)), by = id]
sum_st <- st[, .(sum_severity_type = splitAndSum(severity_type)), by = id]
sum_rt <- rt[, .(sum_resource_type = splitAndSum(resource_type)), by = id]
sum_lf <- lf[, .(sum_log_feat = splitAndSum(log_feature)), by = id]
sum_vol <- lf[, .(sum_log_vol = sum(volume)), by = id]

tmp <- merge(sum_et, sum_st, all = T, by = "id")
tmp <- merge(tmp, sum_rt, all = T, by = "id")
tmp <- merge(tmp, sum_lf, all = T, by = "id")
tmp <- merge(tmp, sum_vol, all = T, by = "id")

colnames(tmp) <- c("id", "sum_et", "sum_st", "sum_rt", "sum_lf", "sum_vol")

write.csv(tmp, file = "data/features/sum_feats.csv", quote = F, row.names = F)
