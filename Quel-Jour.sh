#!/bin/bash
clear #Pour y voir plus clair.

echo "Vous voulez savoir le jour d'une date donnée à partir du 1er Janvier 1900, ce petit script est fait pour vous"
echo ""
echo "On va vous demander d'abord le jour, puis le mois et finalement l'année (en chiffre) :"

j=0 #Initialisation d'une Variable.
TESTinit=$(echo "$j == 1544654210" | bc) #Initialisation d'un opération logique qui sert à savoir si la personne va rentrer un jour existant.

until [ $TESTinit -eq 1 ] #Tant que le jour rentré n'existe pas".
do
echo ""
echo -n "Quel Jour ? " #On demande le jour
read j
until [ $j -ge 1 ] && [ $j -le 31 ] #Premier test pour voir si le jour peut exister (s'il est bien entre le 1 et le 31).
do
    echo "Il faut taper le jour en chiffre et sous le format xx!! Et compris en 01 et 31 Pas $j"
    echo -n "Quel Jour ? " #Le jour est à nouveau demandé au cas où.
    read j
done

echo "OK" #Jour semble Bon.

echo -n "Quel Mois ? " #On demande le mois
read m

until [ $m -ge 1 ] && [ $m -le 12 ] #Vérification si le mois est compris entre le 1 et le 12.
do
    echo "Il faut taper le mois en chiffre et sous le format xx!! Et compris en 01 et 12. Et pas $m"
    echo -n "Quel Mois ? " #Le mois est à nouveau demandé au cas où.
    read m
done

echo "OK"

echo -n "Quel année ? " #On demande l'année
read a

until [[ "${a}" =~ ^[-+]?[0-9]+$ ]] && [ $a -ge 1900 ] #Vérification si l'année est un nombre et si l'année est supérieur ou égale à 1900
do
    echo "Il faut taper l'année en chiffre et sous le format xxxx!! et supérieur ou égal çà 1900. Et pas $a"
    echo -n "Quel année ? " #L'année est à nouveau demandée au cas où.
    read a
done

case "$m" in #Test si le mois a différente valeur.
        "2" | "02" ) #Si le mois vaut 2.
        divaa=$(echo "$a/100" | bc -l)
        let "divab = $a/100"
        divab=$(echo "$divab*1.00000000000000000000" | bc)
        TESTa=$(echo "$divaa==$divab" | bc) #Permet de vérifier si l'année est un multiple de 100
    
        divba=$(echo "$a/400" | bc -l)
        let "divbb = $a/400"
        divbb=$(echo "$divbb*1.00000000000000000000" | bc)
        TESTb=$(echo "$divba!=$divbb" | bc) #Permet de vérifier si l'année n'est pas un multiple de 400
        
        divca=$(echo "$a/4" | bc -l)
        let "divcb = $a/4"
        divcb=$(echo "$divcb*1.00000000000000000000" | bc)
        TESTc=$(echo "$divca==$divcb" | bc) #Permet de vérifier si l'année est un multiple de 4
        
        if [ $TESTa -eq 1 ] && [ $TESTb -eq 1 ] #Sert à déterminer si durant l'année rentré il y a eu un 29 février
        then
            vnf="28" 
        elif [ $TESTc -eq 1 ]
        then
            vnf="29"
        else
            vnf="28"
        fi
        
        TESTinit=$(echo "$j <= $vnf" | bc) ;; #On sort de la première boucle si la date existe
        
        "4" | "04" | "6" | "06" | "9" | "09" | "11" )
        TESTinit=$(echo "$j <= 30" | bc) ;; #On sort de la première boucle si la date existe
        "1" | "01" | "3" | "03" | "5" | "05" | "7" | "07" | "8" | "08" | "10" | "12" )
        TESTinit=$(echo "$j <= 31" | bc) ;; #On sort de la première boucle si la date existe
        *)  ;;
esac

if [ $TESTinit -ne 1 ]
then
    echo "...Il faut entrer une date existante" #Message affiché si la date n'existe pas
fi

done

echo "OK"

let "an = $a - 1900" #Première Étape pour calculer le nombre de jour depuis le 1 janvier 1900.

let "bix = $an/4"  #Plein de calcul pour additionner les 29 février des années bissextiles.

bix=${bix#-}

let "bix = $bix+1" 

ane=${an#-}

ann=$(echo "($ane/4)+1" | bc -l)

bixe=$(echo "$bix*1.00000000000000000000" | bc)

for ((i = 1900 ; i <= $a ; i += 4))
do
    let "z=$i"
    divaa=$(echo "$z/100" | bc -l)
    let "divab = $z/100"
    divac=$(echo "$divab*1.00000000000000000000" | bc)
    TESTa=$(echo "$divaa==$divac" | bc)

    
    divba=$(echo "$z/400" | bc -l)
    let "divbb = $z/400"
    divbc=$(echo "$divbb*1.00000000000000000000" | bc)
    TESTb=$(echo "$divba!=$divbc" | bc)
    
    if [ $TESTa -eq 1 ] && [ $TESTb -eq 1 ]
    then
        let "bix = $bix-1"
    fi
done

divaa=$(echo "$a/100" | bc -l)
let "divab = $a/100"
divab=$(echo "$divab*1.00000000000000000000" | bc)
TESTa=$(echo "$divaa!=$divab" | bc)
    
divba=$(echo "$a/400" | bc -l)
let "divbb = $a/400"
divbb=$(echo "$divbb*1.00000000000000000000" | bc)
TESTb=$(echo "$divba==$divbb" | bc)

TEST=$(echo "$ann==$bixe" | bc)

if [ $TESTb -eq 1 ]
then
    let "bix = $bix-1"
elif [ $TESTa -eq 1 ] && [ $TEST -eq 1 ] && [ $m -lt 3 ]
then
    let "bix = $bix-1"
fi

#On a le nombre de 29 février depuis le 1er Janvier 1900 à la date choisie.

case "$m" in #Sert à déterminer le nombre de jour depuis le 1er janvier de l'année choisie au 1er jour du mois choisi et convertie la valeur numérique du mois en chaînes de caractères.
        "1" | "01" ) let "jpm = 0" 
              mois="Janvier"     ;;
        "2" | "02" ) let "jpm = 31"
              mois="Février"     ;;
        "3" | "03" ) let "jpm = 59"
              mois="Mars"        ;;
        "4" | "04" ) let "jpm = 90"
              mois="Avril"       ;;
        "5" | "05" ) let "jpm = 120"
              mois="Mai"         ;;
        "6" | "06" ) let "jpm = 151"
              mois="Juin"        ;;
        "7" | "07" ) let "jpm = 181"
              mois="Juillet"     ;;
        "8" | "08" ) let "jpm = 212"
              mois="Août"        ;;
        "9" | "09" ) let "jpm = 243"
              mois="Septembre"   ;;
        "10") let "jpm = 273"
              mois="Octobre"    ;;
        "11") let "jpm = 304"
              mois="Novembre"   ;;
        "12") let "jpm = 334"
              mois="Décembre"   ;;
        *) echo "pb" ;;
esac

case "$j" in #Change le format du jour
        "1" | "01" ) let "d = 1" ;;
        "2" | "02" ) let "d = 2" ;;
        "3" | "03" ) let "d = 3" ;;
        "4" | "04" ) let "d = 4" ;;
        "5" | "05" ) let "d = 5" ;;
        "6" | "06" ) let "d = 6" ;;
        "7" | "07" ) let "d = 7" ;;
        "8" | "08" ) let "d = 8" ;;
        "9" | "09" ) let "d = 9" ;;
        *) let "d = $j" ;;
esac


let "NbJoursTotals = $an * 365 + $bix + $jpm + $d" #Calcul le Nombre total de jour entre le 1er janvier 1900 à la date choisie.

echo "Nombre de jours entre la date entrée et le 1er Janvier 1900 est de $NbJoursTotals" #Sort la valeur précédemment calculée.  

while [ $NbJoursTotals -gt 7 ] #Sert à déterminer le jour (sous format numérique).
do
let "NbJoursTotals = $NbJoursTotals - 7"
done

case "$NbJoursTotals" in #Convertie le Jour numérique en toute lettre.
        "1" ) d="Lundi" ;;
        "2" ) d="Mardi" ;;
        "3" ) d="Mercredi" ;;
        "4" ) d="Jeudi" ;;
        "5" ) d="Vendredi";;
        "6" ) d="Samedi" ;;
        "7" ) d="Dimanche" ;;
        *) echo "pb" ;;
esac

echo "La date que vous avez entrée est le $d $j $mois $a" #valeur de Sortie
