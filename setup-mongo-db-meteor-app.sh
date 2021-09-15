#!/bin/bash
CLUSTER_NAME=danyCluster
NAMESPACE=meteordev
SERVICE_NAME_DATABASE=mongo-database
SERVICE_NAME_EXPRESS=mongo-express
SERVICE_NAME_METEOR=sched

# You need to connect to the your free Kubernetes Cluster on IBM Cloud first

# Create and set namespace
kubectl create ns $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE
kubectl get secret all-icr-io -n default -o yaml | sed 's/namespace: default/namespace: meteordev/g' | kubectl -n meteordev create -f -

kubectl create secret generic meteor-settings --from-file=./settings.json
kubectl create secret generic mongo-url --from-file=./mongo_url.txt

# Setup Docker image for the mongo db
kubectl apply -f mongo-docker.yaml

# Get the needed information to access the database
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_DATABASE --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

kubectl get pods -n $NAMESPACE
echo "Link to the mongo db: http://$workernodeip:$nodeport/"

# Setup Meteor app

kubectl apply -f meteor-app.yaml

# Get the needed information to access meteor app
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_METEOR --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

kubectl get pods -n $NAMESPACE
echo "Link to the meteor-app : http://$workernodeip:$nodeport/"


