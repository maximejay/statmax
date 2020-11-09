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


#Script to extract a part of a matrix
#depend on the following arguments :
#xstart : x position to start the extraction, x=1 is the upper left corner
#ystart : y position to start the extraction, y=1 is the upper left corner
#xdim : x size dimension of the new domain
#ydim : y size dimension of the new domain
#skipline : nb line to skip at the begining of the input file
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
    i=1
    j=1
    NRLOCAL=1 #Compteur de ligne NR-g_skip
}
(FNR>g_skip){
    NRLOCAL=NR-g_skip
    if (NRLOCAL>=g_xstart && NRLOCAL<=g_xstart+g_xdim-1){
        j=1
        maxcol=g_ystart+g_ydim-1
        if (g_ystart+g_ydim-1>NF) maxcol=NF
        for(col=g_ystart;col<=maxcol;++col) {
            #print col,$col
            a[i,j]=$col
            j=j+1
            if (max_y_size<j-1) max_y_size=j-1
	    } 
	    i=i+1
	    max_x_size=i-1
    }
}
END{
    for (i=1;i<=max_x_size;++i){
        for (j=1;j<=max_y_size;++j){
            printf "%s%s", a[i,j], (j==max_y_size?RS:FS)
        }
    }
}


