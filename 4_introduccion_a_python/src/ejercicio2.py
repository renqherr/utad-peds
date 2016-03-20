# -*- coding: utf-8 -*-
"""
Created on Wed Apr 29 20:41:34 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

2. Escriba un programa que halle todos los enteros entre 2000 y 3200 (ambos
incluidos) que sean divisibles por 7 pero no múltiplos de 5.
"""

for e in range(2000, 3201):
    if e % 7 == 0 and e % 5 != 0:
        print(e)