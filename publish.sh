#!/bin/sh
# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

BASE_IMAGE_NAME=${1:-alpine}

COMMIT_HASH=$(git rev-parse --short HEAD)

case $BASE_IMAGE_NAME in
    'alpine' | 'ubi')
        docker push quay.io/eclipse/che-docker-registry-image-copier:${BASE_IMAGE_NAME}-${COMMIT_HASH}
        ;;
    *)
        echo "Invalid base image \"${BASE_IMAGE_NAME}\" specified."
        exit 1
        ;;
esac
