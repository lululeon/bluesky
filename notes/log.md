# Dev log

I used my identible repo as a baseline to crib from, for a faster start.
Just a qualitive summary of non-code actions I took, in case someone clones the repo and finds themselves having to do similar things :)

- had to upgrade terraform locally
- Create s3 bucket, dynamodb for backing state, expanded iam policy on tf user accordingly
- updated versions for tf, aws provider. Had to change `aws_eip` resource, `vpc = true` -> `domain = "vpc"`
