# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 19:23:39 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

7. Escriba una función que modifique una lista eliminando sus elementos
duplicados. Debe preservar el orden en que aparecen los elementos
(por primera vez).
"""

def distinct(li):
    "Recibe una lista como parametro y elimina los elementos duplicados manteniendo el orden"
    temp = []
    
    for x in li:
        if x not in temp:
            temp.append(x)
            
    return temp
    
    
print distinct(['a', 'b', 'b', 'a', 'c', 'd', 'a']) # Devuelve ['a', 'b', 'c', 'd']
print distinct([1, 3, 4, 2, 5, 1, 1, 7, 2]) # Devuelve [1, 3, 4, 2, 5, 7]
