# Cria o pipeline do CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "my-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name            = "SourceAction"
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeStarSourceConnection"
      version         = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn         = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId      = "diegoirati/development-challenge-eight"
        BranchName            = "main"
        PollForSourceChanges  = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
}

# Cria um bucket do S3 para armazenar os artefatos
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "my-artifact-bucket"
}

# Cria a função IAM para o pipeline do CodePipeline
resource "aws_iam_role" "pipeline_role" {
  name               = "my-pipeline-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Cria a função IAM para o projeto do CodeBuild
resource "aws_iam_role" "build_role" {
  name               = "my-build-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Cria a política IAM para o projeto do CodeBuild
resource "aws_iam_policy" "build_policy" {
  name   = "my-build-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-artifact-bucket/*"
    }
  ]
}
EOF
}

# Anexa a política ao papel do projeto do CodeBuild
resource "aws_iam_role_policy_attachment" "build_policy_attachment" {
  role       = aws_iam_role.build_role.name
  policy_arn = aws_iam_policy.build_policy.arn
}

# Cria o projeto do CodeBuild
resource "aws_codebuild_project" "build_project" {
  name = "my-build-project"

  source {
    type            = "NO_SOURCE"
    buildspec       = "buildspec.yml"
    report_build_status = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
  }

  service_role = aws_iam_role.build_role.arn
}

# Cria o arquivo buildspec.yml para o projeto do CodeBuild
resource "aws_s3_object" "buildspec_object" {
  bucket = aws_s3_bucket.artifact_bucket.bucket
  key    = "buildspec.yml"
  content = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.8
  build:
    commands:
      - echo "Building..."
  post_build:
    commands:
      - echo "Post Build..."
EOF
}

# Gera a saída com o ARN da conexão do GitHub
output "github_connection_arn" {
  value = aws_codestarconnections_connection.github_connection.arn
}

# Cria a conexão do CodeStar com o GitHub
resource "aws_codestarconnections_connection" "github_connection" {
  name              = "my-github-connection"
  host_arn          = "arn:aws:codestar-connections:us-east-2:991123363781:connection/8791e600-0a4a-4e81-9cd6-10e9d6c77f53"
}
