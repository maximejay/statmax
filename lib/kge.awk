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


#Renvoie le kge entre 2 colonnes
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
    read_data_multiple("kge")
    #Condition sur les colonnes : On ne passe qu'une seule fois ! faire attention au fichier d'entrée
}
END{
    #Calcul du KGE
    
    #Boucle sur les colonnes
    for (kcol in data["valid"]){
        
        #Initialisation du résulat
        result[kcol]=g_na
        
        #test si des données valides ont été lu
        if (data["valid"][kcol]>0){ 
            
            #Calcul des moyennes      
            meanqobs=data["sumqobs"][kcol]/data["valid"][kcol]
            meanqsim=data["sumqsim"][kcol]/data["valid"][kcol]
            
            #Boucle sur les lignes
            for (kligne in data["qobs"][kcol]){
            
                #calcul des variances (somme des écarts au carré)
                Nvarianceqsim[kcol]=Nvarianceqsim[kcol]+(data["qsim"][kcol][kligne]-meanqsim)^2
                Nvarianceqobs[kcol]=Nvarianceqobs[kcol]+(data["qobs"][kcol][kligne]-meanqobs)^2
                Ncovariance[kcol]=Ncovariance[kcol]+(data["qobs"][kcol][kligne]-meanqobs)*(data["qsim"][kcol][kligne]-meanqsim)
                
            }
            
            if (Nvarianceqsim[kcol]!=0 && Nvarianceqobs[kcol]!=0 && meanqobs!=0){
            
                #calcul des coef de pearson,alpha et beta pour le kge
                pearson[kcol]=Ncovariance[kcol]/(sqrt(Nvarianceqsim[kcol])*sqrt(Nvarianceqobs[kcol]))
                alpha[kcol]=sqrt(Nvarianceqsim[kcol])/sqrt(Nvarianceqobs[kcol])
                beta[kcol]=meanqsim/meanqobs
                
                #On retourne le résultat attendu en fonction du mode
                if (g_kge_mode=="pearson"){
                    result[kcol]=pearson[kcol]
                }
                if (g_kge_mode=="rmu"){
                    result[kcol]=beta[kcol]
                }
                if (g_kge_mode=="rvar"){
                    result[kcol]=alpha[kcol]
                }
                if (g_kge_mode=="kge"){
                    result[kcol]=1-sqrt( (pearson[kcol]-1.)**2. + (alpha[kcol]-1.)**2. + (beta[kcol]-1.)**2. )
                }
                if (g_kge_mode=="kge_decompo"){
                    result[kcol]= "\"" sprintf("%g",1-sqrt( (pearson[kcol]-1.)**2. + (alpha[kcol]-1.)**2. + (beta[kcol]-1.)**2. ) )" "sprintf("%g",pearson[kcol])" "sprintf("%g",alpha[kcol])" "sprintf("%g",beta[kcol]) "\""
                }
                
            }else{
                result[kcol]=g_na
            }  
        }  
    }
    
    #print les résultats
    printoutputarray(g_kge_mode,result,g_txtfmt,g_labelserie)
}
