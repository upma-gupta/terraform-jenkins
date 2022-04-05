output "vpc_id" {
  description = "VPC ID"
  value = try(aws_vpc.ug-vpc.id, "")
}
