# Dragonfly EKS Application!!


#### Following steps to be done if dragonfly app need to be created from scratch from laptop

#### Install Pre-requisites:
```
terraform
docker
kubectl
aws-iam-authenticator
make
```

#### step 1

 Add aws credentials in ~/.aws/credentials. Update terraform.tfvars with required values

#### step 2
 To create EKS Cluster, run below commands
```
 make planekscluster deployekscluster
```

#### step 3
 To create docker dragonfly image
```
 make buildimage publishimage
```

#### step 4
 To create dragonfly pod and do healthcheck
```
 make deploypod podhealthcheck
```
