#Copyright 2018 Maxime Jay-Allemand
#    This file is part of Statmax.

#    Statmax is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    Statmax is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with Statmax.  If not, see <https://www.gnu.org/licenses/>.


#Renvoie la mediane entre d'1 colonne
#Utilisation :
#arguments :
#col=? : numéro de la colonne
#skip=? : nombre de ligne à sauter depuis le début du doc
#nan=? : valeur du not a number. peut être un chaine de caractère, un entier ou un reel



BEGIN {
    #Gère l'entrée des arguments
    inputarg()
}
FNR>g_skip{
    read_data("median")
}
END{
    for (kcol in data["valid"]){
        if (data["valid"][kcol]>0) {
            asort(data["store"][kcol], datasort);
            
            if (data["valid"][kcol]/2==int(data["valid"][kcol]/2)){
                result[kcol]=1/2*(datasort[int(data["valid"][kcol]/2)]+datasort[int(data["valid"][kcol]/2)+1])
            }else{
                result[kcol]=datasort[int(data["valid"][kcol]/2)+1]
            }
            
        }else{
            result[kcol]=g_na
        }
    }
    printoutputarray("median",result,g_txtfmt,g_labelserie)
}

