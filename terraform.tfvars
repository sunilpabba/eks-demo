keyname        = "dragonfly" 
aws_region     = "us-east-1" ## region to deploy eks cluster
tfstate_bucket = "dragonfly-app-eks"  ### S3 bucket for terraform state files
bucket_keypath = "eks/statefile"  ### S3 bucket key for terraform state files
subnet_ids     = ["subnet-d92a0ef7","subnet-ffb65fb2"]  ##us-east-1 default vpc subnet ids

#######Add value to below variables if running this code from laptop. In jenkins these values are added in credentials##########
#aws_access_key = "XXXXXXX"
#aws_secret_key = "XXXXXXX"
#docker_user     = "XXXXXXX"
#docker_password = "XXXXXXX"
