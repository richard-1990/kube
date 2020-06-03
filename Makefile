-include .env
export 

IMAGENAME=express-app
DOCKERHUB=tsakar
NAMESPACE=development
VERSION:= $(shell git rev-parse --short HEAD)
