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
    lv=0

    #Gère l'entrée des arguments
    inputarg()

}
FNR>skip{
    if ($c!=na && $c!=""  && isnum($c)>0){
        lv=lv+1
        data[lv]=$c
    }
}
END{
    if (lv>1){
        asort(data, datasort);
        if (lv/2==int(lv/2)){
            median=1/2*(datasort[int(lv/2)]+datasort[int(lv/2)+1])
        }else{
            median=datasort[int(lv/2)+1]
        }
        
#        for (k=1;k<=lv;k++){ 
#            print datasort[k]
#        }
    }
    if (lv>1) {
        result=median
    }else{
        result=na 
    }
    printoutput("median",result,textfmt,labelserie)
}
