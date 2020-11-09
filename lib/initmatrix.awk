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
}
END{
    for(i=1;i<=g_xdim;++i) {
        for (j=1;j<=g_ydim;++j){
	        $j=0.0
	    }
	    print
    }
   
}
