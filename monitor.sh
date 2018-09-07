#!/bin/bash

while read line
do
    	sor_tomb+=("$line")
done < config


for s in "${sor_tomb[@]}"
do
	program=$(echo "$s" | cut -d " " -f 1 | rev | cut -d "/" -f1 | rev)
	temp_tomb+=("$program")	
done


#program tomb:
program_tomb=($(echo "${temp_tomb[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
echo "===================================================================================="
echo "[+] A config file-ban definialtak osszehasonlitasa a futo programok argumentumaival:"
echo "------------------------------------------------------------------------------------"
printf "\n"
echo -e "[+] A vizsgalando progamok: \e[00;32m${program_tomb[@]}\e[00m"


#PID tomb:
for pr in "${program_tomb[@]}"
do
	pid_temp+=$(pgrep \^"$pr")
done	


#program tomb:
pid_tomb=($(echo "${pid_temp[@]}" | tr '\n' ' '))


echo -e "[+] A programokhoz tartozo PID-ek: \e[00;32m${pid_tomb[@]}\e[00m"
echo "[!] A programokhoz tobb PID is tartozhat, ha tobbfele argumentummal vannak elinditva!"

printf "\n"

for p in "${pid_tomb[@]}"
do
	echo "[+] A $p PID vizsgalata:"
	if [[ ! $p ]]; then
		echo "Nem fut!"
	else
      		arg=`xargs -0 < /proc/"$p"/cmdline`
   	     	echo "[+] Argumentum, amivel fut= $arg"
		conf_arg=`grep "$arg" config`		
		if [ "$arg" != "$conf_arg" ]; then
			echo -e "\e[00;31m[!] Nincs ilyen argumentum a config-ban!\e[00m"
			echo -e "\e[00;31m[!] Kill-elem ezt a folyamatot!\e[00m"
			kill -9 "$p"
			sleep 2
			printf "\n"
		else
			echo -e "\e[00;32m[+] Van ilyen argumentum a config-ban!\e[00m"
			printf "\n"
		fi
	fi	
done
printf "\n"
echo "=================================================================================="
echo "[+] A config file-ban definialtak futasanak ellenorzese, adott esetben elinditasa!"
echo "----------------------------------------------------------------------------------"
printf "\n"
for conf_sor in "${sor_tomb[@]}"
do
	echo -e "[+] Vizsgalt config sor: \e[00;37m$conf_sor\e[00m"
	ps=`ps aux | grep -w "$conf_sor"$ | grep -v "grep" | awk '{print $2}'`	
	if [[ ! "$ps" ]]; then
		echo -e "[!] Nem fut a config sor, inditom a \e[00;32mnohup $conf_sor &\e[00m parancsot!"
		nohup $conf_sor &
		sleep 2
		ps=`ps aux | grep -w "$conf_sor"$ | grep -v "grep"`
		
		if [[ ! $ps ]]; then
			echo -e "\e[00;31m[!] Nem sikerult elinditani a $conf_sor-t!\e[00m"
		else
			echo -e "\e[00;32m[+] A $conf_sor fut a $ps PID-del"
		fi
	else			
		echo -e "\e[00;32m[+] A $conf_sor megfeleloen fut a $ps PID-del!\e[00m"

	fi
	printf "\n"
done
