Awk statistical library  


Petit programme sous GNU/linux. Fonctionne avec awk, programme souvent installé par défault dans les distributions. Sinon il suffit de l'installer via le gestionnaire de paquet (awk ou gawk)

Ce petit programme devrait permettre de calculer des petites statistiques très rapidement à partir de fichier de données texte et formatée en colonne. Il permet aussi de manipuler des matrices Ce programme est écrit en awk et contient un wrapper en bash.

Ce programme se décompose en 2 sous programmes :
statmax pour les statistiques calculé par colonnes sur 1 ou 2 fichier
matmax pour des opérations sur des matrices contenu dans 1 ou 2 fichiers

Les statistiques disponibles sont :

Pour 1 colonne
- nombre de ligne (stats)
- nombre de ligne valide (stats)
- min
- max
- somme
- moyenne
- ecart-type
- mediane
- quantileXX

Pour 2 colonnes
- Nash
- rmse
- mse
- se
- kge

Si l'option --column ou --colsim --colobs ne sont pas définis, ces statistiques sont calculées sur toutes les colonnes d'un fichier à la fois. Le résultats s'affiche sur une ligne avec les statistic calculé pour chaque colonnes. Attention pour les statistique à 2 colonnes (nash, rmse, mse,se) la règle suivante est appliquées : le fichier de n colonnes est découpé en 2 pseudo fichier dont les colonne 1 à n/2 correspondent aux obs et les colonnes n/2+1 à n correspondent aux simulations. Les statistiques sont alors calculé sucessivement entre les colonne 1 et n/2+1, 2 et n/2+2 etc...


La manipulation des matrices
- flip : transpose la matrice
- diffmatrix : differences en 2 matrices dans 2 fichiers
- scalematrix :
- addmatrix :
- troncatematrix
- linearisematrix
- unlinearisematrix
- prodmatrix
- extractmatrix




##INSTALLATION SOUS GNU/LINUX
Pour l'installer sur sa session local, taper
cd statmax/
sh install.sh --local
Ce petit script install le programme pour l'utilisateur. Il modifie le .bashrc mais en fait un copie avant. Il copie le programme dans ~/.statmax/
Si le bashrc n'est pas lu au démarrage de la session, comme c'est le cas sur mistrou21, il faut copier la ligne suivante ailleur : bash_login ou bash_session...
export PATH=$HOME/.statmax/:$PATH

Pour l'installer sur le system
sh install.sh (en root)


##UTILISATION
Normalement il s'utilise de la facon suivante :

statmax --mode={stats,min,max,median,quantile,nash,rmse,mse,se,kge} --file={monfichier} --option1={} --option2={} ...

Lorsque le programme à besoin de 2 colonne on peu l'utiliser avec un pipe si les données sont dans 2 fichiers différents :

paste fichier1 fichier2 | statmax --mode={stats,median,quantile,nash,residuals,kge} --option1={} --option2={} ...



###OPTIONS
Les options disponibles sont :

--mode={stats,mean,median,quantile,invquantile,nash,mse,rmse,se,kge} ou -m={} : mode de calcul

--file={nom du fichier} ou -f={} ou seulement le fichier {} : fichier d'entrée

--column={1} : entier indiquant le numéro de la colonne sur laquelle calculer la statistique

--nan={NA} : chaine de caractère ou entier ou reel pour le NotANumber 

--skip={0} : nombre de ligne à sauter

--qvalue={90} : entier compris en 0 et 100 indiquant la valeur du quantile en pourcentage à rechercher dans la série de données

--colsim={} : entier indiquant le numéro de colonne des données simulées (calcul du Nash, kge et des résidus)

--colobs={} : entier indiquant le numéro de colonne des données observés (calcul du Nash, kge et des résidus)

--fs={ } : chaine de caractère précisant le séparateur de champs

--help : print à l'écran les options disponibles


#{mode} disponible
 "stats : statistiques simples d'une colonne : nbrecords ; nbvalidrecord ; min ; max ; sum ; mean ; variance ; median ; quantile"
 "min : valeur minimum de la column"
 "max : valeur max de la column"
 "sum : sommme d'une colonne"
 "mean : moyenne d'une colonne"
 "deviation : variance d'une colonne"
 "median : medianne d'une colonne"
 "quantile : quantile90 d'une colonne"
 "invquantile : pourcentage inférieur à une valeur dans une colonne"
 "nash : critère de nash entre 2 colones"
 "se : résidus entre 2 colonnes"
 "mse : moyenne des résidus entre 2 colonnes"
 "rmse : racine carré des résidus entre 2 colonnes"
 "kge : kge entre 2 colonnes"


##exemples:

statmax fichier1 -c=2 -m=max
est équivalent à
statmax --file=fichier1 --column=2 --mode=max
et à
statmax -f=fichier1 --column=2 --mode=max
Les raccourcis des commandes sont valable que pour column, mode et fichier.

statmax fichier1
est équivalent à 
statmax fichier1 -m=stats

#eval du résultat pour une utilisation dans le shell des variables
eval $(statmax --label="S1" test.txt)
echo ${S1_min}

#exemple avec matmax : calcul la différence entre 2 matrice et transpose son résultats
matmax -m=diffmat test_nash_sim.txt test_nash_obs.txt --skipline=1 | matmax -m=flip
matmax -m=initmat test_nash_sim.txt --xdim=2 --ydim=30 | matmax -m=scalemat --scalefactor=10 | matmax -m=flip

Exemple de pipe avec gnuplot !
./statmax QOBS.txt | gnuplot -e "set yrange [0:1000]; plot '-' u 5 w histogram" -persist

ps pourrait l'améliorer en écrivatn les fonction du package R https://www.rforge.net/doc/packages/hydroGOF/ggof.html


