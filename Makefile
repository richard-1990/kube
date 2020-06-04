-include .env
export 

IMAGENAME=workshop
DOCKERHUB=richardpricelsm
NAMESPACE=development
VERSION:= $(shell git rev-parse --short HEAD)



#### BUILD AND DEPLOY WITHOUT DOCKERHUB
deploy:  
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .
	kubectl run express-app --image=$(IMAGENAME):latest --image-pull-policy=always

build: 
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .


## Build a deployment template
build-deployment-template:
	npx envsub ./templates/deployment.yaml stdout > manifests/deployment.yaml

## BUILD AND DEPLOY WITH DOCKERHUB

docker-build:
	docker build . -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest

docker-run: 
	docker container run --publish :9000 --detach $(IMAGENAME):latest

docker-push-template:
	docker build -t $(DOCKERHUB)/$(IMAGENAME):$(VERSION) -t $(DOCKERHUB)/$(IMAGENAME):latest .
	docker push $(DOCKERHUB)/$(IMAGENAME):latest 
	docker push $(DOCKERHUB)/$(IMAGENAME):$(VERSION)
	$(MAKE) build-deployment-template


docker-images:
	docker images

docker-containers:
	docker ps -a

master-minikube-up:
	minikube start
	minikube addons enable ingress
	kubectl apply -f manifests/namespace.yaml
	kubectl config set-context --current --namespace=$(NAMESPACE)
	kubectl create secret generic -n $(NAMESPACE) database --from-literal=MYSQL_USER=$(MYSQL_USER) --from-literal=MYSQL_PASSWORD=$(MYSQL_PASSWORD)
	kubectl apply -f manifests/deployment.yaml
	kubectl apply -f manifests/services.yaml
	kubectl apply -f manifests/nginx-ingress.yaml
	kubectl get ingress


## Kubernetes check for latest version (Latest)
rollout:
	kubectl rollout restart deployments/express-app


build-template:
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml > manifests/namespace.yaml
	kubectl create deployment express-app --image=$(DOCKERHUB)/$(IMAGENAME):latest --dry-run=client -o yaml > manifests/deployment.yaml



kubernetes-up:
	kubectl apply -f manifests/namespace.yaml 
	kubectl config set-context --current --namespace=$(NAMESPACE)
	kubectl create secret generic -n $(NAMESPACE) database --from-literal=MYSQL_USER=$(MYSQL_USER) --from-literal=MYSQL_PASSWORD=$(MYSQL_PASSWORD)
	kubectl apply -f manifests/deployment.yaml 
	kubectl apply -f manifests/services.yaml 
	kubectl apply -f manifests/nginx-ingress.yaml 
	kubectl get ingress


generate-secrets:
	kubectl create secret generic -n $(NAMESPACE) database --from-literal=MYSQL_USER=$(MYSQL_USER) --from-literal=MYSQL_PASSWORD=$(MYSQL_PASSWORD)


version:
	@echo $(VERSION)


master-minikube-down:
	minikube delete




# Generators

generate-namespace:
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml > manifests/namespace.yaml

generate-deployment-latest:
	kubectl create deployment $(IMAGENAME) --image=$(DOCKERHUB)/$(IMAGENAME):latest --namespace=$(NAMESPACE) --dry-run=client -o yaml > manifests/deployment.yaml

generate-services: