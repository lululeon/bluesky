
# caveat: env keys without `$` chars presumed. Note: Make interprets '#' as start of comment for itself, so escape as `\#`whenever needed for shell script fragments. 
include .env
export $(shell grep -v '^\#' .env | sed 's/=.*//')

# use the backend config file because variables are not allowed in backend block
tf.init:
	terraform -chdir=terraform init -backend-config="bucket=${TFSTATE_BUCKET}" \
	-backend-config="key=${TFSTATE_BUCKET_KEY}" \
	-backend-config="dynamodb_table=${TFSTATE_DYNAMODB}" \
	-backend-config="region=${TF_VAR_region}" 

tf.init.migrate:
	terraform -chdir=terraform init -migrate-state -backend-config="bucket=${TFSTATE_BUCKET}" \
	-backend-config="key=${TFSTATE_BUCKET_KEY}" \
	-backend-config="dynamodb_table=${TFSTATE_DYNAMODB}" \
	-backend-config="region=${TF_VAR_region}" 

tf.format:
	terraform -chdir=terraform fmt
	
tf.validate:
	terraform -chdir=terraform validate
	
tf.plan:
	terraform -chdir=terraform plan

tf.apply:
	terraform -chdir=terraform apply

tf.destroy:
	terraform -chdir=terraform destroy

diagram:
	python ./diagrams/vpc.py
	mv ./aws_region_us-east-1.png ./diagrams/bluesky_vpc.png
