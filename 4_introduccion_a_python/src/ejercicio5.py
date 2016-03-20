# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 18:03:32 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

5. Escriba una función que calcule el producto escalar de dos listas de números,
interpretadas como vectores.
"""

def dot_product(u, v):
    "Producto escalar de dos vectores"
    if len(u) == len(v):
        return sum([x * y for (x, y) in zip(u, v)])
    else:
        return 0
        
# Ejemplos
print dot_product(range(1, 3), range(3, 5)) # Devuelve 11
print dot_product(range(1, 3), range(1, 4)) # Devuelve 0 (Error)
print dot_product(range(-9, 10), range(-9, 10)) # Devuelve 570