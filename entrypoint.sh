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
  if [[ ! $image =~ (docker.io|quay.io).* ]]; then
    echo "[INFO] "$image" prefix not found. Added default: docker.io"
    image=docker.io/$image
  fi
  name=$(echo $image | cut -d '/' -f2-)

  echo "[INFO] Copying: "$image

  n=0
  max=5
  until [ $n -ge $max ]
  do
    skopeo copy --dest-tls-verify=false --format=v2s2 docker://$image docker://${DOCKER_REGISTRY}/$name && break
    n=$[$n+1]
    echo "[ERROR] Failed to copy: "$image
    echo "[ERROR] Try "$n" of "$max" in 3 seconds"
    sleep 3s
  done

  if [[ $n == $[$max] ]]; then
    echo "[ERROR] Fatal error. Failed to copy: "$image
    exit 1
  fi

done
echo "[INFO] Finished"
