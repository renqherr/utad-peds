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

SD <- function(x) {
  x_mean <- mean(x)
  sqrt(sum(((x - x_mean)^2)/length(x)))
}

splitAndSD <- function(x) {
  SD(as.numeric(unlist(lapply(strsplit(x, " "), function(x) x[2]))))
}

test_train <- rbind(train, test)

et <- fread(input = "data/event_type.csv")
st <- fread(input = "data/severity_type.csv")
rt <- fread(input = "data/resource_type.csv")
lf <- fread(input = "data/log_feature.csv")

sd_et <- et[, .(sd_event_type = splitAndSD(event_type)), by = id]
sd_st <- st[, .(sd_severity_type = splitAndSD(severity_type)), by = id]
sd_rt <- rt[, .(sd_resource_type = splitAndSD(resource_type)), by = id]
sd_lf <- lf[, .(sd_log_feat = splitAndSD(log_feature)), by = id]
sd_vol <- lf[, .(sd_log_vol = SD(volume)), by = id]

tmp <- merge(sd_et, sd_st, all = T, by = "id")
tmp <- merge(tmp, sd_rt, all = T, by = "id")
tmp <- merge(tmp, sd_lf, all = T, by = "id")
tmp <- merge(tmp, sd_vol, all = T, by = "id")

colnames(tmp) <- c("id", "sd_et", "sd_st", "sd_rt", "sd_lf", "sd_vol")

write.csv(tmp, file = "data/features/sd_feats.csv", quote = F, row.names = F)
