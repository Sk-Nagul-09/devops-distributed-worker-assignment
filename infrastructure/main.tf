provider "aws" {
  region = var.aws_region
}  

# -----------------------------
# VPC
# -----------------------------

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "quickstart-vpc"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "quickstart-igw"
  }
}

# -----------------------------
# Public Subnet
# -----------------------------

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# -----------------------------
# Private Subnet
# -----------------------------

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# -----------------------------
# Public Route Table
# -----------------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------------------
# Security Group for Public API VM
# -----------------------------------

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Allow public API and SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Public API Access"
    from_port   = 3111
    to_port     = 3111
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------------
# Security Group for Private Workers
# -----------------------------------

resource "aws_security_group" "private_sg" {
  name        = "private-worker-security-group"
  description = "Allow internal worker communication only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Internal RPC Communication"
    from_port   = 49134
    to_port     = 49134
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "SSH from Public Subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------
# Engine VM
# -----------------------------

resource "aws_instance" "engine_vm" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  tags = {
    Name = "engine-vm"
  }
}

# -----------------------------
# Python Worker VM
# -----------------------------

resource "aws_instance" "python_worker_vm" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  tags = {
    Name = "python-worker-vm"
  }
}

# -----------------------------
# TypeScript Worker VM
# -----------------------------

resource "aws_instance" "typescript_worker_vm" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_private_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  tags = {
    Name = "typescript-worker-vm"
  }
}

# -----------------------------
# API Gateway VM
# -----------------------------

resource "aws_instance" "api_gateway_vm" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  tags = {
    Name = "api-gateway-vm"
  }
}
