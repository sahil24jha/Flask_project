variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1" # Mumbai region
}

variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "flask-signup" #Project name
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production" 
}

# ─── VPC ─────────────────────────────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

# ─── ECS ─────────────────────────────────────────────────────────────────────
variable "backend_port" {
  description = "Port the backend Flask app listens on"
  type        = number
  default     = 9000
}

variable "frontend_port" {
  description = "Port the frontend Flask app listens on"
  type        = number
  default     = 8000
}

variable "backend_cpu" {
  description = "CPU units for backend task (1 vCPU = 1024)"
  type        = number
  default     = 256
}

variable "backend_memory" {
  description = "Memory (MB) for backend task"
  type        = number
  default     = 512
}

variable "frontend_cpu" {
  description = "CPU units for frontend task"
  type        = number
  default     = 256
}

variable "frontend_memory" {
  description = "Memory (MB) for frontend task"
  type        = number
  default     = 512
}

variable "backend_desired_count" {
  description = "Desired number of backend ECS tasks"
  type        = number
  default     = 2
}

variable "frontend_desired_count" {
  description = "Desired number of frontend ECS tasks"
  type        = number
  default     = 2
}

# ─── ECR ─────────────────────────────────────────────────────────────────────
variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}
