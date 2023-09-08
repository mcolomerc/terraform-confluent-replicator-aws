data "aws_availability_zones" "available" {}

# AWS VPC
data "aws_vpc" "selected" {
  id = var.aws_instance.vpc_id
}

# AWS Subnets query
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = [true]
  }
  depends_on = [data.aws_vpc.selected]
}

# Create a AWS EC2 for external access
resource "aws_security_group" "host-sg" {
  name        = "${var.prefix}-replicator-sg"
  description = "${var.prefix}-replicator-sg"
  vpc_id      = data.aws_vpc.selected.id
  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

#KEY PAIR 
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf-key-pair" {
  key_name   = "${var.prefix}-replicator-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.rsa.private_key_pem}' > ./${var.prefix}-replicator-key-pair.pem"
  }
}

# AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "local_file" "configs" {
  for_each = var.filemap 
  filename = "./output/${each.key}"
  content  = templatefile("${each.value}", {
      confluent_version             = "7.5.0",
      confluent_major               = "7.5",
      destination_bootstrap_endpoint = var.kafka_destination.bootstrap_endpoint,
      destination_key               = var.kafka_destination.credentials.id,
      destination_secret            = var.kafka_destination.credentials.secret,
      source_bootstrap_endpoint     = var.kafka_source.bootstrap_endpoint,
      source_key                    = var.kafka_source.credentials.id,
      source_secret                 = var.kafka_source.credentials.secret,
      source_topicWhiteList         = var.kafka_source.topicWhiteList,
      license                       = var.license,
      topic_rename                  = "$${topic}.replica",
      service_account_id           = var.kafka_destination.service_account_id,
    })
}

## AWS INSTANCE
resource "aws_instance" "host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.aws_instance.instance_type
  subnet_id                   = data.aws_subnets.selected.ids[0]
  associate_public_ip_address = true # To allow external access
  key_name                    = aws_key_pair.tf-key-pair.key_name

  vpc_security_group_ids = [
    aws_security_group.host-sg.id
  ]
  provisioner "file" {
    source = "output/"
    destination = "/home/ubuntu" 
  }

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${var.prefix}-replicator-key-pair.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x confluent-setup.sh",
      "chmod +x confluent-replicator-config.sh",
      "chmod +x confluent-replicator-run.sh",
      "chmod +x confluent-connect-connectors.sh",
      "chmod +x connect-distributed.properties",
      "chmod +x confluent-connect-run.sh",
      "chmod +x confluent-connect-replicator-deploy.sh",
      "./confluent-setup.sh",
      "./confluent-connect-connectors.sh",
      // "./confluent-connect-run.sh",
      // "./confluent-connect-replicator-deploy.sh",
      // "./confluent-replicator-run.sh",
    ]
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 200
    volume_type           = "gp2"
  }


  tags = {
    Name  = "${var.prefix}-replicator-host"
    Owner = var.owner
  }

  depends_on = [
    aws_security_group.host-sg, 
    local_file.configs]
}

