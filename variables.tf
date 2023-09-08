
//Source bootstrap server 
variable "kafka_source" {
  type = object({
    bootstrap_endpoint = string
    topicWhiteList = string
    aws_secret_arn = string 
  })

  description = "Source bootstrap server"
  default = {
    bootstrap_endpoint = "a0d3cb6de04b64a13872cf3f68db0464-446365202.eu-central-1.elb.amazonaws.com:9093" 
    topicWhiteList = "topic1"
    aws_secret_arn = "arn:aws:secretsmanager:eu-central-1:492737776546:secret:marcelo/confluent/cloud-1xSLmu"
  } 
}

//Destination bootstrap server 
variable "kafka_destination" {
  type = object({
    bootstrap_endpoint = string
    aws_secret_arn = string
     service_account_id = string
  })

  description = "Destination bootstrap server"
  default = {
    bootstrap_endpoint = "lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:9092"
    aws_secret_arn = "arn:aws:secretsmanager:eu-central-1:492737776546:secret:marcelo/confluent/cloud-1xSLmu"
    service_account_id = "sa-1xSLmu"
  } 
}
variable "license" {
    default = ""
    type = string
}


variable "prefix" {
  type        = string
  description = "Prefix to use for all resources"
  default     = "my"
}

variable "owner" {
  type        = string
  description = "Owner Tag"
  default     = "my"
}
 
variable "aws_instance" {
  type = object({
    instance_type = string
    volume_size = number
    vpc_id = string
  })
  description = "AWS Instance"
  default = {
    instance_type = "t2.xlarge"
    volume_size = 200
    vpc_id = "vpc-08a7122ab9509d860"
  }
}