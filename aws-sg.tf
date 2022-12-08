# # creating a security group
resource "aws_security_group" "sg-for-ec2-instance" {
  name        = "security-group-for-ec2"
  description = "Allow TLS inbound traffic"

  dynamic "ingress" {
    for_each = var.ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}