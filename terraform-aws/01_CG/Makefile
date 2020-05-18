# .PHONEY: bastion_server kafka

key:
	@terraform output private_key > /tmp/.`terraform output key_name`.key
	@chmod 600 /tmp/.`terraform output key_name`.key

sshspec:
	@terraform output bastion_ssh_spec

ssh-bastion:
	@ssh -o IdentitiesOnly=yes `make sshspec` -i `terraform output private_key_filename`

# ssh-bastion: key
#     	@ssh -o IdentitiesOnly=yes `make sshspec` -i /tmp/.`terraform output key_name`.key

init:
	@terraform init

workspace:
	@terraform workspace select $(ENV)

remote-state:
	@echo "Builds remote-state in S3 for Terraform in $(ENV)"
	@terraform apply -target module.remote-state -var-file workspace-variables/$(ENV).tfvars

#Can't use variables on backend.tf. So we define a parameterized command
init-remote-stage:
	@echo "initialize terrafrom with remote state in S3 for stage environment"
	@terraform init  -backend-config="encrypt=true" -backend-config="bucket=terraform-state-cg-kafka-front-cluster-stage" -backend-config="dynamodb_table=terraform-state-lock-cg-kafka-front-cluster-stage" -backend-config="region=eu-west-1" -backend-config="key=terraform.tfstate.d/stage/terraform.tfstate"

init-remote-prod:
	@echo "initialize terrafrom with remote state in S3"
	@terraform init -reconfigure -backend-config="encrypt=true" -backend-config="terraform-state-cg-kafka-front-cluster-prod" -backend-config="dynamodb_table=terraform-state-cg-kafka-front-cluster-prod" -backend-config="region=eu-central-1" -backend-config="key=terraform.tfstate.d/prod/terraform.tfstate"

refresh:
	@echo "refresh the state for remote-state in S3 $(ENV)"
	@terraform refresh -var-file workspace-variables/$(ENV).tfvars

pull-state:
	@echo "if for some reason you need the state at your local machine"
	@terraform state pull > terraform.tfstate.d/$(ENV)/terraform.tfstate

plan:
	@echo "Plan ELK stack in $(ENV)"
	@terraform plan -var-file workspace-variables/$(ENV).tfvars

# refresh:
# 	@echo "Refresh ELK stack in $(ENV)"
# 	@terraform refresh -var-file workspace-variables/$(ENV).tfvars

only_kafka:
	@echo "Builds bastion for Kafka in $(ENV)"
	@terraform apply -target module.kafka -var-file workspace-variables/$(ENV).tfvars

all: bastion_server kafka_route53
install: bastion_server kafka_route53

bastion: bastion_server

apply:
	@echo "Install ELK stack in $(ENV)"
	@terraform apply -var-file workspace-variables/$(ENV).tfvars

ssh_key_pair:
	@echo "Builds ssh_key_pair for Kafka in $(ENV)"
	@terraform apply -auto-approve -target module.ssh_key_pair -var-file workspace-variables/$(ENV).tfvars

bastion_server: ssh_key_pair
	@echo "Builds bastion server for Kafka in $(ENV)"
	@terraform apply -auto-approve -target module.bastion_server -var-file workspace-variables/$(ENV).tfvars

kafka_volumes:
	@echo "Builds ebs volumes for Kafka in $(ENV)"
	@terraform apply -auto-approve -target module.kafka_volumes -var-file workspace-variables/$(ENV).tfvars

kafka: kafka_volumes
	@echo "Builds core kafka module for Kafka in $(ENV)"
	@terraform apply -auto-approve -target module.kafka -var-file workspace-variables/$(ENV).tfvars

kafka_route53: kafka_elb_http
	@echo "Builds kafka route53 broker hostname for Kafka in $(ENV)"
	@terraform apply -auto-approve -target module.kafka_route53_cluster_hostname -var-file workspace-variables/$(ENV).tfvars

kafka_elb_http: kafka
	@echo "Builds kafka load balancer for Kafka in $(ENV)"
	@terraform apply -auto-approve -target module.kafka_elb_http -var-file workspace-variables/$(ENV).tfvars


# .PHONEY: bastion_server kafka
destroy: destroy_kafka_elb_http destroy_bastion_server

destroy_ssh_key_pair:
	@echo "Destroy ssh_key_pair for Kafka in $(ENV)"
	@terraform destroy -force -target module.ssh_key_pair -var-file workspace-variables/$(ENV).tfvars

destroy_bastion_server:
	@echo "Destroy bastion server for Kafka in $(ENV)"
	@terraform destroy -force -target module.bastion_server -var-file workspace-variables/$(ENV).tfvars

destroy_kafka_volumes:
	@echo "Destroy volumes for Kafka in $(ENV)"
	@terraform destroy -force -target module.kafka_volumes -var-file workspace-variables/$(ENV).tfvars

destroy_kafka: destroy_kafka_volumes
	@echo "Destroy core kafka module for Kafka in $(ENV)"
	@terraform destroy -force -target module.kafka -var-file workspace-variables/$(ENV).tfvars

destroy_kafka_route53: destroy_kafka
	@echo "Destroy kafka route53 broker hostname for Kafka in $(ENV)"
	@terraform destroy -force -target module.kafka_route53_cluster_hostname -var-file workspace-variables/$(ENV).tfvars

destroy_kafka_elb_http: destroy_kafka_route53
	@echo "Destroy kafka load balancer  for Kafka in $(ENV)"
	@terraform destroy -force -target module.kafka_elb_http -var-file workspace-variables/$(ENV).tfvars


# destroy:
# 	@echo "Destroy Kafka in $(ENV)"
# 	@terraform destroy -auto-approve -var-file workspace-variables/$(ENV).tfvars


