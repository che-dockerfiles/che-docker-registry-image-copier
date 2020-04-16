# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributor: Robert Bohne <robert.bohne@redhat.com>
# Based on https://github.com/RedHat-EMEA-SSA-Team/skopeo-ubi/blob/master/Dockerfile

FROM alpine:3.11.5

RUN apk add --update --no-cache skopeo

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
