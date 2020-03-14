include .env
IMAGENAME=express-app
DOCKERHUB=tsakar
VERSION:= $(shell git rev-parse --short HEAD)



#### BUILD AND DEPLOY WITHOUT DOCKERHUB
deploy:  
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .
	kubectl run express-application --image=$(IMAGENAME):$(VERSION) --image-pull-policy=Never

build: 
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .


## BUILD AND DEPLOY WITH DOCKERHUB

docker-build:
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .

docker-run: 
	docker container run --publish :9000 --detach $(IMAGENAME):latest

docker-push:
	docker build -t $(DOCKERHUB)/$(IMAGENAME):$(VERSION) -t $(DOCKERHUB)/$(IMAGENAME):latest .
	docker push $(DOCKERHUB)/$(IMAGENAME):latest

docker-images:
	docker images

docker-containers:
	docker ps -a

master-up:
	minikube start
	minikube addons enable ingress
	kubectl apply -f configs/namespace.yaml 
	kubectl config set-context --current --namespace=development
	kubectl create secret generic -n development database --from-literal=username=$(MYSQL_USER) --from-literal=password=$(MYSQL_PASSWORD)
	kubectl apply -f configs/deployment.yaml 
	kubectl apply -f configs/services.yaml 
	kubectl apply -f configs/ingress.yaml 
	kubectl get ingress --watch

master-down:
	minikube delete



version:
	@echo $(VERSION)

