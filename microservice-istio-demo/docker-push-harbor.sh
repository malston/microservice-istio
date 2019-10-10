#!/bin/bash

set -eo pipefail

if [[ -z "${HARBOR_ADMIN_PASSWORD}" ]]; then
  echo "Enter the password for the harbor administrator account: "
  read -rs HARBOR_ADMIN_PASSWORD
fi

if [[ -z "${HARBOR_HOSTNAME}" ]]; then
  echo "Enter the dns hostname for harbor: (e.g. harbor.example.com)"
  read -rs HARBOR_HOSTNAME
fi

docker login "https://${HARBOR_HOSTNAME}" --username admin --password "${HARBOR_ADMIN_PASSWORD}"

PROJECT_ID=library

docker tag microservice-istio-apache ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-apache
docker push ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-apache
docker tag microservice-istio-postgres ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-postgres
docker push ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-postgres
docker tag microservice-istio-shipping:1 ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-shipping:1
docker push ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-shipping:1
docker tag microservice-istio-invoicing:1 ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-invoicing:1
docker push ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-invoicing:1
docker tag microservice-istio-order:1 ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-order:1
docker push ${HARBOR_HOSTNAME}/${PROJECT_ID}/microservice-istio-order:1
