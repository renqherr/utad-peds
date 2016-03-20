# -*- coding: utf-8 -*-
"""
Created on Wed Apr 29 19:29:48 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

1. Explique brevemente cual es el propósito de la función 'zip' de Python,
restringiéndose al caso en que se pasan como argumento dos listas. Para ello
será útil utilizar help('zip') y hacer algunas llamadas de prueba a la función.
"""

help('zip')

"""
La funcion 'zip' devuelve una lista de tuplas en las que se combinan cada uno
de los elementos de las listas que se pasan como argumento según la posición
que ocupan en dichas listas.
"""

print(zip(range(1, 10), range(11, 20)))
print(zip(range(1, 10), list('abcdefghi')))
