# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributor: Robert Bohne <robert.bohne@redhat.com>
# Based on https://github.com/RedHat-EMEA-SSA-Team/skopeo-ubi/blob/master/Dockerfile

FROM registry.access.redhat.com/ubi8/go-toolset:latest as builder
ENV SKOPEO_VERSION=v0.1.40
RUN git clone -b $SKOPEO_VERSION https://github.com/containers/skopeo.git && \
    cd skopeo/ && \
    make binary-local DISABLE_CGO=1

FROM registry.access.redhat.com/ubi8-minimal:8.1-407
RUN mkdir /etc/containers/

COPY --from=builder /opt/app-root/src/skopeo/default-policy.json /etc/containers/policy.json
COPY --from=builder /opt/app-root/src/skopeo/skopeo /usr/bin/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
