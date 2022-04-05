output "vpc_id" {
  description = "VPC ID"
  value = try(aws_vpc.ug-vpc.id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value = try(aws_vpc.vpc.arn)
}
