#!/bin/bash
ADRES="192.168.1.x"
MAX=1
i=0
while [[ ! $i -eq 10 ]]; do # pętla bedzie działac az do poki 'i' nie bedzie równe 10
 MAX=$(((RANDOM % 10)+$MAX+$i))
 echo $(echo $ADRES |sed "s/x/$MAX/g")
 i=$i+1 #dodajemy co kazde pwotorzenie 1 do 'i'
done