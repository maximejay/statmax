#Program Statmax
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


#Renvoie le quantile d'1 colonne
#Utilisation :
#arguments :
#col=? : numéro de la colonne
#skip=? : nombre de ligne à sauter depuis le début du doc
#nan=? : valeur du not a number. peut être un chaine de caractère, un entier ou un reel
#qvalue=? : valeur du quantile en pourcentage
#invqsearch=true/false : inverse la recherche du quantile : qvalue devient la veleur du critère à chercher et le résultat est le quantile correspondant

BEGIN {
    #Gère l'entrée des arguments
    inputarg()
    lv=0
}
FNR>skip{
    if ($col!=na && $col!=""  && isnum($col)>0){
        lv=lv+1
        data[lv]=$col
    }
}
END{
    if (lv>1){
        asort(data, datasort);
        
        pos=int(qt*lv/100)
        if (pos==qt*lv/100){
            quantile=datasort[pos]
        }else{
            quantile=datasort[pos]+(qt*lv/100-pos)*(datasort[pos+1]-datasort[pos])
        }     
        
        if (iq=="true"){
            for (k=1;k<=lv;k++){
                pos=k
                if (qvalue<=datasort[k]){
                    break
                }
            }
            if (qvalue==datasort[pos]){
                quantile=pos/lv*100
            }else{
                quantile=((pos-1)+pos)/2/lv*100
                if (pos==1){
                    quantile=0
                }
            }
        }
          
    }
    if (lv>1) {
        result=quantile
    }else{
        result=na 
    }
    printoutput("quantile"qt,result,textfmt,labelserie)
}
