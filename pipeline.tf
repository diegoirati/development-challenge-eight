# Criação da pipeline do CodePipeline
resource "aws_codepipeline" "pipeline" {
  name     = "my-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

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
      provider        = "CodeCommit"
      version         = "1"
      configuration   = {
        RepositoryName = aws_codecommit_repository.repo.repository_name
        BranchName     = var.source_branch
      }
      output_artifacts = ["source_output"]
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
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        StackName    = var.stack_name
        TemplatePath = "build_output::${var.stack_template}"
        ActionMode   = "CREATE_UPDATE"
        Capabilities = "CAPABILITY_NAMED_IAM"
      }
    }
  }
}

# Criação do bucket S3 para armazenar os artefatos do pipeline
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "my-pipeline-artifacts2"

  lifecycle {
    prevent_destroy = true
  }
}

# Criação do papel IAM para a pipeline do CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name               = "my-codepipeline-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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

# Criação do repositório do CodeCommit
resource "aws_codecommit_repository" "repo" {
  repository_name = "my-repo"
}

# Criação do projeto do CodeBuild
resource "aws_codebuild_project" "build_project" {
  name       = "my-build-project"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
  }
}

# Criação do papel IAM para o CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name               = "my-codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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
