# 14. Técnicas de Aprendizaje No Supervisado

## 1. Distancias heterogeneas

Crear una función que calcule la distancia entre dos puntos dados
por sus coordenadas (latitud y longitud) y calcular las distancias
(en kilómetros) entre:

* Madrid (40.4000, -3.7167) y Buenos Aires (-34.6033, -58.3817)
* Sidney (-33.8650, 151.2094) y Bogotá (4.5981, -74.0758)

## 2. Análisis de aceites de oliva (I)

Analizar el fichero `../dat/olive.txt` con dos algoritmos no supervisados.
Usar solo las variables numéricas relativas a concentración de sustancias
químicas. Dependiendo de los algoritmos elegidos, determinar y razonar
(si procede) el número adecuado de clústers o la distancia empleada. Si procede
hacer algún tipo de normalización en los datos y cuál.
Usar, cuando menos, o _k-medias_ o _k-medioides_.

## 3. Análisis de aceites de oliva (II)

Analizar los clústers construidos sea con _k-medias_ o con _k-medioides_:

* ¿Qué variables son las que más distinguen los clústers? ¿Alguna no lo hace?
* ¿Puedes hacer un pequeño estudio de la calidad del clúster (gráficos de
bandera o similar)?
* Estudiar uno de los clústers y mostrar la distribución de las variables en él.
Comparar con la distribución de la muestra entera.
* ¿Se correlacionan estos clústers con las variables geográficas?

## 4. Análisis de aceites de oliva (III)

Repetir el análisis sobre los mismos datos pero transformados mediante PCA:

1. Reducir la dimensión del conjunto de datos usando PCA (¿cuántas son
suficientes?)
2. Crear clústers usando k-medias o k-medioides.

Analizar brevemente los resultados obtenidos.

## 5. K-medias y map reduce

Implementar dos funciones, `map` y `reduce` de manera que

```{r}
n <- 5
dat <- olive
tmp <- dat[sample(1:nrow(dat), n),]
for (i in 1:10) {
  tmp <- map(tmp, dat)
  tmp <- reduce(tmp, dat)
}
centroides <- tmp
```