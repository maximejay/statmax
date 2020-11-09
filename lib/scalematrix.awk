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
}
(FNR>g_skip){
    for(i=1;i<=NF;++i) {
        if (isnum($i)>0){
            switch (g_scalefun){
            case "lineaire":
	            $i=g_scaleprod*$i+g_scalesum
	            break
	        case "power":
	            $i=g_scalesum+$i**g_scaleprod
	            break
	        case "log":
	            $i=g_scaleprod*log($i)+g_scalesum
	            break
	        case "log10":
	            $i=g_scaleprod*log($i)/log(10.)+g_scalesum
	            break
	        case "exp":
	            $i=g_scaleprod*exp($i)+g_scalesum
	            break
	        case "sqrt":
	            $i=g_scaleprod*sqrt($i)+g_scalesum
	            break
	        case "abs":
	            $i=g_scaleprod*abs($i)+g_scalesum
	            break
	        default:
	            break
	        }
	   }else{
	        $i=g_na
	   }
    }
    print
}
