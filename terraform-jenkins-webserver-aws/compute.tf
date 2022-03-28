
# Specifies Which AWS AMI will be used - Amazon Linux 2
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

# Create Jenkins Instance
resource "aws_instance" "jenkins-instance" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.medium"
  key_name        = var.keyname
  # vpc_id          = "${aws_vpc.development-vpc.id}"
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh_jenkins.id]
  subnet_id              = aws_subnet.public-subnet-1.id
  # name            = "${var.name}"
  user_data = file("install_jenkins.sh")

  associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance"
  }
}

# Create Security group for Jenkins Instance
resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = aws_vpc.development-vpc.id

  ingress {             #  SSH Traffic inbound
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {             # Traffic inbound to Jenkins portal
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {              # Traffic outbound
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Terraform will Output jenkins IP Address
output "jenkins_ip_address" {
  value = aws_instance.jenkins-instance.public_ip
}

# Create Apache Tomcat Instance - webserver
resource "aws_instance" "apache-instance" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  key_name        = var.keyname
  # vpc_id          = "${aws_vpc.development-vpc.id}"
  vpc_security_group_ids = [aws_security_group.sg_apache.id]
  subnet_id              = aws_subnet.public-subnet-1.id
  # name            = "${var.name}"
  user_data = file("install_apache.sh")

  associate_public_ip_address = true
  tags = {
    Name = "Apache-Instance"
  }
}

# Create Security group for Apache Tomcat Instance
resource "aws_security_group" "sg_apache" {
  name        = "allow_apache"
  description = "Allow SSH and Apache inbound traffic"
  vpc_id      = aws_vpc.development-vpc.id

  ingress {             #  SSH Traffic inbound
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {             # Traffic inbound to Apache Tomcat portal
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {              # Traffic outbound
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Output Apache IP Address
output "apache_ip_address" {
  value = aws_instance.apache-instance.public_ip
}
