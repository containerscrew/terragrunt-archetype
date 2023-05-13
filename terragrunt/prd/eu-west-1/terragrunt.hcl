locals {
  environment_vars    = read_terragrunt_config("${get_parent_terragrunt_dir()}/environment.hcl").inputs
  terraform_commands  = ["apply", "plan", "init", "destroy", "validate", "force-unlock", "taint", "state", "import", "run-all"]
}

remote_state {
  backend = "s3"

  config = {
    bucket                 = "${local.environment_vars.tags.prefix}-terraform-state-test"
    key                    = "terraform/${local.environment_vars.environment}/${path_relative_to_include()}.tfstate"
    encrypt                = true
    region                 = local.environment_vars.region
    dynamodb_table         = "${local.environment_vars.tags.prefix}-${local.environment_vars.tags.project}-terraform-lock"
    skip_bucket_versioning = false
    //s3_bucket_tags         = local.environment_vars.tags
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {

  extra_arguments "conditional_vars" {

    commands = get_terraform_commands_that_need_vars()

    required_var_files = [
      "${get_parent_terragrunt_dir()}/../../../globals/variables.tfvars"
    ]

    optional_var_files = [
      "${get_terragrunt_dir()}/variables.tfvars"
    ]

  }

  # plan should not lock, for local and pipeline, so pipelines do not compete for the lock
  extra_arguments "plan_no_lock" {
    commands  = ["plan"]
    arguments = ["-lock=false"]
  }

  # Hooks
  after_hook "after_hook" {
    commands     = ["apply", "plan"]
    execute      = ["terraform", "fmt","--write=true","-diff"]
    run_on_error = true
  }

}

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#generate
# copy global variable definitions to terragrunt run dir
generate "global_variables" {
  path      = "global_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("../../../globals/variables.tf")
}

generate "provider" {
  path      = "global_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file("../../../globals/provider.tf")
}

generate "versions" {
  path              = "versions.tf"
  if_exists         = "skip" # allow stacks to override
  disable_signature = "true"
  contents          = file("../../../globals/versions.tf")
}

generate "terraform_version" {
  path              = ".terraform-version"
  if_exists         = "skip" # allow stacks to override
  disable_signature = "true"
  contents          = file("../../../.terraform-version")
}
