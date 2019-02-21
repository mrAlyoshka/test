#!/bin/bash
#У меня убунта
USER="zefiris"
while read line ; do
   IFS=","
   set -- $line
   LIST=$line
done < ip.txt
KEYFILE="~/.ssh/id_rsa" #путь к ключу
ssh-add $KEYFILE #Добавим агенту ключ
for TESTIP in $LIST 
do
#TESTIP="192.168.1.35"
       HOST=$TESTIP
#Собираем инфомацию на удаленном компьютере. Не знаю входят ли sed и awk в штатные средства ОС, поэтому постарался обойтись без них.
	ssh $USER@$HOST -T <<COMMANDS
	hostname >/tmp/tmp.txt
	echo $TESTIP >>/tmp/tmp.txt
	cat /etc/*-release | grep 'VERSION=' | cut -d '"' -f2 >>/tmp/tmp.txt
	java --version | grep openjdk | cut -d ' ' -f2 >>/tmp/tmp.txt
COMMANDS
ssh $USER@$HOST cat /tmp/tmp.txt | tr '\n' / | rev | cut -c 2- | rev >>rez.txt #Так и не придумал как это сделать без промежуточного файла
ssh $USER@$HOST df -h | grep '/dev/[sd|md]' | tr -s " " " " | cut -d" " -f1,4 # Свободно место на разделах дисков или дисковых массивах
done
ssh-add -d #Удалим у агента ключ


