# Cria uma VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Default VPC"
  }
}

# Cria uma instância EC2
resource "aws_instance" "web_instance" {
  ami           = var.ami_id  # ID da AMI
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_sg.name]
  monitoring = true
  tags = {
    Name        = "WebInstance"
    Environment = var.environment
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl start docker

    # Clona o repositório que contém o Dockerfile
    git clone https://github.com/diegoirati/development-challenge-eight app

    # Navega até o diretório do aplicativo
    cd app

    # Constrói a imagem a partir do Dockerfile
    sudo docker build -t webapp .

    # Executa o contêiner
    sudo docker run -d -p 80:80 webapp
  EOF
}

# Cria um recurso de alarme do CloudWatch
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "Alarm when CPU exceeds ${var.cpu_threshold}%"
  alarm_actions       = [aws_sns_topic.notification_topic.arn]
  dimensions = {
    InstanceId = aws_instance.web_instance.id
  }
}

# Cria um tópico do SNS para notificações
resource "aws_sns_topic" "notification_topic" {
  name = "cpu-alarm-topic"
}

# Cria uma assinatura do SNS para notificações por e-mail
resource "aws_sns_topic_subscription" "notification_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}

# Cria as regras de segurança do grupo de segurança
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web application"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
