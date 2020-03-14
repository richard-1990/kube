IMAGENAME=express-app
DOCKERHUB=tsakar
VERSION:= $(shell git rev-parse --short HEAD)


docker-build:
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .

docker-push:
	docker build -t $(DOCKERHUB)/$(IMAGENAME):latest .
	docker push $(DOCKERHUB)/$(IMAGENAME):latest

docker-images:
	docker images

docker-containers:
	docker ps -a

docker-run: 
	docker container run --publish :9000 --detach $(IMAGENAME)

deploy:
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .
	kubectl run express-application --image=$(IMAGENAME):$(VERSION) --image-pull-policy=Never

build:
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):$(VERSION) -t $(IMAGENAME):latest .

version:
	echo $(VERSION)




