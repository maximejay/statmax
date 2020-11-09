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


#Script to scale matrix m2=a*m1+b !
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
    #Initialisation
    current_nfield=0
    printligne="false"
    current_ligne=""
}
(FNR>g_skip){
    
    
    #Test si current_ligne_number >0
    if (current_ligne_number>0){
        printligne="false"
        if (current_nfield!=NF) {
            printligne="true"
            why=why"Different number of fields ; "
        }
        
        k=0
        for (i=1;i<=NF;++i){
            if (current_type[i]!=isnum($i)){
                printligne="true"
                if (k==0){
                    why=why" Different kind of fields ; "
                    k=k+1
                }
            }
        }
    }
    
    
    
    
    #Impression
    if (printligne=="true"){
        print "ligne " FNR-1, ":", current_ligne
        print "ligne " FNR, ":", $0
        print  "Why : " why
        print "------------------------------------"
    }
    current_ligne=""
    why=""
    
    
    
    #Affectation
    for (i=1;i<=NF;++i){
       current_ligne=current_ligne " " $i
       current_type[i]=isnum($i)
    }
    current_nfield=NF
    
    current_ligne_number=current_ligne_number+1
}
