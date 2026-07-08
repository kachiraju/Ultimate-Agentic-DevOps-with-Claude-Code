# ---------------------------------------------------------------------------
# Remote state backend (S3)
# ---------------------------------------------------------------------------
# The backend is COMMENTED OUT for the first run. Terraform cannot use an S3
# backend bucket that does not exist yet, so bootstrap in three steps:
#
#   1. First run with LOCAL state (backend commented out):
#          terraform init
#          terraform apply
#      This creates the S3 site bucket and CloudFront distribution locally.
#
#   2. Create a SEPARATE bucket to hold Terraform state (do NOT reuse the site
#      bucket). For example:
#          aws s3 mb s3://portfolio-site-tfstate --region ap-south-1
#          aws s3api put-bucket-versioning \
#            --bucket portfolio-site-tfstate \
#            --versioning-configuration Status=Enabled
#
#   3. Uncomment the block below, fill in your state bucket name, then migrate:
#          terraform init -migrate-state
#      Terraform will offer to copy existing local state into S3.
#
# terraform {
#   backend "s3" {
#     bucket       = "portfolio-site-tfstate"
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
