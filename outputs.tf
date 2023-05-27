output "web_instance_id" {
  value       = aws_instance.web_instance.id
  description = "ID da instância EC2"
}

output "cpu_alarm_arn" {
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.arn
  description = "ARN do alarme de métrica do CloudWatch"
}

output "notification_topic_arn" {
  value       = aws_sns_topic.notification_topic.arn
  description = "ARN do tópico do SNS para notificações"
}

output "notification_subscription_endpoint" {
  value       = aws_sns_topic_subscription.notification_subscription.endpoint
  description = "Endpoint da assinatura do SNS para notificações"
}

output "source_branch" {
  value       = var.source_branch
  description = "Branch do repositório CodeCommit"
}

output "stack_name" {
  value       = var.stack_name
  description = "Nome da stack do CloudFormation"
}

output "stack_template" {
  value       = var.stack_template
  description = "Nome do arquivo de template do CloudFormation"
}
