# stop telling me what you're gonna do and just do it! (Unless I say otherwise, haha).
ifndef VERBOSE
.SILENT:
endif

# caveat: env keys without `$` chars presumed. Note: Make interprets '#' as start of comment for itself, so escape as `\#`whenever needed for shell script fragments. 
include .env
export $(shell grep -v '^\#' .env | sed 's/=.*//')

bucketKey=$(TF_VAR_bucket_key)
layerDir=terraform

ifdef layer
bucketKey:= ${bucketKey}-layer${layer}
layerDir := ${layerDir}/layer${layer}
else
$(error "Please identify the target layer with 'layer=n'")
endif

# use the backend config file because variables are not allowed in backend block
tf.init:
ifeq ($(layer), 0)
	terraform -chdir=${layerDir} init
else
	terraform -chdir=${layerDir} init -backend-config="bucket=${TF_VAR_bucket}" \
	-backend-config="key=${bucketKey}" \
	-backend-config="dynamodb_table=${TF_VAR_dynamodb}" \
	-backend-config="region=${TF_VAR_region}"
endif

tf.init.migrate:
ifeq ($(layer), 0)
	terraform -chdir=${layerDir} init
else
	terraform -chdir=${layerDir} init -migrate-state -backend-config="bucket=${TF_VAR_bucket}" \
	-backend-config="key=${bucketKey}" \
	-backend-config="dynamodb_table=${TF_VAR_dynamodb}" \
	-backend-config="region=${TF_VAR_region}" 
endif

tf.format:
	terraform -chdir=${layerDir} fmt
	
tf.validate:
	terraform -chdir=${layerDir} validate

tf.plan:
	terraform -chdir=${layerDir} plan

tf.apply:
	terraform -chdir=${layerDir} apply

tf.destroy:
	terraform -chdir=${layerDir} destroy

diagram:
	python3 ./diagrams/vpc.py
	mv ./aws_region_us-east-1.png ./diagrams/bluesky_vpc.png
