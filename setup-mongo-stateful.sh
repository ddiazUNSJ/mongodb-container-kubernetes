#!/bin/bash
CLUSTER_NAME=danyCluster
NAMESPACE=meteordev
SERVICE_NAME_DATABASE=mongo-stateful
#https://developer.ibm.com/technologies/containers/tutorials/cl-deploy-mongodb-replica-set-using-ibm-cloud-container-service/

# You need to connect to the your free Kubernetes Cluster on IBM Cloud first

# Create and set namespace
# kubectl create ns $NAMESPACE
kubectl config set-context --current --namespace=$NAMESPACE

# Crear servicio headless
kubectl apply -f mongo-stateful-service.yaml 

# Crear mongodb server stateful
kubectl apply -f mongo-stateful.yaml


# Get the needed information to access the database
workernodeip=$(ibmcloud ks workers --cluster $CLUSTER_NAME | awk '/Ready/ {print $2;exit;}')
echo "workernodeip:$workernodeip"
nodeport=$(kubectl get svc $SERVICE_NAME_DATABASE --output 'jsonpath={.spec.ports[*].nodePort}')
echo "nodeport:$nodeport"

kubectl get pods -n $NAMESPACE
echo "Link to the mongo db: http://$workernodeip:$nodeport/"




   # $ kubectl exec ‑it mongo-stateful‑0 ‑‑ mongo