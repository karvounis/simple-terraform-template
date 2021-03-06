# Simple Template Terraform

[![terraform](https://img.shields.io/badge/terraform-%23623CE4?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![aws](https://img.shields.io/badge/aws-%23232F3E?style=flat-square&logo=amazon-aws&logoColor=white)](https://docs.aws.amazon.com/index.html)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/karvounis/simple-terraform-template?sort=semver&color=blue&logoColor=white&logo=github&style=flat-square&label=latest)
![GitHub Release Date](https://img.shields.io/github/last-commit/karvounis/simple-terraform-template?logo=github)
![GitHub](https://img.shields.io/github/license/karvounis/simple-terraform-template?style=flat-square&logo=github)

This repo is a simple terraform template to fast track the creation of Terraform repos. It contains various pre-populated config files and a number of `.tf` files that you will definitely use. Especially helpful for creation of Terraform modules.

There are some sample providers, input variables and outputs in order to properly exhibit the documentation generation.

README file is autogenerated using [terraform-docs](https://github.com/terraform-docs/terraform-docs)!

## Support

If you like my work, please consider supporting it!

[![buy-me-coffee](https://img.shields.io/badge/Buy_me_coffee-%23FFDD00?style=flat-square&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/karvounis)
[![liberapay](https://img.shields.io/badge/liberapay-%23F6C915?style=flat-square&logo=liberapay&logoColor=black)](https://liberapay.com/karvounis/donate)
![Support with Bitcoin](https://img.shields.io/badge/BTC-bc1q4pqdchcm7q0p7jcy5aqelrasctlp7ld8wvkxjy-%23F7931A?style=flat-square&logo=bitcoin&logoColor=white)
[![Support with Ethereum](https://img.shields.io/badge/ETH-0x8fa53EBa0d1F724728ABbb6f9e79C13056ADc231-%23666fb1?style=flat-square&logo=ethereum&logoColor=white)](https://en.cryptobadges.io/donate/0x8fa53EBa0d1F724728ABbb6f9e79C13056ADc231)

Cheers!

## Dependencies

| Purpose | Name | Reference |
|---|---|---|
| Documentation | terraform-docs | https://github.com/terraform-docs/terraform-docs |
| Code Formatting | terraform fmt | https://www.terraform.io/docs/commands/fmt.html |
| Validation | terraform validate | https://www.terraform.io/docs/commands/validate.html |
| Linting | tflint | https://github.com/terraform-linters/tflint |
| Security | tfsec | https://github.com/tfsec/tfsec https://www.tfsec.dev/docs/home/ |
| Static code analysis | checkov | https://github.com/bridgecrewio/checkov |

## Makefile

### Targets

In order to speed up your work, there are a number of Makefile targets. You can see the list by executing `make` or `make help`.

```bash
$ make help
help:  Show this help
init:  Initializes the Terraform configuration
fmt:  Formats the Terraform configuration
validate:  Validates the Terraform configuration
docs:  Generates the documentation. Creates a README.md file
lint:  Runs the dockerized version of tflint
security:  Runs the dockerized version of tfsec
checkov:  Runs the dockerized version of checkov
```

Every target runs a dockerized version of the dependency so there is no need to have the dependencies installed on your local machine. You just need `docker`!

### Variables

Below, you can see the variables you can pass to the Makefile and their default values.
```
DOCKER_TF_VERSION      ?= latest
DOCKER_TFLINT_VERSION  ?= latest
DOCKER_TFSEC_VERSION   ?= latest
DOCKER_TFDOCS_VERSION  ?= latest
DOCKER_CHECKOV_VERSION ?= latest
OPTIONS		           ?=		 # The options to be passed to the executed command
```

## Examples
### fmt

```
resource "aws_instance" "foo" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t1.2xlarge" # invalid type!
}
```

```
$ OPTIONS="--diff" make fmt
data/main.tf
--- old/data/main.tf
+++ new/data/main.tf
@@ -1,4 +1,4 @@
 resource "aws_instance" "foo" {
-  ami = "ami-0ff8a91507f77f867"
+  ami           = "ami-0ff8a91507f77f867"
   instance_type = "t1.2xlarge" # invalid type!
 }
```
By passing the `--diff` option to the fmt target, it will also print the fmt difference.

### tflint
You can configure the behavior in the `.tflint.hcl` [configuration file](./.tflint.hcl).

```
resource "aws_instance" "foo" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t1.2xlarge" # invalid type! This is going to make the tflint complain!
}

resource "aws_instance" "web" {
  ami                  = "ami-b73b63a0"
  instance_type        = "t1.micro" # previous instance type!
  iam_instance_profile = "app-service"

  tags {
    Name = "HelloWorld"
  }
}
```

```
$ make lint
2 issue(s) found:

Error: "t1.2xlarge" is an invalid value as instance_type (aws_instance_invalid_type)

  on main.tf line 9:
   9:   instance_type = "t1.2xlarge" # invalid type! This is going to make the tflint complain!

Warning: "t1.micro" is previous generation instance type. (aws_instance_previous_type)

  on main.tf line 14:
  14:   instance_type        = "t1.micro" # previous instance type!

Reference: https://github.com/terraform-linters/tflint/blob/v0.20.2/docs/rules/aws_instance_previous_type.md

make: *** [Makefile:29: lint] Error 3

```

### tfsec
```
resource "aws_security_group_rule" "my-rule" {
  type        = "ingress"
  cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS006
}
```
```
$ make security
1 potential problems detected:

Problem 1

  [AWS018][ERROR] Resource 'aws_security_group_rule.my-rule' should include a description for auditing purposes.
  /data/main.tf:21-24

      18 |     Name = "HelloWorld"
      19 |   }
      20 | }
      21 | resource "aws_security_group_rule" "my-rule" {
      22 |   type        = "ingress"
      23 |   cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS006
      24 | }

  See https://github.com/liamg/tfsec/wiki/AWS018 for more information.

make: *** [Makefile:32: security] Error 1
```

### checkov

Checkov is a static code analysis tool for infrastructure-as-code.

It scans cloud infrastructure provisioned using Terraform, Cloudformation, Kubernetes, Serverless or ARM Templates and detects security and compliance misconfigurations.

```
resource "aws_s3_bucket" "foo-bucket" {
  region        = "us-east-1"
  bucket        = "test"
  force_destroy = true
  acl           = "public-read"
}
```

```
Check: CKV_AWS_20: "S3 Bucket has an ACL defined which allows public READ access."
        FAILED for resource: aws_s3_bucket.foo-bucket
        File: /main.tf:7-12
        Guide: https://docs.bridgecrew.io/docs/s3_1-acl-read-permissions-everyone

                7  | resource "aws_s3_bucket" "foo-bucket" {
                8  |   region        = "us-east-1"
                9  |   bucket        = "test"
                10 |   force_destroy = true
                11 |   acl           = "public-read"
                12 | }
```

### terraform-docs
You can configure the behavior in the `.terraform-docs.yml` [configuration file](./.terraform-docs.yml). Just empty the contents of this file and you are good to go!

## Automation

You can use all the above makefile targets as precommit hooks. The only dependency is the [pre-commit](https://pre-commit.com/) tool. You can also install it so that it runs automatically on every git commit. The configuration file is [here](./.pre-commit-config.yaml).

## Terraform documentation
