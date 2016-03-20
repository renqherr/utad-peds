# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 17:47:48 2015

@author: Rafael Enríquez-Herrrador
U-TAD PEDS

4. Escriba una comprensión de lista que a partir de una lista de números genere
otra con el valor absoluto de cada elemento distinto de cero. Los ceros deben
eliminarse de la lista.
"""

li = range(-5, 10)
li.extend(range(-3, 4))

print([abs(x) for x in [y for y in li if y != 0]])