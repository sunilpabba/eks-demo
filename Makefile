.PHONY:

ROOT = $(shell git rev-parse --show-toplevel)

EKSCLUSTER = $(ROOT)/ekscluster/eks
TFVARS = $(ROOT)/terraform.tfvars

export AWS_ACCESS_KEY_ID = $(shell awk '/^aws_access_key/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)
export AWS_SECRET_ACCESS_KEY = $(shell awk '/^aws_secret_key/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)
export AWS_REGION = $(shell awk '/^aws_region/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)
export TFSTATE_BUCKET = $(shell awk '/^tfstate_bucket/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)
export BUCKET_KEYPATH = $(shell awk '/^bucket_keypath/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)
export DOCKER_USER = $(shell awk '/^docker_user/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)
export DOCKER_PASSWORD= $(shell awk '/^docker_password/ {print $$3}' terraform.tfvars | tr -d '"' | tail -n1)


setupremote:
	@cd $(EKSCLUSTER);terraform init -backend=true -backend-config "access_key=$$AWS_ACCESS_KEY_ID" -backend-config "secret_key=$$AWS_SECRET_ACCESS_KEY" -backend-config "region=$$AWS_REGION" -backend-config "bucket=$$TFSTATE_BUCKET" -backend-config "key=$$BUCKET_KEYPATH" -backend-config "encrypt=1"

planekscluster: setupremote
	@cd $(EKSCLUSTER); terraform plan -var-file=$(TFVARS) -input=false -out=ekscluster.tfplan

deployekscluster: setupremote
	@cd $(EKSCLUSTER); terraform apply -input=false ekscluster.tfplan
	@cd $(EKSCLUSTER); terraform output | sed -e '1,2d' > kubeconfig

destroyekscluster: setupremote
	@cd $(EKSCLUSTER); terraform destroy -force -var-file=$(TFVARS)

buildimage:
	@cd $(ROOT)/app; sudo docker build -t tejadocker11/dragonfly .

publishimage:
	@cd $(ROOT)/app;
	sudo docker tag tejadocker11/dragonfly tejadocker11/dragonfly
	sudo docker login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD)
	sudo docker push tejadocker11/dragonfly:latest

deploypod:
	@kubectl --kubeconfig $(EKSCLUSTER)/kubeconfig apply -f $(ROOT)/pods/app-pod.yaml

podhealthcheck:
	@kubectl --kubeconfig $(EKSCLUSTER)/kubeconfig exec $(shell kubectl --kubeconfig $(EKSCLUSTER)/kubeconfig get pods | grep dragonfly* | cut -d' ' -f1) -- curl -s http://$(shell kubectl --kubeconfig $(EKSCLUSTER)/kubeconfig describe pod $(PODNAME) | grep IP: | head -n 1 | tr -s ' ' ',' | cut -d',' -f2):8080
