##########################################################################
## PEDS 2015 (Segunda edicion)
## Trabajo fin de Experto: Kaggle - Telstra Network Disruptions
## Rafael Enriquez-Herrador
##    rafael.enriquez@live.u-tad.com
##    rafenher07@gmail.com
##########################################################################

require(tm)
require(data.table)
require(ggplot2)
require(plyr)

train <- fread(input = "data/train.csv")
test <- fread(input = "data/test.csv")

splitLocation <- function(x) {
  as.numeric(unlist(lapply(strsplit(x, " "), function(x) x[2])))  
}

test$fault_severity <- -1

test_train <- rbind(train, test)

locations <- test_train[, .(location = splitLocation(location), fault_severity), by = id]
locations <- locations[, .(location, fault_severity, fs_factor = as.factor(fault_severity)), by = id]

png(filename = "res/location_vs_id.png")
ggplot(data = locations, aes(x = location, y = id)) +
  geom_point(aes(color = fs_factor, alpha = fs_factor, size = fs_factor)) +
  scale_color_manual(
    name = "fault_severity",
    values = c("-1"="black", "0"="green", "1"="blue", "2"="red")) +
  scale_alpha_manual(
    legend = NULL,
    values = c("-1"=0.8, "0"=0.6, "1"=0.6, "2"=0.6)) +
  scale_size_manual(
    name = "fault_severity",
    legend = NULL,
    values = c("-1"=0.5, "0"=2, "1"=2, "2"=2))
dev.off()

png(filename = "res/location_vs_sort.png")
ggplot(data = st, aes(x = location, y = sort)) +
  geom_point(aes(color = fs_factor, alpha = fs_factor, size = fs_factor)) +
  scale_color_manual(
    name = "fault_severity",
    values = c("-1"="black", "0"="green", "1"="blue", "2"="red")) +
  scale_alpha_manual(
    legend = NULL,
    values = c("-1"=0.8, "0"=0.6, "1"=0.6, "2"=0.6)) +
  scale_size_manual(
    name = "fault_severity",
    legend = NULL,
    values = c("-1"=0.5, "0"=2, "1"=2, "2"=2))
dev.off()

locations[, fs_factor := NULL]

write.csv(locations, file = "data/features/locations_feats.csv", quote = F, row.names = F)

st <- fread(input = "data/severity_type.csv")
st <- st[, .(severity_type = splitLocation(severity_type)), by = id]

st <- merge(st, locations, all = T, by = "id", sort = F)
head(st, 100)
tail(st, 100)

st[, sort := c(1:.N), by = location]
st[, revsort := c(.N:1), by = location]
st[, cumsort := (sort/(.N + 1)), by = location]

png(filename = "res/hist_sort.png")
ggplot(data = st, aes(x = sort)) + geom_histogram()
dev.off()

png(filename = "res/hist_revsort.png")
ggplot(data = st, aes(x = revsort)) + geom_histogram()
dev.off()

png(filename = "res/hist_cumsort.png")
ggplot(data = st, aes(x = cumsort)) + geom_histogram()
dev.off()

st$fs_factor <- as.factor(st$fault_severity)

png(filename = "res/location_vs_sort.png")
ggplot(data = st, aes(x = location, y = sort)) +
  geom_point(aes(color = fs_factor, alpha = fs_factor, size = fs_factor)) +
  scale_color_manual(
    name = "fault_severity",
    values = c("-1"="black", "0"="green", "1"="blue", "2"="red")) +
  scale_alpha_manual(
    legend = NULL,
    values = c("-1"=0.8, "0"=0.6, "1"=0.6, "2"=0.6)) +
  scale_size_manual(
    name = "fault_severity",
    legend = NULL,
    values = c("-1"=0.5, "0"=2, "1"=2, "2"=2))
dev.off()

png(filename = "res/location_vs_revsort.png")
ggplot(data = st, aes(x = location, y = revsort)) +
  geom_point(aes(color = fs_factor, alpha = fs_factor, size = fs_factor)) +
  scale_color_manual(
    name = "fault_severity",
    values = c("-1"="black", "0"="green", "1"="blue", "2"="red")) +
  scale_alpha_manual(
    legend = NULL,
    values = c("-1"=0.8, "0"=0.6, "1"=0.6, "2"=0.6)) +
  scale_size_manual(
    name = "fault_severity",
    legend = NULL,
    values = c("-1"=0.5, "0"=2, "1"=2, "2"=2))
dev.off()

png(filename = "res/location_vs_cumsort.png")
ggplot(data = st, aes(x = location, y = cumsort)) +
  geom_point(aes(color = fs_factor, alpha = fs_factor, size = fs_factor)) +
  scale_color_manual(
    name = "fault_severity",
    values = c("-1"="black", "0"="green", "1"="blue", "2"="red")) +
  scale_alpha_manual(
    legend = NULL,
    values = c("-1"=0.8, "0"=0.6, "1"=0.6, "2"=0.6)) +
  scale_size_manual(
    name = "fault_severity",
    legend = NULL,
    values = c("-1"=0.5, "0"=2, "1"=2, "2"=2))
dev.off()

st[, fs_factor := NULL]
st[, location := NULL]
st[, fault_severity := NULL]

write.csv(locations, file = "data/features/locations_feats.csv", quote = F, row.names = F)
write.csv(st, file = "data/features/sev_type_sort_feats.csv", quote = F, row.names = F)
