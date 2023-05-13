data "archive_file" "code_zip" {
  type        = "zip"
  source_file = "../../scripts/lambda_terminate_ec2_instances/bin/main"
  output_path = "main.zip"
}
