![logo medcloud-03 white copy](https://user-images.githubusercontent.com/46347123/158176045-de9fefb0-35e2-4515-83ff-c132608aa870.png)

About Medcloud:

We make exams and medical data management more flexible, secure and effective by accelerating the transition from clinics and hospitals to the cloud.
The RIS and PACS systems have been practically the same for the past 25 years. Interoperability problems, high costs and a lack of understanding about the patient's access to his medical records.

These points defined limits for the doctor-patient relationship and barriers to radiology workflows. We are revolutionizing this through a Care Coordination based solution that improves workflows for providers and integrates doctors and patients for a better experience.

Since our foundation, almost 10 years ago, we have prioritized excellence in the management of health data, structuring workflows of health professionals, clinics, laboratories and hospitals for assertive and quality diagnostics.

We understand that behind each medical record there is a patient seeking to improve his health and the hope of family members for his well being. After all, we are all patients, and Medcloud's mission is to help you live longer and better. #PatientFirst

# Development challenge

Medcloud's challenge for DevOps.

## Goal

- To develop a full pipeline using AWS tools to deploy a simple Web Application of your choice using tools to monitor it.

## Required

The full pipeline is composed with:
- Keep the code in a repository;
- Automate the build process;
- There's no need to enable test step;
- Automate deploy;
- Enable monitoring on the application.
- You MUST use AWS tools;
- You MUST use Terraform for IaC on every infrastructure that you'll create on the cloud provider.

## Extra points

- Keep all the project with different stages (production and development environments);
- Use IAM to maintain your credentials;
- Best practices provided by AWS;
- Generate reports for monitoring;
- Docker on the application;
- Microservices Architecture;
- Best practices for FinOps;
- Use SRE concepts for monitor the application.

## What will be evaluated

- Usability;
- Design;
- Automation;
- Be consistent and know how to argue your choices;
- Present solutions you master.

According to the above criteria, we will evaluate your test in order to proceed to the technical interview.
If you have not acceptably achieved what we are proposing above, we will not proceed with the process.

## Delivery

You MUST fork this repository to your own account and push you code to it. 
When you finish it, you must send a email to cv@medcloud.com.br with your curriculum and your fork.
Any doubts, feel free to send an email to cv@medcloud.com.br.

## For the day of the technical interview and code review

On the date set by the recruiter, have the project running on your local machine.
We will do a review together with you as if you were already on our team, you will be able to explain what you thought, how you architected and how the project can evolve. Good luck!

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cpu_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_codebuild_project.build_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codecommit_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository) | resource |
| [aws_codepipeline.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.web_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_s3_bucket.artifact_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_sns_topic.notification_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.notification_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ID da AMI | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Região da AWS | `string` | `"us-east-2"` | no |
| <a name="input_cpu_threshold"></a> [cpu\_threshold](#input\_cpu\_threshold) | Limiar de CPU para o alarme do CloudWatch | `number` | `80` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Ambiente de execução | `string` | `"producao"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Tipo da instância EC2 | `string` | `"t2.micro"` | no |
| <a name="input_sns_email_endpoint"></a> [sns\_email\_endpoint](#input\_sns\_email\_endpoint) | Endpoint de e-mail para as notificações do SNS | `string` | n/a | yes |
| <a name="input_source_branch"></a> [source\_branch](#input\_source\_branch) | Branch do repositório CodeCommit | `string` | `"main"` | no |
| <a name="input_stack_name"></a> [stack\_name](#input\_stack\_name) | Nome da stack do CloudFormation | `string` | n/a | yes |
| <a name="input_stack_template"></a> [stack\_template](#input\_stack\_template) | Nome do arquivo de template do CloudFormation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cpu_alarm_arn"></a> [cpu\_alarm\_arn](#output\_cpu\_alarm\_arn) | ARN do alarme de métrica do CloudWatch |
| <a name="output_notification_subscription_endpoint"></a> [notification\_subscription\_endpoint](#output\_notification\_subscription\_endpoint) | Endpoint da assinatura do SNS para notificações |
| <a name="output_notification_topic_arn"></a> [notification\_topic\_arn](#output\_notification\_topic\_arn) | ARN do tópico do SNS para notificações |
| <a name="output_source_branch"></a> [source\_branch](#output\_source\_branch) | Branch do repositório CodeCommit |
| <a name="output_stack_name"></a> [stack\_name](#output\_stack\_name) | Nome da stack do CloudFormation |
| <a name="output_stack_template"></a> [stack\_template](#output\_stack\_template) | Nome do arquivo de template do CloudFormation |
| <a name="output_web_instance_id"></a> [web\_instance\_id](#output\_web\_instance\_id) | ID da instância EC2 |
<!-- END_TF_DOCS -->

## Comandos:

terraform-docs markdown table --output-file README.md --output-mode inject ./
infracost breakdown --path ./ ( verificar os custos).
ami-024e6efaf93d85776
terraform apply -var="environment=producao"
