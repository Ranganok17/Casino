output "eks_cluster_name" {
  description = "Casino"
  value       = module.eks_cluster.cluster_name
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.dataProcessor.function_name
}
