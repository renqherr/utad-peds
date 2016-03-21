#############################################################################
## Rafael Enriquez-Herrador
## U-TAD - PEDS 2ED - 2015
## 8 - Visualizacion de Datos
## Practica
#############################################################################

#install.packages("babynames")
require(babynames)
library(data.table)
library(stringr)
library(ggplot2)

dt.bnames <- as.data.table(babynames)
dt.sXXI <- dt.bnames[year >= 2000]
dt.sXXI[, name_end := str_sub(name, -1)]
dt.sXXI[, n_end_sXXI := sum(n), by = name_end]

tail(dt.sXXI[order(n_end_sXXI)])

## Ahora sabemos que la terminacion mas repetida es "n"

dt.plot <- dt.sXXI[str_sub(dt.sXXI$name_end, -1) == "n"]
dt.plot <- dt.plot[, n_end_year := sum(n), by = year]
dt.plot <- dt.plot[ ! duplicated(year)]

head(dt.plot)

ggplot(dt.plot, aes(year, n_end_year)) + geom_line() + theme_bw()