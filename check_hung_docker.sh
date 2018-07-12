 #!/bin/bash

#h1 = $(docker ps -a --format '{{.ID}} {{.Status}}' |grep Up | grep -m 1 -i hour |awk '{print $3}')

h1=$(docker ps -a --format '{{.ID}} {{.Status}}' |egrep -m 1 "Up [8-9] hour" |awk '{print $1}')

if [[ $h1 ]]; then

   echo `date '+%d-%m-%Y %H:%M:%S'` found hang docker $h1 >> /var/log/docker.log
   docker ps -a --format '{{.ID}} {{.Status}} {{.Names}}' |egrep "Up [8-9] hours" >> /var/log/docker.log
   docker rm -f $h1

fi
