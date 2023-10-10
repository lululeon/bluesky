
# caveat: env keys without `$` chars presumed.
include .env
export $(shell sed 's/=.*//' .env)

# use the backend config file because variables are not allowed in backend block
tf.init:
	terraform -chdir=terraform init -backend-config="bucket=${TFSTATE_BUCKET}" \
	-backend-config="key=${TFSTATE_BUCKET_KEY}" \
	-backend-config="dynamodb_table=${TFSTATE_DYNAMODB}" \
	-backend-config="region=${TF_VAR_region}" 

tf.validate:
	terraform -chdir=terraform validate
	
tf.plan:
	terraform -chdir=terraform plan

tf.apply:
	terraform -chdir=terraform apply

tf.destroy:
	terraform -chdir=terraform destroy
