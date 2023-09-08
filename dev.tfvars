prefix = "mcol"
owner = "mcolomercornejo@confluent.io"

//AWS EC2 instance
aws_instance = {
    instance_type = "t2.xlarge"
    volume_size = 200
    vpc_id = "vpc-08a7122ab9509d860"
}

//Source bootstrap server 
kafka_source = {
    bootstrap_endpoint = "pkc-zpjg0.eu-central-1.aws.confluent.cloud:9092" 
    topicWhiteList = "topic1"
    aws_secret_arn = "arn:aws:secretsmanager:eu-central-1:492737776546:secret:mcolomer/source-lkuikt"
}  

//Destination bootstrap server 
kafka_destination = {
    bootstrap_endpoint = "lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:9092"
    aws_secret_arn = "arn:aws:secretsmanager:eu-central-1:492737776546:secret:marcelo/confluent/cloud-1xSLmu"
    service_account_id = "sa-qzymyp"
  } 
 
 license = ""
 
 