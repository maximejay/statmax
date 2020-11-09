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


#Renvoie le sen entre 2 colonnes
#Utilisation :
#arguments :
#colsim=? : numéro de la colonne des simulations
#colobs=? : numéro de la colonne des observations
#facteur=? : facteur multiplicateur du résultats
#skip=? : nombre de ligne à sauter depuis le début du doc
#nan=? : valeur du not a number. peut être un chaine de caractère, un entier ou un reel
#paste ./exp_jum_max/results_1/plot/output_discharges_uni_var_1_exp_20_scn_1.txt ./exp_jum_max/results_1/observations_uni_var_1_exp_20_scn_1.txt | awk -v colsim=10 -v colobs=20 -v nan="string/int/real" -f sen.awk 
BEGIN {
    #Gère l'entrée des arguments
    inputarg()
    lv=0
}
FNR>skip{
    if ($sim!=na && $obs!=na  && $sim!=""  && $obs!=""  && isnum($obs)>0  && isnum($sim)>0){
        lv=lv+1
        numerateur=numerateur+($sim*fact-$obs*fact)^2.
        #print "lv = " lv " ; colsim = " $s " ; colobs = " $o
        #print "numerateur = " numerateur
        #print "sumqobs = " sumqobs
    }
}
END{
    if (lv>0){
        
        if (res_type == "mse"){
            ise=numerateur/lv
        }
        if (res_type == "rmse"){
            ise=sqrt(numerateur/lv)
        }
        if (res_type == "se"){
            ise=numerateur
        }
        
    }else{
        ise=na
    }
    printoutput(res_type,ise,textfmt,labelserie)
}
