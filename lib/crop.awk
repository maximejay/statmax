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


#Script to crop/extrac matrix data from a xy path. output is a matrix given the size of the original one. Values are printed inside the domain given by the x,y closed path, whereas outside points are set to nan values.
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
}
{ 
    #read matrix
    if (NR==FNR){ 
        if (isnum($1)>0){
            
            #we suppose to read the matrix
            nb_read_rows=nb_read_rows+1
            
            for (i=1;i<=NF;i++){
                nb_read_col=NF
                matrix[nb_read_rows,i]=$i
                mask_matrix[nb_read_rows,i]=g_na
                out_matrix[nb_read_rows,i]=g_na
            }
            
        }else{
        
            #read header if geomatrix
            if (g_geomatrix==1){
                #check header of stdr geo-matrix data
                switch(tolower($1)){
                    case "ncols":
                        nbcols=$2
                    break
                    case "nrows":
                        nbrows=$2
                    break
                    case "xllcorner":
                        g_xllc=$2
                    break
                    case "yllcorner":
                        g_yllc=$2
                    break
                    case "cellsize":
                        g_cellsize=$2
                    break
                    case "nodata_value":
                        nan_matrix=$2
                    break
                }
            }
        }
    }

     
    nbcols=nb_read_col
    nbrows=nb_read_rows
    
    #read contour
    if (NR>FNR){
    
        if (isnum($1)>0 && isnum($2)>0){
        
            xcoord_new=int($1/g_cellsize)*g_cellsize
            ycoord_new=int($2/g_cellsize)*g_cellsize

            if (count>0){
                
                dx=abs(xcoord_new-xcoord[count])
                dy=abs(ycoord_new-ycoord[count])
                
                #Interpolation du le maillage
                if (dx>g_cellsize || dy>g_cellsize){
                    #print "require new points!"
                    while(dx>g_cellsize || dy>g_cellsize){
                        #recherche d'un point a ajouter
                        step=1/2.
                        xcoord_add=int((xcoord[count]+step*(xcoord_new-xcoord[count]))/g_cellsize)*g_cellsize
                        ycoord_add=int((ycoord[count]+step*(ycoord_new-ycoord[count]))/g_cellsize)*g_cellsize
                        
                        dx=abs(xcoord_add-xcoord[count])
                        dy=abs(ycoord_add-ycoord[count])
                        
                        
                        while (dx>g_cellsize || dy>g_cellsize){
                            #division du step jusqu'a atteindre la bonne taille de maille
                            step=step/2.
                            xcoord_add=int((xcoord[count]+step*(xcoord_new-xcoord[count]))/g_cellsize)*g_cellsize
                            ycoord_add=int((ycoord[count]+step*(ycoord_new-ycoord[count]))/g_cellsize)*g_cellsize
                            
                            dx=abs(xcoord_add-xcoord[count])
                            dy=abs(ycoord_add-ycoord[count])
                        }
                        
                        
                        count=count+1
                        xcoord[count]=xcoord_add
                        ycoord[count]=ycoord_add

                        dx=abs(xcoord_new-xcoord[count])
                        dy=abs(ycoord_new-ycoord[count])

                    }
                    
                  }else{
                    count=count+1
                    xcoord[count]=xcoord_new
                    ycoord[count]=ycoord_new
                    #print "2",count,xcoord[count],ycoord[count],$1,$2
                  }
                
                    
            }else{
                count=count+1
                xcoord[count]=xcoord_new
                ycoord[count]=ycoord_new
                #print "3",count,xcoord[count],ycoord[count]
            }
            
        }
    }

}
END{
    
    #print header if geomatrix
    if (g_geomatrix==1){
        print "ncols",nbcols
        print "nrows",nbrows
        print "xllcorner",g_xllc
        print "yllcorner",g_yllc
        print "cellsize",g_cellsize
        print "nodata_value",g_na
    }   
    
    for (k=1;k<=count;k++){
        i=(xcoord[k]-g_xllc)/g_cellsize+1
        j=nbrows-(ycoord[k]-g_yllc)/g_cellsize
        mask_matrix[j,i]=1
    }
    
    
    for (j=1;j<=nbrows;j++){
        result=""
        
        
        index_left=NF
        index_right=0
        
        for (i=1;i<=nbcols;i++){
            if (mask_matrix[j,i]==1){
                index_left=i
                break
            }
        }
        for (i=nbcols;i>=1;i--){
            if (mask_matrix[j,i]==1){
                index_right=i
                break
            }
        }
        
        
        for (i=1;i<=nbcols;i++){ 
        
            index_up=nbcols
            index_bottom=0
            
            for (k=j;k<=nbrows;k++){
                if (mask_matrix[k,i]==1){
                    index_bottom=k
                    break
                }
            }
            for (k=j;k>=1;k--){
                if (mask_matrix[k,i]==1){
                    index_up=k
                    break
                }
            }
        
             
        
            if (index_left<=i && i<=index_right && j<=index_bottom && j>=index_up){
                #out_matrix[j,i]=1.0
                out_matrix[j,i]=matrix[j,i]
            }
            result=result" "out_matrix[j,i]
            #result=result" "mask_matrix[j,i]
        }
  
        printf result "\n"
    }
}


