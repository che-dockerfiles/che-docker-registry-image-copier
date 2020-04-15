# Che Docker Registry image copier

It is designed to copy images between public and private docker registry inside k8s cluster. It is configured via environment variables:

* DOCKER_REGISTRY_SERVICE - k8s service name
* DOCKER_REGISTRY_PORT - service port
* DOCKER_IMAGES - list of comma separated images to copy
