# Kubernetes Tutorial

## Step 1 - Minikube

```bash
brew install minikube
brew link minikube?
minikube start --kubernetes-version=v1.18.3
```

`kubectl config get-contexts`

> You should see new clutter config called minikube with no namespace, if not use `kubectl config set-context minikube` to switch contexts

## Step 2 - Namespaces

```
mkdir configs
```

This is where we keep all of the config files used to create our kubernetes stack

```
kubectl create namespace development --dry-run=client -o yaml > manifests/namespace.yaml
```

> `kubectl **** --dry-run=client -o yaml` is used to make sure we can keep this configuration for future deployment, Infrastructure as code.

```
kubectl apply -f manifests/namespace.yaml
```

```
kubectl config set-context --current --namespace=development
```

> `kubectl config get-contexts` should now change the context to development whenever you switch config

## Step 3 - Deployments

Used to configure application deloyments

```
kubectl create deployment express-app --image=tsakar/express-app:latest --dry-run=client -o yaml > manifests/deployment.yaml
```

> This creates a basic deployment file to get you up and running,

> update with resource allocation \
> update with replicas

```
kubectl apply -f manifests/deployment.yaml
```

`kubectl get deployments`\
`kubectl describe deployment/express-app`\
`kubectl get pods`

## Step 4 - Services

```
kubectl create service nodeport express-app --tcp=80:9000 --dry-run=client -o yaml > manifests/services.yaml
```

OR

```
kubectl expose deployment express-app --type=NodePort --port=80 --target-port=9000 --dry-run=client -o yaml > manifests/services.yaml
```

> Service create is for services independant of a depoyment, expose directly means we want to create a service for this deployment

```
minikube service express-service --url --namespace=development
```

## Step 5 - ingress

Minicube does not come with ingress enabled, we will be using nginx for our ingress needs

```
minikube addons enable ingress
```

Nginx ingress
[Documentation](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)
and example config

## Step 6 - Secrets

> .env is included in the make file so this will be used to pull the username and password,

> The hiphen denotes it is not required (its only used in local environments)

```makefile
kubectl create secret generic -n $(NAMESPACE) database --from-literal=MYSQL_USER=$(MYSQL_USER) --from-literal=MYSQL_PASSWORD=$(MYSQL_PASSWORD) --dry-run=client -o yaml
```

> Do not store this in github as it will contain sensitive data

## Step 7 - Apply secrets to a deployment

> apply the following inside the `containers` path

    env:
      - name: MYSQL_USER
        valueFrom:
          secretKeyRef:
            name: database
            key: MYSQL_USER

## Step 8 - Dynamic deployment image

- Move deployment into a templates folder
- Swap out `constants` for `variables`
