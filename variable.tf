# Declaração das variáveis
variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-2"
}

provider "aws" {
  region = "us-east-2"  # ou a região desejada
}

# Variável para indicar o ambiente (producao ou desenvolvimento)
variable "environment" {
  description = "Ambiente de execução"
  type        = string
  default     = "producao"
}

variable "ami_id" {
  description = "ID da AMI"
  type        = string
  default     = "ami-024e6efaf93d85776"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "cpu_threshold" {
  description = "Limiar de CPU para o alarme do CloudWatch"
  type        = number
  default     = 80
}

variable "sns_email_endpoint" {
  description = "Endpoint de e-mail para as notificações do SNS"
  type        = string
  default     = "diegorosdaibida@gmail.com"
}

# Declaração das variáveis
variable "source_branch" {
  description = "Branch do repositório CodeCommit"
  type        = string
  default     = "main"
}

variable "stack_name" {
  description = "Nome da stack do CloudFormation"
  type        = string
  default     = "test"
}

variable "stack_template" {
  description = "Nome do arquivo de template do CloudFormation"
  type        = string
  default     = "test1"
}

