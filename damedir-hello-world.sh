#!/bin/bash
CLUSTER_NAME=danyCluster
NAMESPACE=default
SERVICE_NAME_HELLO_WORLD=hello-world


# set namespace

kubectl config set-context --current --namespace=$NAMESPACE



# Get the needed information to access the hello-world
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_HELLO_WORLD--output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

