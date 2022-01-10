#!bin/bash
a=0
data=$(date +%b_%-2d --date="1 day ago")
data2=$(date +%b_%-2d --date="2 day ago")

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
        if [ -e  "jcm_"$data"+"*".log" ]
                then
                suma_pom2="$(cat zmp.json)"
                suma_pom="$(cat zm.json)"
                suma=0

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
                        then            suma=`expr $suma + 500`
                        elif [[ "$line" == *"event: Cashbox Replaced"* ]]
                        then
                                        subStr=${line:0:15}
                                        suma_pom=`expr $suma + $suma_pom`
                                        echo "Cashbox zostal wyjety: "$subStr ". Kwota przed wyjeciem cashboxa: "$suma_pom" PLN"
                                        suma_pom2=$suma_pom
                                        suma_pom=0
                                        suma=0
                fi
                done < "jcm_"$data"+"*".log"

                echo "jcm_"$data"+"${array[$i]}".log"
                suma_pom=$suma
                echo $suma_pom  > zm.json
                echo $suma_pom2 > zmp.json
                echo  > brak.txt
                cd $HOME/logs
                else
                echo 1 >> brak.txt
                fi
        else
                suma_pom2="$(cat zmp.json)"
                suma_pom="$(cat zm.json)"
                suma=0
                cat "jcm_"$data"+"*".log" "jcm_"$data2"+"*".log" > pom.log
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
                then    suma=`expr $suma + 500`
                elif [[ "$line" == *"event: Cashbox Replaced"* ]]
                then
                                subStr=${line:0:15}
                                suma_pom=`expr $suma + $suma_pom`
                                echo "Cashbox zostal wyjety: "$subStr ". Kwota przed wyjeciem cashboxa: "$suma_pom" PLN"
                                suma_pom2=suma_pom
                                suma_pom=0
                                suma=0
                fi

                done < pom.log
                rm pom.log
                echo "jcm_"$data"+"${array[$i]}".log"
                echo "jcm_"$data2"+"${array[$i]}".log"
                suma_pom=$suma
                echo $suma_pom  > zm.json
                echo $suma_pom2 > zmp.json
                echo  > brak.txt
                cd $HOME/logs
fi
done
