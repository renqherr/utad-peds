# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 20:06:52 2015

@author: Rafael Enriquez-Herrador
U-TAD PEDS

9. Defina una clase PasswordManager que guardará la contraseña actual y el
historial de contraseñas antiguas de un usuario y ofrecerá dos métodos:
    - check_password: se le pasará una contraseña y devolverá True si es la
    contraseña actual del usuario y False en caso contrario.
    - change_password: se le pasará la contraseña actual y la nueva contraseña que
    se desea tener. Si la contraseña actual es correcta y la nueva contraseña es
    distinta de todas las contraseñas almacenadas en el historial, modificará la
    contraseña y devolverá True. En caso contrario no cambiará nada y devolverá
    False.
La contraseña inicial al crear un nuevo objeto PasswordManager será siempre el string
vacío.
"""

class PasswordManager:
    """ Clase que almacena el historico y la actual contraseña de un usuario"""
    
    def __init__(self):
        self.passwords = []
        self.current_password = ''
        
    def check_pasword(self, password):
        if password == self.current_password:
            return True
        else:
            return False
            
    def change_password(self, current_password, new_password):
        if self.check_pasword(current_password) and new_password not in self.passwords:
            self.passwords.append(self.current_password)
            self.current_password = new_password
            
            return True
        else:
            return False