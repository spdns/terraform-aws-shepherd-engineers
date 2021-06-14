/**
 *
 * ## Description
 *
 * Please put a description of what this module does here
 *
 * ## Usage
 *
 * Add Usage information here
 *
 * Resources:
 *
 * * [Article Example](https://article.example.com)
 *
 * ```hcl
 * module "example" {
 *   source = "dod-iac/example/aws"
 *
 *   tags = {
 *     Project     = var.project
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 *
 * ## Developer Setup
 *
 * Install dependencies (macOS)
 *
 * ```shell
 * brew install pre-commit terraform terraform-docs
 * pre-commit install --install-hooks
 * ```
 *
 */

data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}