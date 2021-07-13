#!/bin/bash
CLUSTER_NAME=danyCluster
NAMESPACE=meteordev
SERVICE_NAME_METEOR=sched


# You need to connect to the your free Kubernetes Cluster on IBM Cloud first

# set namespace
kubectl config set-context --current --namespace=$NAMESPACE

# Setup Docker image for the mongo db
kubectl apply -f meteor-app.yaml

# Get the needed information to access the database
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_METEOR --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

kubectl get pods -n $NAMESPACE
echo "Link to the meteor-app : http://$workernodeip:$nodeport/"

