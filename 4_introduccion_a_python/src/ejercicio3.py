# -*- coding: utf-8 -*-
"""
Created on Wed Apr 29 20:49:11 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

3. Escriba un programa que calcule el número de vocales en la frase "En un
lugar de la Mancha, de cuyo nombre no quiero acordarme".
"""

frase = 'En un lugar de la Mancha, de cuyo nombre no quiero acordarme'
vocales = set('aeiouAEIOU')
count = 0

for e in frase:
    if e in vocales:
        count += 1
        
print(count)