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
    
    lv=0
    numerateur=0
    sumqobs=0
   # print "colsim = " sim " ; colobs = " obs " : skipline=" skip
}
FNR>skip{
    if ($sim!=na && $obs!=na  && $sim!=""  && $obs!=""  && isnum($obs)>0  && isnum($sim)>0){
        lv=lv+1
        numerateur=numerateur+($obs-$sim)^2.
        qobs[lv]=$obs
        sumqobs=sumqobs+$obs
        #print "FNR = " FNR " ; colsim = " $sim " ; colobs = " $obs
        #print "numerateur = " numerateur
        #print "sumqobs = " sumqobs
    }
}
END{
    if (lv>0){
        meanqobs=sumqobs/lv
        #print "meanqobs = " meanqobs
        for (k=1;k<=lv;k++){
            denominateur=denominateur+(qobs[k]-meanqobs)^2
         #   print k,qobs[k], "denominateur=" denominateur
        }
    }
    
    
    
    if (denominateur != 0){
        Nash=1-numerateur/denominateur
    }else{
        Nash=na
    }

    printoutput("Nash",Nash,textfmt,labelserie)
}
