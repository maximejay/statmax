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
#renvoie : Somme ; moyenne ; écar-type
#Utilisation :
#column=? : numéro de la colonne
#nan="NA" : valeur du not a number !casse sensitive
#skip=? : nombre de ligne à sauter
#qvalue=90 : valeur du quantile qvalue recherché dans la distribution
#invqsearch=true/false : inverse la recherche du quantile : qvalue devient la veleur du critère à chercher et le résultat est le quantile correspondant

#exemple
#awk -v column=1 -v nan="string/int/real" -f stats.awk < monfich


BEGIN {
    #Gère l'entrée des arguments
    inputarg()
    lv=0
}
FNR>g_skip{
    if ($col!=g_na   && $col!="" && isnum($col)>0){
        lv=lv+1
        tabcol[lv]=$col
        sumcol=sumcol+$col
        #print "FNR = " FNR " ; colsim = " $s " ; colobs = " $o
        #print "numerateur = " numerateur
        #print "sumqobs = " sumqobs
    }
}
END{

    #sum,mean,sigma
    if (lv>0){
        meancol=sumcol/lv
        #print "meanqobs = " meanqobs
        for (k=1;k<=lv;k++){
            numerateur=numerateur+(tabcol[k]-meancol)^2
        }
        sigma=sqrt(numerateur/lv)
    }else{
        sumcol=na
        meancol=na
        sigma=na
    }
    
    #median / quantile
    if (lv>1){
        asort(tabcol, tabcolsort);
        if (lv/2==int(lv/2)){
            median=1/2*(tabcolsort[int(lv/2)]+tabcolsort[int(lv/2)+1])
        }else{
            median=tabcolsort[int(lv/2)+1]
        }
        min=tabcolsort[1]
        max=tabcolsort[lv]
        
        pos=int(g_qt*lv/100)
        if (pos==g_qt*lv/100){
            quantile=tabcolsort[pos]
        }else{
            quantile=tabcolsort[pos]+(g_qt*lv/100-pos)*(tabcolsort[pos+1]-tabcolsort[pos])
        }
        
        if (g_iq=="true"){
            for (k=1;k<=lv;k++){
                pos=k
                if (g_qvalue<=tabcolsort[k]){
                    break
                }
            }
            if (g_qvalue==tabcolsort[pos]){
                quantile=pos/lv*100
            }else{
                quantile=((pos-1)+pos)/2/lv*100
                if (pos==1){
                    quantile=0
                }
            }
        }

    }else{
        median=g_na
        quantile=g_na
        min=g_na
        max=g_na
    }
    
    
    #remplacement de la virgule par un underscore
    gsub(/\./,"_",g_qt)

    switch (g_txtfmt) {
        case "expr" :
            if (g_labelserie==""){
                g_labelserie="SM"
            }
            print g_labelserie"_nbrecords="FNR-skip " ; "g_labelserie"_nbvalidrecords="lv " ; "g_labelserie"_min="min " ; "g_labelserie"_max="max " ; "g_labelserie"_sum="sumcol " ; "g_labelserie"_mean="meancol " ; "g_labelserie"_deviation="sigma " ; "g_labelserie"_median="median " ; "g_labelserie"_quantile"qt"="quantile
            break
        case "data" :
            print g_labelserie,FNR-skip,lv,min,max,sumcol,meancol,sigma,median,quantile
            break
        case "head" :
            if (g_labelserie==""){
                print "nbrecords","nbvalidrecord","min","max","sum","mean","deviation","median","quantile"g_qt            
            }else{
                print "labels","nbrecords","nbvalidrecords","min","max","sum","mean","deviation","median","quantile"g_qt
            }
            print g_labelserie,FNR-skip,lv,min,max,sumcol,meancol,sigma,median,quantile
            break
        default:
            print "nbrecords="FNR-g_skip " ; nbvalidrecords="lv " ; min="min " ; max="max " ; sum="sumcol " ; mean="meancol " ; deviation="sigma " ; median="median " ; quantile"g_qt"="quantile
            break
    }
}

