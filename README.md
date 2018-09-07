# monitoring_script

#reads the config of programs and arguments you want to run and compares it with the running ones.

#the config file is defined as "config"

#the convention should be:

root@ubuntu:/home/erik/Desktop# cat config

/bin/bash -lvp 443

nc -lvp 443

/bin/bash/bela -lvp 445

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#do not add "nohup" and the "&" into the config file, the script appends it automagicaly!!!

#do not use the following:

root@ubuntu:/home/erik/Desktop# cat config 

nohup /bin/bash -lvp 443 &


