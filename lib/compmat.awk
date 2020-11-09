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


#Script to compare 2 matrix : many modes... 
BEGIN { 
    #Gère l'entrée des arguments
    inputarg_matmax()
}
(FNR>g_skip){
        if(FNR==NR){
            file1=1
            file2=0
            ka=ka+1
        }
        if(NR>FNR){
           file1=0
           file2=1
           kb=kb+1
        }
        for(i=1;i<=NF;++i) {
            if (file1==1){
		        
		        if (isnum($i)>0){
		            a[ka,i]=$i
		            sum_a=sum_a+$i
		            max_a=(max_a<$i?$i:max_a)
		            count_a=count_a+1
		        }else{
		            a[ka,i]=g_na
		        }
		    }
		    if(file2==1){
                
                if (isnum($i)>0){
                    b[kb,i]=$i 
                    sum_b=sum_b+$i
                    max_b=(max_b<$i?$i:max_b)
                    count_b=count_b+1
                }else{
                    b[kb,i]=g_na
                }
		    }
	    }
}
END{
    if (ka!=kb){
        print "line count of file1 is different of line count of file2"
        print ka,kb
        exit -1
    }
    if (count_a!=count_b){
        print "Records count of file1 is different of records count of file2"
        print count_a,count_b
        exit -1
    }
    
    mu_a=sum_a/count_a
    mu_b=sum_b/count_b
    mu_ab=(mu_a+mu_b)/2.
    
    for(j=1;j<=ka;++j){
        for(i=1;i<=NF;++i){
            if (isnum(a[j,i])>0 && isnum(b[j,i])>0){
                sumdev_a=sumdev_a+(a[j,i]-mu_a)**2
                sumdev_b=sumdev_b+(b[j,i]-mu_b)**2
            }
        }
    }
    var_a=sqrt(sumdev_a/count_a)
    var_b=sqrt(sumdev_b/count_b)
   
    for(j=1;j<=ka;++j){
        for(i=1;i<=NF;++i){
            if (isnum(a[j,i])>0 && isnum(b[j,i])>0){
                switch (g_matrixcompmode){
                    case "frac":
                        $i=((a[j,i])/(b[j,i]))
                    break
                    case "centeredrelativfrac":
                        $i=((a[j,i]-mu_a)/(max_a-mu_a))/((b[j,i]-mu_b)/(max_b-mu_b))
                    break
                    case "fracunbiasedrel":
                        $i=((a[j,i])/(b[j,i]))
                    break
                    case "fracunbiasedrelsigma":
                        $i=((a[j,i]-mu_a)/var_a)/((b[j,i]-mu_b)/var_b)
                    break
                    case "diff":
                        $i=((a[j,i])-(b[j,i]))
                    break
                    case "diffunbiased":
                        $i=((a[j,i]-mu_a)-(b[j,i]-mu_b))
                    break
                    case "diffunbiasedrel":
                        $i=((a[j,i]-mu_a)-(b[j,i]-mu_b))/(max_b-mu_b)
                    break
                    case "diffunbiasedrelabs":
                        $i=abs((a[j,i]-mu_a)/var_a-(b[j,i]-mu_b)/var_b)
                    break
                    case "diffsgnunbiased":
                        $i=abs((a[j,i]-mu_a)-(b[j,i]-mu_b))*sgn((a[j,i]-mu_a))/sgn((b[j,i]-mu_b))
                    break
                    case "diffsgnunbiasedrel":
                        $i=((a[j,i]-mu_a)-(b[j,i]-mu_b))/(max_b-mu_b)*sgn((a[j,i]-mu_a))/sgn((b[j,i]-mu_b))
                    break
                    case "diffsgnunbiasedrelmu":
                        $i=abs(((a[j,i]-mu_a)-(b[j,i]-mu_b))/mu_ab)*sgn((a[j,i]-mu_a))/sgn((b[j,i]-mu_b))
                    break
                    case "diffsgnunbiasedmuab":
                        $i=abs(((a[j,i]-mu_ab)-(b[j,i]-mu_ab)))*sgn((a[j,i]-mu_ab))/sgn((b[j,i]-mu_ab))
                    break
                    case "diffsgnunbiasedmuabrelmuab":
                        $i=abs(((a[j,i]-mu_ab)-(b[j,i]-mu_ab))/mu_ab)*sgn((a[j,i]-mu_ab))/sgn((b[j,i]-mu_ab))
                    break
                    case "diffsgnunbiasedrelsigma":
                        $i=abs(((a[j,i]-mu_a)/var_a-(b[j,i]-mu_b)/var_b))*sgn((a[j,i]-mu_a))/sgn((b[j,i]-mu_b))
                    break
                    case "diffabsoluterelative":
                        $i=abs((a[j,i]-b[j,i]))/abs(b[j,i])
                    break
                } 
            }else{
                $i=g_na
            }   
        }
        print
    }
    
}

