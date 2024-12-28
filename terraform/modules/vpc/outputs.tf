output "aws_vpc_main_id" {
  value = aws_vpc.main.id

}

output "aws_vpc_security_group_id" {
  value = aws_security_group.main_security_group.id

}

output "aws_vpc_private_subnet_security_group_id" {
  value = aws_security_group.private_subnet_security_group.id

}

output "aws_public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "aws_public1_subnet_id" {
  value = aws_subnet.public1_subnet.id
}

output "aws_private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "aws_private1_subnet_id" {
  value = aws_subnet.private1_subnet.id
}