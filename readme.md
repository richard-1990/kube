# Minikube stack

Build image and push to dockerhub with 

`make Docker-push`

Run  `Make master-up` to bring up the minikube server

Once an ip address has been allocated, add this to your hosts file


### WIP
----
## Build template files from cli 
kubectl run express --image={IMAGENAME} --dry-run -o yaml --generator=run-pod/v1 > test.yaml# kubernetes
