# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 19:16:50 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

6. Escriba una función a la que se le pase una lista de números y calcule su media.
"""

def arithmetic_mean(li):
    total_sum = 0.0
    n_items = 0.0
    
    for i in li:
        total_sum += i
        n_items += 1
        
    return total_sum / n_items
    
    
# Ejemplos
print arithmetic_mean(range(5, 10)) # Devuelve 5
print arithmetic_mean([2, 2, 2, 2, 3]) # Devuelve 2.2