<p align="center" >
    <img src="logo.png" alt="logo" width="350"/>
<h3 align="center">Terragrunt archetype</h3>
<p align="center">Terragrunt example repository structure to manage my cloud resources using IaC</p>
</p>

# DISCLAIMER

This may not be the best structure to manage an infrastructure repository in **terraform/terragrunt**, but it is the one that I have found best over the years after working with very different projects (at least at present, you know that in this world things change from one day to another). Each company has its code structured as best as it can according to need. With this architecture I have solved many headaches, and I can work comfortably with the rest of my colleagues in a more agile way (separate tfstate, separate environments, separate regions, non-redundant code...etc). Therefore, the resources or dependencies that you generate on the platform can vary everything and there are global resources that will probably be useful to you as: **VPC, EKS, RDS** or **ROUTE53** among others.

> The repository is built to be used in AWS. It should be adaptable to other types of provider such as GCP or Azure.

# Badges

![Tfsec](https://github.com/containerscrew/terragrunt-archetype/actions/workflows/tfsec.yml/badge.svg)
[![License](https://img.shields.io/github/license/containerscrew/terragrunt-archetype)](/LICENSE)

# Credits

[Terragrunt project](https://terragrunt.gruntwork.io/)  
[Terraform project](https://www.terraform.io/)

# Documentation

Take a look inside [docs](./docs) folder.

# TODO

* pipelines for github and gitlab ci
* tflint (with terragrunt hook or precommit), precommit tfsec, security scans
* terraform plan wrapper `tf plan -no-color | grep -E '^[[:punct:]]|Plan'`

# LICENSE

[LICENSE](./LICENSE)