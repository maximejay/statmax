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


#Script to extract a block data from lstart lines to lend_line
#g_lstart : x position to start the extraction, x=1 is the upper left corner
#g_lend : y position to start the extraction, y=1 is the upper left corner
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
}
(FNR>=g_lstart && FNR<=g_lend){
    print $0
}


