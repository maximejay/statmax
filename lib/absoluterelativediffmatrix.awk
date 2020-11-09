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


#Script to compute the absolute relative differences between 2 matrix : abs(A-B)/abs(B)
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
}
(FNR>g_skip && NR==FNR){
        for(i=1;i<=NF;++i) {
		    a[FNR,i]=$i
	    }
	    next
}
FNR>g_skip{
   for(i=1;i<=NF;++i){
        $i=abs((a[FNR,i]-$i))/abs($i)
    }
    print
}

