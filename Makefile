IMAGENAME=express-app
VERSION=eval$(git rev-parse HEAD)


docker-build:
	docker build --tag $(IMAGENAME) .

docker-images:
	docker images

docker-containers:
	docker ps -a

docker-run: 
	docker container run --publish :9000 --detach $(IMAGENAME)

deploy:
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):0.0.1 .
	kubectl run express-application --image=$(IMAGENAME):latest --image-pull-policy=Never

build:
	eval $(minikube docker-env)
	docker build -t $(IMAGENAME):latest .

version:
	echo $(VERSION)




