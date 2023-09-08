
variable "aws_instance" {
  type = object({
    instance_type = string
    volume_size   = number
    vpc_id        = string
  })
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

//Destination bootstrap server 
variable "kafka_source" {
  type = object({
    bootstrap_endpoint = string
    topicWhiteList = string
    credentials = object({
      id     = string
      secret = string
    })
  })

  description = "Source bootstrap server"
  default = {
    bootstrap_endpoint = "ab55e03a4fa7e4012a48adb58d78a0f0-1396030174.eu-central-1.elb.amazonaws.com:9093"
    topicWhiteList = "topic1"
    credentials = {
      id     = "lkjhgffdddgh"
      secret = "lkjhgffdddgh"
    }
  } 
}

//Destination bootstrap server 
variable "kafka_destination" {
  type = object({
    bootstrap_endpoint = string
    service_account_id = string
    credentials = object({
      id     = string
      secret = string
    })
  })

  description = "Destination bootstrap server"
  default = {
    bootstrap_endpoint = "lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:9092"
    service_account_id = "sa-1xSLmu"
    credentials = {
      id     = "lkjhgffdddgh"
      secret = "lkjhgffdddgh"
    }
  } 
}

variable "license" {
    default = ""
    type = string
}

variable "filemap" {
  type = map(string)  
  default = { 
      "confluent-setup.sh" = "./provisioner/confluentplatform/confluent.tftpl" 
      "confluent-replicator-config.sh"  = "./provisioner/executable/config.tftpl"
      "confluent-replicator-run.sh"    = "./provisioner/executable/run.tftpl"
      "confluent-connect-connectors.sh"  = "./provisioner/connect/install.tftpl"
      "connect-distributed.properties"  = "./provisioner/connect/distributed.tftpl"
      "confluent-connect-run.sh"    = "./provisioner/connect/run.tftpl"
      "confluent-connect-replicator-deploy.sh" = "./provisioner/connect/connector-deployment.tftpl" 
  }
}