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


#Renvoie le Nash entre 2 colonnes
#Utilisation :
#arguments :
#colsim=? : numéro de la colonne des simulations
#colobs=? : numéro de la colonne des observations
#skip=? : nombre de ligne à sauter depuis le début du doc
#nan=? : valeur du not a number. peut être un chaine de caractère, un entier ou un reel
#paste ./exp_jum_max/results_1/plot/output_discharges_uni_var_1_exp_20_scn_1.txt ./exp_jum_max/results_1/observations_uni_var_1_exp_20_scn_1.txt | awk -v colsim=10 -v colobs=20 -v nan="string/int/real" -f nash.awk 


BEGIN {
    #Gère l'entrée des arguments
    inputarg()
}
FNR>g_skip{
    read_data_multiple("nash")
    #Condition sur les colonnes : On ne passe qu'une seule fois ! faire attention au fichier d'entrée
}
END{
    #Calcul du Nash
    #Boucle sur les colonnes
    for (kcol in data["valid"]){
        
        if (data["valid"][kcol]>0){       
            meanqobs=data["sumqobs"][kcol]/data["valid"][kcol]
            #Boucle sur les lignes
            for (kligne in data["qobs"][kcol]){
                data["denominateur"][kcol]=data["denominateur"][kcol]+(data["qobs"][kcol][kligne]-meanqobs)^2
            }
        }
        if (data["denominateur"][kcol] != 0){
            result[kcol]=1-data["numerateur"][kcol]/data["denominateur"][kcol]
        }else{
            result[kcol]=g_na
        }
    }
    
    printoutputarray("Nash",result,g_txtfmt,g_labelserie)
}
