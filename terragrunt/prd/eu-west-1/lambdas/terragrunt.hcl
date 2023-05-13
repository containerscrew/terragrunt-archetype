locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).inputs
}

terraform {
  source = "${find_in_parent_folders()}/../../../..//modules/lambdas"
}

include {
  path = "${find_in_parent_folders()}"
}

inputs = merge(
  local.environment_vars,
  {
    tags                    = local.environment_vars.tags,
    lambda_trigger_function = {
      create                         = true # create lambda
      create_function                = true
      name                           = "lambda-terminate-ec2-instances"
      description                    = "Lambda to stop EC2 instances"
      handler                        = "main"
      runtime                        = "go1.x"
      timeout                        = 900
      memory_size                    = "1024"
      ephemeral_storage_size         = "512"
      maximum_retry_attempts         = "1"
      maximum_event_age_in_seconds   = "21600"
      create_package                 = false
      attach_policy                  = true
      event_rule_schedule_expression = "cron(0 18 * * ? *)"
    }
  }
)
