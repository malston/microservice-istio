#!/bin/sh
sed -i "s,image: ,image: $HARBOR_HOSTNAME/$PROJECT_ID/," microservices.yaml
sed -i "s,image: ,image: $HARBOR_HOSTNAME/$PROJECT_ID/," infrastructure.yaml
sed -i "s,image: ,image: $HARBOR_HOSTNAME/$PROJECT_ID/," failing-order-service.yaml
sed -i "s,imagePullPolicy: Never,imagePullPolicy: IfNotPresent," infrastructure.yaml
sed -i "s,imagePullPolicy: Never,imagePullPolicy: IfNotPresent," microservices.yaml
sed -i "s,imagePullPolicy: Never,imagePullPolicy: IfNotPresent," failing-order-service.yaml
