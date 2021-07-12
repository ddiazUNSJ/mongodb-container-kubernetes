#!/bin/bash
CLUSTER_NAME=danyCluster
NAMESPACE=mongodb-dany
SERVICE_NAME_DATABASE=mongo-database
SERVICE_NAME_EXPRESS=mongo-express



#set namespace
kubectl config set-context --current --namespace=$NAMESPACE

# Get the needed information to access the database
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_DATABASE --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

kubectl get pods -n $NAMESPACE
echo "Link to the mongo db: http://$workernodeip:$nodeport/"


# Get the needed information to access database ui
nodeport=$(kubectl get svc $SERVICE_NAME_EXPRESS --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"
echo "Link to the mongo db WebUI: http://$workernodeip:$nodeport/"
