#############################################################################
## U-TAD: Programa de Experto en Data Science
## Alumno: Rafael Enríquez Herrador
## Curso: 2014/2015 (segunda edición)
#############################################################################

#################################
## EJERCICIO 1
#################################

## Para ejecutar la práctica navege hasta el directorio donde se encuentra
## el fichero wine.csv

# 2.Leer el fichero wine.csv y almacenarlo en la variable df
df <- read.csv('wine.csv');

# 3.Clase del objeto df: data.frame
class(df);

# 4.Clase de cada columna de df y una muestra de ejemplo
str(df);

# 5. Mostrar los 3 primeros registros del dataset
head(df, 3);

# 5. Mostrar los 8 ultimos registros del dataset
tail(df, 8);

# 6. Mostrar la dimension del dataset: 178 filas y 14 columnas
dim(df);

# 6. Mostrar los nombres de las columnas del dataset
names(df);

# 7. Variables categoricas (en R están definidas como de clase "Factor"): df$class
str(df);

# 8. Calcular la media de todos los 'malic_acids': 2.336348
mean(df$malic_acid);

# 9. Calcular la media de todas las columnas en las que sea posible.
# Descartamos aquellas cuyo contenido no sea numerico (df$class).
colMeans(data.matrix(df[sapply(df, is.numeric)]));

# 10. Calcular la suma de todas las columnas.
# Descartamos aquellas cuyo contenido no sea numerico (df$class).
colSums(data.matrix(df[sapply(df, is.numeric)]));

# 11. Seleccione y almacene en un nuevo data.frame llamado df_class_1 todos
# los registros de tipo "class_1". Muestre la dimension del nuevo data.frame.
df_class_1 <- subset(df, df$class == "class_1");
dim(df_class_1);

# 12. Seleccione las 10 primeras filas y las 5 primeras columnas de df.
df[c(1:10), c(1:5)];

# 13. Seleccione las 10 ultimas filas y las 5 ultimas columnas de df.
df[c((dim(df)[1]-10):dim(df)[1]), c((dim(df)[2]-5):dim(df)[2])];

# 14. Obtener los cuartiles de la variable alcohol.
quantile(df$alcohol, probs = seq(0, 1, 0.25));

# 15. Obtener los deciles de la variable alcohol.
quantile(df$alcohol, probs = seq(0, 1, 0.1));

# 16. Obtener los estadisticos basicos de todas las variables de df con un
# solo comando.
# Estadisticos basicos: minimo, maximo, cuartiles 1º y 3º, media y mediana.
summary(df);

# 17. Obtener los valores unicos para la variable proline (df$proline).
unique(df$proline);

# 18. Obtener los valores de df$proline mayores que 1000.
length(df$proline[df$proline > 1000]);

# 19. Generar 10 bins o breaks de una variable de df.
cut(df$magnesium, 10);

# 20. Convertir los elementos de un vector de caracteres con letras
# mayusculas y minusculas a minusculas.
tolower(c('a', 'B', 'c', 'D', 'e', 'F', 'g', 'H'));

# 21. Mostrar los 6 primeros elementos de df$proline.
df$proline[1:6];

# 22. Mostrar de forma ordenada de menor a mayor los 6 primeros elementos de
# df$proline.
sort(df$proline[1:6]);

# 23. Mostrar de forma ordenada de menor a mayor los 6 ultimos elementos de
# df$proline.
sort(df$proline[(nrow(df) - 6) : nrow(df)]);

# 24. Mostrar de forma ordenada de mayor a menor los 10 primeros elementos de
# df$proline.
sort(df$proline[1:10], decreasing = TRUE);

# 25. Mostrar la posicion en el vector de los 6 valores mas pequeños de la
# df$proline.
head(sort(df$proline, index.return = TRUE)$ix, n = 6);

# 26. Indexar el valor mas pequeño del punto anterior y comprobar que es el mas
# pequeño.
df$proline[head(sort(df$proline, index.return = TRUE))$ix[1]] == min(df$proline);

# 27. Reordenar df por medio de df$proline. Confirmar visualizando los 6
# primeros elementos.
head(df[order(df$proline), ], n = 6)$proline;

# 28. Genere una matriz A a partir del siguiente codigo R:
    set.seed(1234);
    A <- matrix(runif(25, 1, 250), nrow = 5, ncol = 5, byrow = TRUE);
# Obtener los valores de la matriz mayores de 97.
A[A > 97];

# 29. Obtener los indices de los valores de A que sean mayores de 97.
which(A > 97, arr.ind = TRUE);

# 30. Obtener los indices de los valores de A mayores de 90 y menores de 98.
which(A > 90 & A < 98, arr.ind = TRUE);

#################################
## EJERCICIO 2
#################################

# 1. Escribir un programa en R dentro de una funcion que busque el primer
# elemento de un vector que sea cero utilizando un bucle for y pruebelo
# con vectores de distinto tamaño.
busca.cero.for <- function(v) {
  for (i in v) {
    if (i == 0) {
      return(i);
    }
  }  
}

busca.cero.for(c(1000:0));
busca.cero.for(c(10000:0));
busca.cero.for(c(100000:0));
busca.cero.for(c(1000000:0));
busca.cero.for(c(10000000:0));
busca.cero.for(c(100000000:0));

# 2. Escribir un programa en R dentro de una funcion que busque el primer
# elemento de un vector que sea cero utilizando un bucle while y pruebelo
# con vectores de distinto tamaño.
busca.cero.while <- function(v) {
  i = 0;
  while (i < length(v)) {
    i <- i + 1;
    if (v[i] == 0) {
      return(v[i]);
    }
  }
}

busca.cero.while(c(1000:0));
busca.cero.while(c(10000:0));
busca.cero.while(c(100000:0));
busca.cero.while(c(1000000:0));
busca.cero.while(c(10000000:0));
busca.cero.while(c(100000000:0));

# 3. Comprobar con una funcion de R la duracion de las dos implementaciones
# y como le afectan el tamaño de los vectores.
# Respuesta: Se comprueba que la funcion con el bucle for es hasta tres
# veces mas rapida que la funcion del bucle while. Ademas, en ambas, al
# aumentar la en 1 la longitud del vector, el tiempo se multiplica x10.

system.time(busca.cero.for(c(100000:0)));
system.time(busca.cero.while(c(100000:0)));

system.time(busca.cero.for(c(1000000:0)));
system.time(busca.cero.while(c(1000000:0)));

system.time(busca.cero.for(c(10000000:0)));
system.time(busca.cero.while(c(10000000:0)));

#################################
## EJERCICIO 3
#################################