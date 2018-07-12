#!/bin/bash

FREE=$(df |grep system-root |awk '{print $4}')

#< 10G
if [ $FREE -le 50000000 ]; then
   echo "cleaning"



# Delete all stopped containers (including data-only containers).
docker ps -a -q --no-trunc --filter "status=exited" | xargs --no-run-if-empty docker rm -f -v

# Delete all tagged images more than a month old
# (will fail to remove images still used).
docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' | grep ' months' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi -f || true
docker images --no-trunc --format '{{.ID}} {{.CreatedSince}}' | grep ' weeks' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi -f || true
docker images --no-trunc --format '{{.ID}} {{.Tag}}' | grep 'none' | awk '{ print $1 }' | xargs --no-run-if-empty docker rmi -f || true


# Delete all 'untagged/dangling' (<none>) images
# Those are used for Docker caching mechanism.
docker images -q --no-trunc --filter dangling=true | xargs --no-run-if-empty docker rmi -f

# Delete all dangling volumes.
docker volume ls -qf dangling=true | xargs --no-run-if-empty docker volume rm -f


fi
