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


#Script to scale matrix for different law such as m2=a*m1+b or m2=m1**a+b ... !
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
    xline=""
    i=1
}
(FNR>g_skip){
    if (g_mode_linmat=="linearise"){
        for(i=1;i<=NF;++i) {
            print $i
        }
    }
    if (g_mode_linmat=="unlinearise"){
        if(i<=g_ydim) {
            #print $1
             xline=xline" "$1
        }
        if (i==g_ydim){
            print xline
            xline=""
            i=0
        }
        i=i+1        
    }
}

