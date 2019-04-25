# Kubercourse - Kubernetes Based Concourse CI Deployment
* NOTE: This document is heavily under construction!

## Deploying a Kubernetes Environment With k3s
A lightweight Kubernetes cluster can be set up semi-automatically by executing `curl -sfL https://get.k3s.io | sh -` on the 
server shell.  To verify the installation, execute the command `k3s kubectl get node` - it should display the actual node name.

## Generating Keys
Run the generator inside the concourse/config/keys/ directory to create kryptographic keys for the web and worker instanes.

## Configuring Manifests
Set the local storage /paths/ inside the worker-pv.yml/web-pv.yml files to point to the generated keys. To do so, simply replace 
all the {{stuff}} with *absolute paths to the directories* which contain the keys. Also, configure a local storage /path/ for 
Postgres inside the database-pv.yml to enable persistence. 

## Configuring ConfigMaps and Secrets
Configure config-maps.yml and secrets.yml inside the concourse/config/ directory by replacing all the {{stuff}} with proper values.
Please note, that the secerts.yml expects you to provide the values in base64-encoded format while config-maps.yml expect cleartext.

When you're done, expose the secret and configmap to the cluster by executing `k3s kubectl apply -f <file>` for both files. 

## Opening Firewall
To allow inter-pod communication, following cluster-related firewall rules must be set, if a firewall is in place:
```
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -i cni0 -s 10.42.0.0/16 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -s 10.42.0.0/15 -j ACCEPT
```
and loaded by executing `firewall-cmd --reload`. If no firewall-cmd is installed, set the rules through iptables directly.

## Deploying Concourse CI
Create the pods by executing the following commands (do NOT use asterisk-wildcard, this won't work):
k3s kubectl create -f <pv.yml>    # for each persistent volume file
k3s kubectl create -f <pvc.yml>   # for each persistent volume claim file
k3s kubectl create -f <svc.yml>   # for each service file
k3s kubectl apply -f <secret.yml>
k3s kubectl apply -f <config-map.yml>
k3s kubectl create -f <dpl.yml>   # for each deployment

[WIP]
