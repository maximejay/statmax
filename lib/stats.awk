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
}
FNR>g_skip{
    read_data("deviation")
}
END{
    for (kcol in data["valid"]){
        if (data["valid"][kcol]>0) {
            
            #mean,deviation,variance,sum
            mean[kcol]=data["sum"][kcol]/data["valid"][kcol]
            
            for (kligne in data["store"][kcol]){
               numerateur[kcol]=numerateur[kcol]+(data["store"][kcol][kligne]-mean[kcol])^2 
            }

            deviation[kcol]=sqrt(numerateur[kcol]/data["valid"][kcol])
            variance[kcol]=(numerateur[kcol]/data["valid"][kcol])
            sum[kcol]=data["sum"][kcol]
            
            #min,max,median,quantile      
            asort(data["store"][kcol], datasort);
            
            min[kcol]=datasort[1]
            max[kcol]=datasort[data["valid"][kcol]]
            
            #median
            pos=int(data["valid"][kcol]/2)
            if (data["valid"][kcol]/2==int(data["valid"][kcol]/2)){
                median[kcol]=1/2*(datasort[pos]+datasort[pos+1])
            }else{
                median[kcol]=datasort[pos+1]
            }
            
            
            #quantile
            pos=int(g_qt*data["valid"][kcol]/100)
            if (data["valid"][kcol]>1){
                quantile[kcol]=datasort[pos]+(g_qt*data["valid"][kcol]/100-pos)*(datasort[pos+1]-datasort[pos])
            }else{
                quantile[kcol]=g_na
            }

        }else{
            deviation[kcol]=g_na
            variance[kcol]=g_na
            mean[kcol]=g_na
            sum[kcol]=g_na
            median[kcol]=g_na
            quantile[kcol]=g_na
            min[kcol]=g_na
            max[kcol]=g_na
        }  
    }
    
    
    #remplacement de la virgule par un underscore
    gsub(/\./,"_",g_qt)
    
    #On trie les clés de l'array car awk ne parcour pas forcément l'array dans le bon sens
    #on recupère les clé trié dans dest
    sizearray = asorti(data["valid"], dest)
    
    #On parcour depuis la colonne 1 à la colonne finale
    for (i = 1; i <= sizearray ; i++){
       key=dest[i]
       
       switch (g_txtfmt) {
            case "expr" :
                if (g_labelserie==""){
                    g_labelserie="SM"
                }
                printf "%s", g_labelserie"_nbrecords_"key"="FNR-g_skip " ; "g_labelserie"_nbvalidrecords_"key"="data["valid"][key] " ; "g_labelserie"_min_"key"="min[key] " ; "g_labelserie"_max_"key"="max[key] " ; "g_labelserie"_sum_"key"="sum[key] " ; "g_labelserie"_mean_"key"="mean[key] " ; "g_labelserie"_deviation_"key"="deviation[key] " ; "g_labelserie"_variance_"key"="variance[key] " ; "g_labelserie"_median_"key"="median [key]" ; "g_labelserie"_quantile"qt"_"key"="quantile[key] " ;"
                break
                
            case "data" :
                if (g_labelserie==""){
                    printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n",  key,FNR-g_skip,data["valid"][key],min[key],max[key],sum[key],mean[key],deviation[key],variance[key],median[key],quantile[key]
                }else{
                    len_label=length(g_labelserie)+5
                    printf "%-15s %-"len_label"s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n",  key,g_labelserie,FNR-g_skip,data["valid"][key],min[key],max[key],sum[key],mean[key],deviation[key],variance[key],median[key],quantile[key]
                }
                break
                
            case "head" :
                if (i==1){
                    if (g_labelserie==""){
                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n", "columns","nbrecords","nbvalidrecord","min","max","sum","mean","deviation","variance","median","quantile"g_qt            
                    }else{
                        len_label=length(g_labelserie)+5
                        printf "%-15s %-"len_label"s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n", "columns","labels","nbrecords","nbvalidrecords","min","max","sum","mean","deviation","variance","median","quantile"g_qt
                    }
                }
                if (g_labelserie==""){
                    printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n",  key,FNR-g_skip,data["valid"][key],min[key],max[key],sum[key],mean[key],deviation[key],variance[key],median[key],quantile[key]
                }else{
                    len_label=length(g_labelserie)+5
                    printf "%-15s %-"len_label"s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n",  key,g_labelserie,FNR-g_skip,data["valid"][key],min[key],max[key],sum[key],mean[key],deviation[key],variance[key],median[key],quantile[key]
                }
                break

            default:
                if (i==1){
                    if (g_labelserie==""){
                        printf "%-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n", "columns","nbrecords","nbvalidrecord","min","max","sum","mean","deviation","variance","median","quantile"g_qt            
                    }else{
                        len_label=length(g_labelserie)+5
                        printf "%-15s %-"len_label"s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n", "columns","labels","nbrecords","nbvalidrecords","min","max","sum","mean","deviation","variance","median","quantile"g_qt
                    }
                }
                if (g_labelserie==""){
                    printf "%-15i %-15i %-15i %-15g %-15g %-15g %-15g %-15g %-15g %-15g %-15g\n",  key,FNR-g_skip,data["valid"][key],min[key],max[key],sum[key],mean[key],deviation[key],variance[key],median[key],quantile[key]
                }else{
                    len_label=length(g_labelserie)+5
                    printf "%-15i %-"len_label"s %-15i %-15i %-15g %-15g %-15g %-15g %-15g %-15g %-15g %15g\n",  key,g_labelserie,FNR-g_skip,data["valid"][key],min[key],max[key],sum[key],mean[key],deviation[key],variance[key],median[key],quantile[key]
                }
                break
       }

    }
    
}

