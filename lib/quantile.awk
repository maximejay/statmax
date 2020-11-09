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
}
FNR>g_skip{
    read_data("median")
}
END{
    for (kcol in data["valid"]){        
        if (data["valid"][kcol]>0) {
            asort(data["store"][kcol], datasort);
            
            pos=int(g_qt*data["valid"][kcol]/100)
            
            #Quantile par interpolation : renvoie la valeur la plus basse => Quantile 50% = floor(medianne)
            result[kcol]=datasort[pos]+(g_qt*data["valid"][kcol]/100-pos)*(datasort[pos+1]-datasort[pos]) 

            if (g_iq=="true"){
                for (kline in datasort){
                    pos=kline
                    if (g_qt<=datasort[kline]){
                        break
                    }
                }
                if (g_qt==datasort[pos]){
                    result[kcol]=pos/data["valid"][kcol]*100
                }else{
                    result[kcol]=((pos-1)+pos)/2/data["valid"][kcol]*100
                    if (pos==1){
                        result[kcol]=0
                    }
                }
                
            }
            
        }else{
            result[kcol]=g_na
        }
    }
    printoutputarray("quantile"g_qt,result,g_txtfmt,g_labelserie)
}
