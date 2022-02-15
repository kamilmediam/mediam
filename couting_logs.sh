root@ATMSM:~/couting_logs# cat 1_day_counter.sh
#!bin/bash
a=0
data=$(date +%b_%-2d --date="1 day ago")
data2=$(date +%b_%-2d --date="2 day ago")
data3=$(date +%b_%-2d --date="3 day ago")
data4=$(date +%b_%-2d --date="4 day ago")
data5=$(date +%b_%-2d --date="5 day ago")
data6=$(date +%b_%-2d --date="6 day ago")
data7=$(date +%b_%-2d --date="7 day ago")
data8=$(date +%b_%-2d --date="8 day ago")
data9=$(date +%b_%-2d --date="9 day ago")

while read line
do
array[ $a ]="$line"
(( a++ ))
done < <(ls ~/logs/)
cd $HOME/logs
for (( i=0; i<$a; i++ ))
        do
        echo ${array[$i]}
        cd $HOME/logs/${array[$i]}
        if [[ `cat brak.txt | wc -w` == 0 ]]
                then
                cat "jcm_"$data"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 1 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 2 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" "jcm_"$data3"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 3 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" "jcm_"$data3"+"*".log" "jcm_"$data4"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 4 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" "jcm_"$data3"+"*".log" "jcm_"$data4"+"*".log" "jcm_"$data5"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 5 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" "jcm_"$data3"+"*".log" "jcm_"$data4"+"*".log" "jcm_"$data5"+"*".log" "jcm_"$data6"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 6 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" "jcm_"$data3"+"*".log" "jcm_"$data4"+"*".log" "jcm_"$data5"+"*".log" "jcm_"$data6"+"*".log" "jcm_"$data7"+"*".log" > pom.log
        elif [[ `cat brak.txt | wc -w` == 7 ]]
                then
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" "jcm_"$data3"+"*".log" "jcm_"$data4"+"*".log" "jcm_"$data5"+"*".log" "jcm_"$data6"+"*".log" "jcm_"$data7"+"*".log" "jcm_"$data8"+"*".log" > pom.log
        fi

        if [ -e  "jcm_"$data"+"*".log" ]
                then
        suma_pom=$(jq '.'${array[$i]}'.suma' /root/bitomaty.json)
        suma_pom2=$(jq '.'${array[$i]}'.suma2' /root/bitomaty2.json)
        suma=0
        rmv=0
                while IFS= read -r line; do
        if [[ "$line" == *"Credit 1"* ]]
                        then
            suma=`expr $suma + 10`
            elif [[ "$line" == *"Credit 2"* ]]
            then
            suma=`expr $suma + 20`
            elif [[ "$line" == *"Credit 3"* ]]
            then
            suma=`expr $suma + 50`
            elif [[ "$line" == *"Credit 4"* ]]
            then
            suma=`expr $suma + 100`
            elif [[ "$line" == *"Credit 5"* ]]
            then
            suma=`expr $suma + 200`
            elif [[ "$line" == *"Credit 6"* ]]
            then
            suma=`expr $suma + 500`
            elif [[ "$line" == *"event: Cashbox Replaced"* ]]
            then

            subStr=${line:0:15}
                        if [[ $rmv -eq 1 ]]
                        then
                                echo "nie wyzerowano sumy"
                                echo "Cashbox zostal wyjety ponownie: "$subStr "."
                        else
                                suma_pom=`expr $suma + $suma_pom`
                echo "Cashbox zostal wyjety: "$subStr ". Kwota przed wyjeciem cashboxa: "$suma_pom" PLN"
                suma_pom2=$suma_pom
                suma_pom=0
                suma=0
                rmv=1
                        fi
                fi
        done < pom.log
        rm pom.log
        suma_pom=`expr $suma + $suma_pom`
        tmp=$(mktemp)
        jq '.'${array[$i]}'.suma = '$suma_pom'' $HOME/bitomaty.json > "$tmp" && mv "$tmp" $HOME/bitomaty.json
        tmp2=$(mktemp)
        jq '.'${array[$i]}'.suma2 = '$suma_pom2'' $HOME/bitomaty2.json > "$tmp2" && mv "$tmp2" $HOME/bitomaty2.json
        echo  > brak.txt
        cd $HOME/logs
    else
        rm pom.log
        echo "Brak pliku: " "jcm_"$data"+"${array[$i]}".log"
        echo 1 >> brak.txt
    fi
done
