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


#Script to compute the différence de 2 valeurs consécutives en colonne A[i]-A[i-1] ... !
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
    xline=""
    i=1
    j=1
    count=0
}
(FNR>g_skip){
    #On lit une ligne de plus
    count=count+1
    for(i=1;i<=NF;++i) {
        #On affecte la valeur de la colonne à la ligne courante
        val[count,i]=$i
    }
    #Lorsque l'on a lu 2 ligne on calcul la différence
    if (count==2){
        for(i=1;i<=NF;++i) {
            #on calcul la diff
            $i=(val[2,i]-val[1,i])
            #on switch
            val[1,i]=val[2,i]
        }
        print
        #incrémente le compteur total des output
        j=j+1
        #On remet le compteur de ligne à 1
        count=1
    }  
}

