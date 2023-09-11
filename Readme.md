# Confluent Replicator running on a EC2 instance

## Replicator

The replicator is installed as a standalone executable on a EC2 instance or deployed as a Connector.

## AWS Secret Manager

AWS Secret Manager is used to store the Confluent Cloud cluster credentials.  

The following credentials are required:

- CONFLUENT_API_KEY
- CONFLUENT_API_SECRET

## Terraform

- Get Confluent Cloud cluster credentials from AWS Secret Manager.
- Builds an EC2 instance.
- Provision the instance with the Confluent Platform and the scripts with the required configuration to run Replicator as an executable or as a Connector.
- Remote exec to run the scripts  

### Subnet requirements

A `map-public-ip-on-launch` Aws subnet is required. 

### Terraform variables

The following variables are required:

- EC2 Instance

```hcl
aws_instance = {
    instance_type = "t2.xlarge"
    volume_size = 200
    vpc_id = "vpc-08a7122ab9509d860"
}
```

- Kafka Source

```hcl
kafka_source = {
    bootstrap_endpoint = "lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:9092" 
    topicWhiteList = "topic1"
    aws_secret_arn = "arn:aws:secretsmanager:eu-central-1:492737776546:secret:confluent/source/cloud-1xSLmu"
}  
```

- Kafka Destination

```hcl
kafka_destination = {
    bootstrap_endpoint = "lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:9092"
    aws_secret_arn = "arn:aws:secretsmanager:eu-central-1:492737776546:secret:confluent/destination/cloud-13SLmu"
  } 
```

- Confluent License  

```hcl
 license = ""
```
 
## ACLs  

- [Destination](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html#acls-to-write-to-the-destination-cluster")
- [Source](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html#acls-to-read-from-the-source-cluster")
- [License](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html#acls-for-license-management")
- [Timestamp interceptor](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html#acls-for-the-timestamp-interceptor")
- [Source Offset Management](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html#acls-for-source-offset-management")



## AWS Credentials

AWS Credentials are required to run the terraform scripts.  The following environment variables are required:

```sh
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```