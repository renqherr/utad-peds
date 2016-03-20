# 2. Introducción a R

## 1. Ejercicios Cortos

1. Decargue el fichero `wine.csv` de
[https://db.tt/POZYxrVK](https://db.tt/POZYxrVK)
2. Lea este fichero en R y asignelo a una variable llamada `df`.
3. ¿De que clase es instancia este objeto?
4. ¿Como se puede ver cuales son las clases de cada columna y una muestra de
ejemplo?
5. ¿Como se pueden ver los 3 primeros registros del dataset?,
¿y los 8 últimos?
6. ¿Como se puede saber la dimensión del dataset?, ¿y los nombres de las
columnas?
7. ¿Existe alguna variable categórica?, ¿cual?
8. Calcule la media de todos los _malic acids_.
9. Calcule la media de las columnas (en aquellas que sea posible, descartando
las otras).
10. Calcule la suma de todas las columnas.
11. Al hecho de seleccionar un conjunto de filas o columnas se le conoce como
_subsetting_. Seleccione y almacene en un nuevo `data.frame` llamado
`df_class_1` todos los registros de tipo __class_1__. ¿Que dimensión tiene
este nuevo dataset?
12. Seleccione las 10 primeras filas y las 5 primeras columnas.
13. Haga lo mismo que el anterior punto pero con índices negativos.
14. Obtenga los cuartiles de la variable __alcohol__.
15. Obtenga los deciles de la variable __alcohol__.
16. Obtenga los estadísticos básicos de todas la variables con un solo
comando.
17. ¿Cuantos valores únicos existen para las medidas de __proline__?
18. Sobre el total de registros de __proline__, ¿cuantos tienen un valor mayor
de 1000?
19. Genere 10 _bins_ o _breaks_ de una variable.
20. A partir de un vector de caracteres nuevo con algunas letras en
mayúsculas, cambielo a minúsculas.
21. Muestre los 6 primeros elementos de la variable __proline__.
22. Muestre de forma ordenada de menor a mayor los 6 primeros elemenos de la
variable __proline__.
23. Muestre de forma ordenada de menor a mayor los 6 últimos elementos de la
variable __proline__.
24. Muestre def forma ordenada de mayor a menor los 10 primeros elementos de
la variable __proline__.
25. Muestre la posición del vector de los 6 valores más pequeños de la
variable __proline__.
26. Indexe el valor más pequeño del anterior punto y confirme que es el más
pequeño.
27. Reordene el `data.frame` por medio de la variable __proline__. Confirme el
efecto visualizando los 6 primeros registros.
28. A partir del siguiente código _R_:
```{r}
set.seed(1234)
A <- matrix(runif(25, 1, 250), nrow = 5, ncol = 5, byrow = T)
```
Obtenga los valores de la matrix que satisfagan la condición de ser mayor
que 97.
29. Obtenga los índices de los valores anteriores.
30. Obtenga los índces de los valores mayores que 90 y menores que 98. 
