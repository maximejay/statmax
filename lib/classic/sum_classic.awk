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
#Calcul de la somme
#column=? : numéro de la colonne
#nan="NA" : valeur du not a number !casse sensitive
#skip=? : nombre de ligne à sauter


BEGIN {
    #Gère l'entrée des arguments
    inputarg()
}
FNR>skip{
    if ($col!=na   && $col!=""  && isnum($col)>0){
        sum+=$col
    }
}
END{
    printoutput("sum",sum,textfmt,labelserie)
}
