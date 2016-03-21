#############################################################################
## U-TAD: Programa de Experto en Data Science
## Alumno: Rafael Enríquez Herrador - rafael.enriquez@live.u-tad.com
## Módulo 10: Técnicas de reducción de dimensiones
## Curso: 2014/2015 (segunda edición)
#############################################################################

#############################################################################
# Para la realización de esta práctica hemos seleccionado un dataset que
# contiene mediciones de electrones libres en la ionosfera. Cada medición
# consiste en 34 variables continuas en el rango [-1, 1] y una adicional de
# clasificación binaria:
#   Good ("g"): Cuando la medición muestra algún tipo de evidencia de
#     estructura en la ionosfera.
#   Bad ("b"): Cuando no hay evidencia de estructura en la ionosfera.
# Se puede descargar y consultar más información sobre este dataset en:
#   https://archive.ics.uci.edu/ml/datasets/Ionosphere
#############################################################################

#######################
## EJERCICIO 1
#######################

# El objetivo de este ejercicio es realizar un análisis de reducción de
# dimensiones mediante el análisis de componentes principales, para comprobar
# si se puede predecir si una medición es buena o mala en función de una
# representación de los datos con una dimensionalidad menor.

# Cargamos los datos
ionosphere <- read.table(file = "data/ionosphere.data", sep = ",")
str(ionosphere)
summary(ionosphere)

# Análisis PCA
# Realizamos el análisis sobre las 34 primeras variables (numéricas) y
# omitimos la variable V35 que se corresponde con la clasificación. No
# hace falta escalar ni centrar los datos ya que todos los valores se
# almacenaron escaladas entre [-1, 1] y centradas en 0.

ion.log <- ionosphere[, 1:34]
ion.class <- ionosphere[, 35]

ion.pca <- prcomp(ion.log)

# Calculamos la media y la varianza para cada una de las variables
ion.mean <- apply(ion.log, 2, mean)
ion.var <- apply(ion.log, 2, var)

# Observamos las variables que más varianza presentan
head(sort(ion.var, decreasing = T), 10)

# Cargamos las librerias necesarias para la visualización
# install.packages(devtools)
library(devtools)
# Visualizacion PCA/clustering
# install_github("sinhrks/ggfortify")
# install_github("ggbiplot", "vqv")
library(ggbiplot)
# install.packages(corrplot)
library(corrplot)
library(reshape2)
library(ggplot2)

# Calculamos el número significativo de componentes principales. Para
# ello utilizaremos el criterio del codo.
ion.pca.var <- ion.pca$sdev^2
ion.pca.pve <- ion.pca.var/sum(ion.pca.var)

head(ion.pca.pve)

qplot(seq_along(ion.pca.pve),
      ion.pca.pve,
      geom = c("point", "path"),
      xlab = "Componentes principales",
      ylab = "Proporción de Varianzas Explicadas")

qplot(seq_along(ion.pca.pve),
      cumsum(ion.pca.pve),
      geom = c("point", "path"),
      xlab = "Componentes principales",
      ylab = "Proporción acumulada de Varianzas Explicadas")

# Observamos que con las primeras 12 componentes principales
# explicamos más del 80% de la varianza y que con las
# primeras 20 explicamos más del 90% de la varianza de los
# datos.

# Dibujamos la matriz de rotación frente a las dos primeras
# componentes principales.
g <- ggbiplot(ion.pca, obs.scale = 1, var.scale = 1, 
              groups = ion.class, ellipse = TRUE, 
              circle = TRUE)
g <- g + scale_color_discrete(name = '')
g <- g + theme(legend.direction = 'vertical', 
               legend.position = 'right')
print(g)

# Observamos que los resultados mostrados no son significativos
# visualmente, ya que no se aprecia una agrupación clara de los
# datos, lo que concuerda con nuestra anterior afirmación de que
# necesitamos, al menos, de las 12 primeras componentes
# principales para explicar la varianza de los datos.

# Para finalizar mostraremos el peso que tiene cada una de las
# variables en cada componente principal. Por motivos de espacio,
# solo mostraremos las 12 primeras componentes principales que,
# sabemos representan más del 80% de la varianza.

ion.pca.melted <- melt(ion.pca$rotation[, 1:12])

barplot <- ggplot(data = ion.pca.melted) +
  geom_bar(aes(x = Var1, y = value, fill = Var1), stat = "identity") +
  facet_wrap(~Var2) +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))
print(barplot)

# Tal y como se apreciaba en la visualización de la matriz de
# rotación frenta a PC1 y PC2, para PC1, las variables V15 y
# y V17 tienen el mayor peso en su definición y para PC2, esto ocurre
# con V20.

#######################
## EJERCICIO 2
#######################

# El objetivo de este ejercicio es aplicar el metodo no-lineal de reducción
# de dimensiones Isomap, para el mismo proposito que el ejercicio anterior.

# Cargamos las librerías necesarias.
### Para reducción de dimensiones mediante metodos no-lineales
# source("http://bioconductor.org/biocLite.R")
# biocLite("RDRToolbox")
### Para crear plots 3D hay que instalar el paquete rlg
# install.packages("rgl")

library(RDRToolbox)
library(rgl)

# Aplicamos Isomap para 2 y 3 dimensiones, utilizando 10 vecinos cercanos para
# calcular la variante.
ion.iso_dim2 <- Isomap(data = as.matrix(ion.log), dims = 2, k = 10)
ion.iso_dim3 <- Isomap(data = as.matrix(ion.log), dims = 3, k = 10)

ion.iso_dim2$class <- ion.class
ion.iso_dim3$class <- ion.class

plotDR(data=ion.iso_dim2$dim2,
       labels = ion.iso_dim2$class,
       legend = T,
       col = c("blue", "red"))

plotDR(data=ion.iso_dim3$dim3,
       labels = ion.iso_dim3$class,
       legend = T,
       col = c("blue", "red"))


# Aplicamos Isomap reduciendo a las 10 primeras dimensiones, utilizando los 10
# vecinos cercanos para calcular la variante y dibujamos los residuos buscando
# el criterio del codo.
ion.iso <- Isomap(data = as.matrix(ion.log), dim = 1:10, k = 10, plotResiduals = T)

# Al dibujar la varianza residual, aplicando el criterio del codo, observamos
# que de 2 a 4 dimensiones obtenemos un valor por encima del 80% de la
# varianza. Este método realiza una reducción más eficiente que en PCA, donde
# necesitabamos al menos de 12 componentes principales para explicar un
# porcentaje de varianza similar. Por lo tanto, podemos intuir que nuestros
# datos presentan una estructura no lineal en 34 dimensiones.

# Dibujamos la matriz de rotación frente a las 2 primeras componentes
# que representa cada componente del indice en las nuevas coordenadas.

ion_iso <- as.data.frame(ion.iso$dim5)
clus <- kmeans(as.data.frame(ion.iso$dim5), 2, nstart = 1)
ion_iso$cluster <- clus$cluster
ion_iso$class <- ion.class

p <- ggplot(ion_iso, aes(x=V1, y=V2)) + 
  geom_point(shape = 1, colour = "black") +
  stat_ellipse(geom = "polygon", alpha = 1/2, aes(fill = factor(cluster)))  +
  annotate("text", ion_iso$V1, ion_iso$V2, label = ion_iso$class, size = 3) + 
  labs(title = "Relaciones entre varianzas residuales (V1 y V2)")

print(p)
