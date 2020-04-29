#!/bin/bash
# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

echo "[INFO] Docker registry host name: "${DOCKER_REGISTRY}
for image in $(echo $DOCKER_IMAGES | tr ',' '\n')
do
  echo "[INFO] Inspecting: "$image

  TAG=$(echo $image | rev | cut -d ':' -f1 | rev)
  NAME=$(skopeo inspect docker://$image | grep "\"Name\":" | cut -d ':' -f2 | sed 's/"//g' | sed 's/,//g' | sed 's/^ *//;s/ *$//')
  SOURCE=$NAME:$TAG

  NAME_WITHOUT_REPOSITORY=$(echo $NAME | cut -d '/' -f2-)
  DESTINATION=$NAME_WITHOUT_REPOSITORY:$TAG

  echo "[INFO] Copying: "$SOURCE

  n=0
  max=5
  until [ $n -ge $max ]
  do
    skopeo copy --dest-tls-verify=false --format=v2s2 docker://$SOURCE docker://${DOCKER_REGISTRY}/$DESTINATION && break
    n=$[$n+1]
    echo "[ERROR] Failed to copy: "$SOURCE
    echo "[ERROR] Try "$n" of "$max" in 3 seconds"
    sleep 3s
  done

  if [[ $n == $[$max] ]]; then
    echo "[ERROR] Fatal error. Failed to copy: "$SOURCE
    exit 1
  fi

done
echo "[INFO] Finished"
