# Minikube stack

Build image and push to dockerhub with

`make Docker-push`

Run `Make master-up` to bring up the minikube server

Once an ip address has been allocated, add this to your hosts file

### WIP

---

## Build template files from cli

```
kubectl run express --image={IMAGENAME} --dry-run -o yaml --generator=run-pod/v1 > test.yaml
```

# Kubernetes Tutorial

### Step 1

```bash
brew install minikube
brew link minikube?
minikube start --kubernetes-version=v1.18.3
```

### Outputting source files

```
  kubectl **** --dry-run=client -o yaml
```

Runs the create command in dry run mode so nothing happens, then outputs the resultant file "-o' in yaml format

```
mkdir configs
```

## Namespaces

Used to group configs

```
kubectl create namespace development --dry-run=client -o yaml >> configs/namespace.yaml
```

```
kubectl apply -f configs/namespace.yaml
```

```
kubectl config set-context --current --namespace=development
```

## Deployments

Used to configure application deloyments

```
kubectl create deployment express-app --image=tsakar/express-app:latest --namespace=development --dry-run=client -o yaml > configs/deployment.yaml
```

## Services

```
kubectl create service nodeport express-app --tcp=80:9000 --dry-run=client --namespace=development -o yaml > configs/services.yaml
```

OR

```
kubectl expose deployment express-app --type=NodePort --port=80 --target-port=9000 --namespace=development --dry-run -o yaml > configs/services.yaml
```

```
minikube service express-app --url --namespace=development
```

## ingress

Minicube does not come with ingress enabled

```
minikube addons enable ingress
```

Nginx ingress
[Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)
and example config
