inputs = {
    aws_account_id      = "497954682375"
    region              = "eu-west-1"
    environment         = "production"
    environment_prefix  = "prd"
    tags = {
      terraform        = true
      environment      = "production"
      prefix           = "prd"
      project          = "mycompany"
      // add more tags, as you need
    }
}
