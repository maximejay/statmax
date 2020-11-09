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


#Renvoie des info statistiques d'une colonne de données
#Calcul de la variance
#column=? : numéro de la colonne
#nan="NA" : valeur du not a number !casse sensitive
#skip=? : nombre de ligne à sauter


BEGIN {
    
    #Gère l'entrée des arguments
    inputarg()

}
FNR>g_skip{
    read_data("deviation")
}
END{

    for (kcol in data["valid"]){
        if (data["valid"][kcol]>0) {
            meancol=data["sum"][kcol]/data["valid"][kcol]
            
            for (kligne in data["store"][kcol]){
               numerateur[kcol]=numerateur[kcol]+(data["store"][kcol][kligne]-meancol)^2 
            }
            
            if (g_vartype=="variance"){
                result[kcol]=numerateur[kcol]/data["valid"][kcol]
            }
            if (g_vartype=="deviation"){
                result[kcol]=sqrt(numerateur[kcol]/data["valid"][kcol])
            }
        
        }else{
            result[kcol]=g_na
        }
    }

    printoutputarray(g_vartype,result,g_txtfmt,g_labelserie)
}
