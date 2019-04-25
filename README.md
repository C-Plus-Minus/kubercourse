# Kubercourse - Concourse CI on Kubernetes
**NOTE**: This document is under construction!

Hi and welcome!

This project helps you to set up Kubernetes on your server and deploy the Concourse CI pipeline with its database, worker and web instances. Simply follow the steps below and you should be good.

The setup is optimized for single-node operation mode - i.e. it will run a resource friendly Kubernetes cluster on your server or working station with no external dependencies to could services or the like.

### Deploying a Kubernetes environment with k3s
A lightweight Kubernetes cluster can be set up semi-automatically by executing `curl -sfL https://get.k3s.io | sh -` on the 
server shell. To verify the installation, execute the command `k3s kubectl get node` - it should display the actual node name.

### Generating cryptographic keys
Run the generator inside the concourse/config/keys/ directory to create cryptographic keys for the web and worker instances.

### Configuring perisistent volumes
Set the local storage /paths/ inside the worker-pv.yml/web-pv.yml files to point to the generated keys. To do so, simply replace 
all the {{stuff}} with **absolute paths to the directories** which contain the keys. Also enter the name of your node. Then, configure a local storage /path/ for Postgres inside the database-pv.yml to enable persistence (it's just an empty directory where you'd like your db to store its stuff).

### Configuring configMaps and secrets
Configure config-maps.yml and secrets.yml inside the concourse/config/ directory by replacing all the {{stuff}} with proper values.
Please note, that the secerts.yml expects you to provide the values base64-encoded while config-map.yml is configured in cleartext.

When you're done, expose your secret and config-map to the cluster by executing `k3s kubectl apply -f <file>` for both files. 

### Opening the firewall
To allow inter-pod communication, following cluster-related firewall rules must be set, if a firewall is in place:
```
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -i cni0 -s 10.42.0.0/16 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -s 10.42.0.0/15 -j ACCEPT
```
and loaded by executing `firewall-cmd --reload`. If no firewall-cmd is installed, the rules must be configured directly using iptables.

### Deploying Concourse CI
Create the pods by executing the following commands (caution: you cannot use the asterisk-wildcard to create multiple files at once):
```
k3s kubectl create -f <pv.yml>    # for each persistent volume file
k3s kubectl create -f <pvc.yml>   # for each persistent volume claim file
k3s kubectl create -f <svc.yml>   # for each service file
k3s kubectl apply -f <secret.yml>
k3s kubectl apply -f <config-map.yml>
k3s kubectl create -f <dpl.yml>   # for each deployment
```

[WIP]
