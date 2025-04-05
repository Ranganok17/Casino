data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda-exec-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_xray" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_lambda_function" "dataProcessor" {
  function_name    = "data-processor-${var.env}"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  filename         = "${path.module}/lambda_function.zip"   # Use a placeholder zip file
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  tracing_config {
    mode = "Active"
  }

  tags = var.common_tags
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.main_queue.arn
  function_name    = aws_lambda_function.dataProcessor.arn
  batch_size       = 5
  enabled          = true
}


resource "aws_dynamodb_table" "users" {
  name         = "users-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "userId"

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "userId"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = var.common_tags
}

resource "aws_sqs_queue" "dead_letter" {
  name                      = "myapp-dlq-${var.env}"
  message_retention_seconds = 1209600  # 14 days retention
  tags                      = var.common_tags
}

resource "aws_sqs_queue" "main_queue" {
  name                      = "myapp-queue-${var.env}"
  visibility_timeout_seconds = 180
  message_retention_seconds  = 345600
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter.arn,
    maxReceiveCount     = 5
  })
  tags = var.common_tags
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "myapp-cluster-${var.env}"
  cluster_version = "1.27"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  node_groups = {
    default = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3
      instance_type    = "t3.medium"
    }
  }

  tags = var.common_tags
}
