#!/bin/bash

find -name *pv.yml | xargs -L1 kubectl create -f
find -name *pvc.yml | xargs -L1 kubectl create -f
kubectl apply -f concourse/config/config-map.yml
kubectl apply -f concourse/config/secret.yml
find -name *svc.yml | xargs -L1 kubectl create -f
find -name *dpl.yml | xargs -L1 kubectl create -f
