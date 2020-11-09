#!/bin/bash
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


case $1 in
    --local)
    
        #Option --local
        #################################################################""
        #Installation de statmax au niveau d'un utilisateur
        #les script awk sont copier dans ~/./statmax/
        #le bashrc est modifié pour exorter ~/./statmax/ vers le PATH afin de pouvoir utiliser le programme depuis une console
        echo "Install Statmax in ${HOME}/.statmax/"
        mkdir ${HOME}/.statmax/
        mkdir ${HOME}/.statmax/lib/

        #cat $pwd > ~.statmax/statmax_config.txt
        cp ./lib/*.awk ${HOME}/.statmax/lib/.
        cp statmax ${HOME}/.statmax/.
        cp matmax ${HOME}/.statmax/.
        cp loopmax ${HOME}/.statmax/.
        chmod +x ${HOME}/.statmax/statmax
        chmod +x ${HOME}/.statmax/matmax
        chmod +x ${HOME}/.statmax/loopmax

        #fait une copie du bashrc
        if [ ! -e ${HOME}/.bashrc_backup_maxstat ]
        then
            cp ${HOME}/.bashrc ${HOME}/.bashrc_backup_maxstat
        fi

        statmax=$(grep -o -i "statmax" ${HOME}/.bashrc)

        if [ -z "${statmax}" ]
        then
            #Export le path
            echo "#statmax program :" >> ${HOME}/.bashrc
            echo 'export PATH=~/.statmax/:$PATH' >> ${HOME}/.bashrc
        fi 
        
    ;;
    --remove)
    
        ######################################################""
        #Option --remove
        if [ -e  /usr/local/bin/statmax ]
        then
        
            if [ -e  /usr/local/lib/statmax ]
            then
                rm /usr/local/lib/statmax/*.awk
                rm -r /usr/local/lib/statmax
            else
                echo "/usr/local/lib/statmax does not exist !!"
                exit 1
            fi
        
            rm /usr/local/bin/statmax
            rm /usr/local/bin/matmax
            rm /usr/local/bin/loopmax
        
        else
            echo "/usr/local/statmax does not exist !!"
            exit 1
        fi
    
    ;;
    *)
    
        #Pas d'option : installation sur le system (besoin des droits roots)
        ####################################################
        if [ ! -e  /usr/local/bin/statmax ]
        then
            
            if [ ! -e  /usr/local/lib/statmax ]
            then
                mkdir /usr/local/lib/statmax
                cp ./lib/*.awk /usr/local/lib/statmax/.
            else
                echo "/usr/local/lib/statmax already exist !!"
                exit 1
            fi
            
            cp statmax /usr/local/bin/.
            cp matmax /usr/local/bin/.
            cp loopmax /usr/local/bin/.
            
        else
            echo "/usr/local/statmax already exist !!"
            exit 1
        fi
    
    ;;
esac



