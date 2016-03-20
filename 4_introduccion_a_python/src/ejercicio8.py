# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 19:45:00 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

8. Escriba un programa que lea un fichero de texto y escriba en pantalla la
frecuencia de cada palabra en el texto. Se considerará que una palabra es
cualquier cadena entre espacios, sin tratar de ningún modo especial caracteres
como los signos de puntuación.
"""

file = open("../data/texto.txt", "r")

word_count = {} # Diccionario vacio

for word in file.read().split():
    if word not in word_count:
        word_count[word] = 1
    else:
        word_count[word] += 1
        
print word_count

file.close()