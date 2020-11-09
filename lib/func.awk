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

#ICI ON STOCKE LES FONCTIONS A CHARGER POUR LE FONCTIONNEMENT DES SCRIPTS

#Test si x est numérique ! source https://rosettacode.org/wiki/Determine_if_a_string_is_numeric#AWK
function isnum(x){return(x==x+0)}

#Absolute awk function
function abs(value){return (value<0?-value:value);};

#Renvoie le signe de x
function sgn(x){return (x<0? -1.:1)}

#Fonction qui permet de récupérer les valeurs des paramètres d'entrée et d'affecté des valeurs par default
function inputarg(){
    #Ici chaque argument => ces variable sont globals donc il faut faire attention a ne pas en nommer une pareil
    #les renommer en commencan par g_
    
    #USER PARAMS
    g_col=column
    g_sim=colsim
    g_obs=colobs
    g_vartype=type_var 
    g_na=nan
    g_skip=skipline
    g_qt=qvalue
    g_iq=invqsearch
    g_txtfmt=outputfmt #terminal ; data ; head
    g_labelserie=label
    
    #g_fact=facteur
    
    #AUTO CONTROLED PARAMS
    g_calculbycolumns=calculbycolumns
    g_minoumax=minmax
    g_res_type=opt_res
    g_kge_mode=kge_mode
    
    #DEFAULT VALUES
    if (column == 0) {
        g_col=0
    }
    if (colsim == 0) {
        g_calculbycolumns=1
    }
    if (colobs == 0) {
        g_calculbycolumns=1
    }
    if (calculbycolumns==0){
        g_calculbycolumns=0
    }
    if (length(nan)==0){
        g_na="NA"
    }
    if (qvalue==0){
        qt=90
    }
    if (invqsearch==0){
        g_iq="false"
    }
    if (outputfmt==0) {
        g_txtfmt=""
    }
    if (label==0){
        g_labelserie=""
    }
    if (qvalue==0){
        g_qt=90
    }
    if (invqsearch==0){
        g_iq="false"
    }
    if (facteur == 0) {
        g_fact=1
    }
    if (skipline == 0){
        g_skip=0
    }  
}


#Fonction qui permet de récupérer les valeurs des paramètres d'entrée et d'affecté des valeurs par default de matmax
function inputarg_matmax(){
    #Ici chaque argument => ces variable sont globals donc il faut faire attention a ne pas en nommer une pareil
    #les renommer en commencan par g_
    
    g_skip=skipline
    g_scaleprod=scalefactor
    g_scalesum=addscalaire
    g_scalefun=scalefunction
    g_maxval=maxvalue
    g_minval=minvalue
    g_trunc=trunctype
    g_xdim=xdim
    g_ydim=ydim
    g_xstart=xstart
    g_ystart=ystart
    g_lstart=lstart
    g_lend=lend
    g_mode_linmat=mode_linmat
    g_na=nan
    g_datablock=datablock
    g_matrixcompmode=modecompmat
    g_xllc=xllcorner
    g_yllc=yllcorner
    g_cellsize=cellsize
    g_geomatrix=geomatrix
    
    if (skipline == 0){
        g_skip=0
    }
    if (scalefactor == 0){
        g_scaleprod=1.
    }
    if (addscalaire == 0){
        g_scalesum=0.
    }
    if (scalefunction == 0){
        g_scalefun="lineaire"
    }
    if (xdim==0){
        g_xdim=10
    }
    if (ydim==0){
        g_ydim=10
    }
    if (xstart==0){
        g_xstart=1
    }
    if (ystart==0){
        g_ystart=1
    }
    if (lstart==0){
        g_lstart=0
    }
    if (lend==0){
        g_lend=10
    }
    if (length(nan)==0){
        g_na="NA"
    }
    if (trunctype==0){
    	g_trunc="nan"
    }
    if (length(datablock)==0){
        g_datablock="NA"
    }
    if (length(modecompmat)==0){
        g_matrixcompmode="diff"
    }
    if (cellsize==0){
        g_cellsize=1
    }
    if (xllcorner==0){
        g_xllc=0
    }
    if (yllcorner==0){
        g_yllc=0
    }
    if (geomatrix==0){
        g_geomatrix=0
    }
}


function read_data(action){
    
    if (g_col>0){
        startcol=g_col
        endcol=g_col
    }else{
        startcol=1
        endcol=NF
    }
    
    #Ici on calcul la longueur de la chaine correspondant aun numéro de colonne le plus grand
    lenmaxendcol=length(sprintf("%d",endcol))
    #on en deduit un format pour la clé des tableaux
    formatkey="%0"lenmaxendcol"d"
    #ce format permettra de trier correctement les clé : ex 01_ 10_ 11_ et pas 10_ 11_ 1_
    
    for (j=startcol; j<=endcol; j++) {
    
        #On redefini l'indice courant et la clé dans le tableau en fonction du format précédent
        icol=j
        i=sprintf(formatkey,j)
    
        if ($i!=g_na   && $i!=""  && isnum($i)>0){
            
            data["valid"][i]+=1

            switch (action) {
                case "sum" :
                    data["sum"][i] += $icol
                    break
                
                case "minmax" :
                    if (data["valid"][i]==1){
                        data["min"][i]=$icol
                        data["max"][i]=$icol   
                    } 
                    if (data["min"][i]>$icol) data["min"][i]=$icol
                    if (data["max"][i]<$icol) data["max"][i]=$icol
                    
                case "deviation" :
                    data["sum"][i] += $icol
                    data["store"][i][data["valid"][i]] = $icol
                    
                case "median" :
                    data["store"][i][data["valid"][i]] = $i
                    
                default:
                    break 
            }
        }else{
            #Set key "valid" to data and add 0 
        	data["valid"][i]+=0
        }
    }  
}



function read_data_multiple(action){
    
    if (g_calculbycolumns==0){
        startcol=1
        endcol=1 
    }
    if (g_calculbycolumns==1){
        startcol=1
        endcol=NF/2
        if (int(endcol)!=endcol) {
            print "Odd number of column. You must specify explicitly --colobs= and --colsim=."
            exit
        }
    }
    #Ici on calcul la longueur de la chaine correspondant aun numéro de colonne le plus grand
    lenmaxendcol=length(sprintf("%d",endcol))
    #on en deduit un format pour la clé des tableaux
    formatkey="%0"lenmaxendcol"d"
    #ce format permettra de trier correctement les clé : ex 01_ 10_ 11_ et pas 10_ 11_ 1_
_    
     #Lecture des données
    for (j=startcol; j<=endcol; j++){
        if (g_calculbycolumns==1){
            
            #####################################
            #Dans le cas de fichier fusionner en colonne : ex paste fich1 fich2
            #On suppose les obs avant les sim ! c.a.d fich1=obs et fich2=sim
            #####################################
            g_obs=j #Obs colones 1 à NF/2
            g_sim=endcol+j #Sim colonnes NF/2+1 à NF
        }
        
        #Convention utilisée lorsque l'on traite plusieurs colonne :
        #key=colobs_colsim
        i=sprintf(formatkey,g_obs)"_"sprintf(formatkey,g_sim)
        
        if ($g_sim!=g_na && $g_obs!=g_na  && $g_sim!=""  && $g_obs!=""  && isnum($g_obs)>0  && isnum($g_sim)>0){
            
            data["valid"][i]+=1
            
            switch (action) {
                case "nash":
                    data["numerateur"][i]=data["numerateur"][i]+($g_obs-$g_sim)^2.
                    data["qobs"][i][data["valid"][i]]=$g_obs
                    data["sumqobs"][i]=data["sumqobs"][i]+$g_obs
                    break
                    
                case "residual":
                    data["numerateur"][i]=data["numerateur"][i]+($g_obs-$g_sim)^2.
                    break
                
                case "kge":
                    data["qobs"][i][data["valid"][i]]=$g_obs
                    data["qsim"][i][data["valid"][i]]=$g_sim
                    data["sumqsim"][i]=data["sumqsim"][i]+$g_sim #somme
                    data["sumqobs"][i]=data["sumqobs"][i]+$g_obs #somme
                    break
            }
        }else{
            #Set key "valid" to data and add 0 
        	data["valid"][i]+=0
        }
    }   
}



function printoutput(statistiques,value,format,etiquette){
    #remplacement des points par un underscore
    gsub(/\./,"_",statistiques)

    switch (format) {
        case "expr" :
            if (etiquette==""){
                etiquette="SM"
            }
            print etiquette"_"statistiques"="value
            break
            
        case "data" :
            if (labelserie==""){
                print value
            }else{
                print etiquette,value
            }
            break
            
        case "head" :
            if (labelserie==""){
                print statistiques
                print value
            }else{
                print "labels",statistiques
                print etiquette,value
            }
            break
            
        default:
            print value
            break
    }
}


function printoutputarray(statistiques,array,format,etiquette){
    #remplacement des points par un underscore
    gsub(/\./,"_",statistiques)
    
    #Conventions utilisées :
    #critère_col
    #critère_colobs_colsim
    
    #On trie les clés de l'array car awk ne parcour pas forcément l'array dans le bon sens
    #on recupère les clé trié dans dest
    sizearray = asorti(array, dest)
    
    switch (format) {
        case "expr" :
            if (etiquette==""){
                etiquette="SM"
            }
            
            for (i = 1; i <= sizearray ; i++){
                key=dest[i]
                complete_string=complete_string etiquette"_"statistiques"_"key"="array[key]" ; "
            }
           
            print complete_string
            break
            
        case "data" :
            len_label=length(etiquette)+5
            if (etiquette!=""){
                printf "%-"len_label"s", etiquette
            }
            for (i = 1; i <= sizearray ; i++){
                key=dest[i]
                #On calcule la longueur de la chaine à écrire
                format="%-15s"
                len_data=length(sprintf("%s",array[key]))
                if (len_data>=15){
                    format="%-"(len_data+1)"s"
                }
                printf format, array[key]
            }
           
            printf "\n"
            break
            
        case "head" :
            if (etiquette==""){
                for (i = 1; i <= sizearray ; i++){
                    key=dest[i]
                    format="%-15s"
                    len_data=length(sprintf("%s",statistiques"_"key))
                    if (len_data>=15){
                        format="%-"(len_data+1)"s"
                    }
                    printf format, statistiques"_"key
                }
                
                printf "\n"
            }else{
                len_label=length(etiquette)+5
                printf "%-"len_label"s", "labels"
                for (i = 1; i <= sizearray ; i++){
                    key=dest[i]
                    format="%-15s"
                    len_data=length(sprintf("%s",statistiques"_"key))
                    if (len_data>=15){
                        format="%-"(len_data+1)"s"
                    }
                    printf format, statistiques"_"key
                }
                
                printf "\n"
                printf "%-"len_label"s", etiquette
            }
            for (i = 1; i <= sizearray ; i++){
                key=dest[i]
                format="%-15s"
                len_data=length(sprintf("%s",array[key]))
                if (len_data>=15){
                    format="%-"(len_data+1)"s"
                }
                printf format, array[key]
            }
           
            printf "\n"
            break
            
        default:
            if (etiquette==""){
                
                for (i = 1; i <= sizearray ; i++){
                    key=dest[i]
                    format="%-15s"
                    len_data=length(sprintf("%s",statistiques"_"key))
                    if (len_data>=15){
                        format="%-"(len_data+1)"s"
                    }
                    printf format, statistiques"_"key
                }
                
                printf "\n"
            }else{
                len_label=length(etiquette)+5
                printf "%-"len_label"s", "labels"
                for (i = 1; i <= sizearray ; i++){
                    key=dest[i]
                    format="%-15s"
                    len_data=length(sprintf("%s",statistiques"_"key))
                    if (len_data>=15){
                        format="%-"(len_data+1)"s"
                    }
                    printf format, statistiques"_"key
                }
                
                printf "\n"               
                printf "%-"len_label"s", etiquette
               
            }
            for (i = 1; i <= sizearray ; i++){
                key=dest[i]
                format="%-15s"
                len_data=length(sprintf("%s",array[key]))
                if (len_data>=15){
                    format="%-"(len_data+1)"s"
                }
                printf format, array[key]
            }
            
            printf "\n"
            break
    }
}



# round.awk --- do normal rounding

function round(x)
{
   ival = int(x)    # integer part, int() truncates

   # see if fractional part
   if (ival == x)   # no fraction
      return ival   # ensure no decimals

   if (x < 0) {
      aval = -x     # absolute value
      ival = int(aval)
      fraction = aval - ival
      if (fraction >= .5)
         return int(x) - 1   # -2.5 --> -3
      else
         return int(x)       # -2.3 --> -2
   } else {
      fraction = x - ival
      if (fraction >= .5)
         return ival + 1
      else
         return ival
   }
}


