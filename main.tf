 

data "aws_secretsmanager_secret" "source" {
    arn = var.kafka_source.aws_secret_arn
    provider = aws.eu-central-1
 } 

data "aws_secretsmanager_secret_version" "secret_credentials_source" {
 secret_id = data.aws_secretsmanager_secret.source.id
 provider = aws.eu-central-1
} 

data "aws_secretsmanager_secret" "destination" {
    arn = var.kafka_destination.aws_secret_arn
    provider = aws.eu-central-1
} 

data "aws_secretsmanager_secret_version" "secret_credentials_destination" {
 secret_id = data.aws_secretsmanager_secret.destination.id
 provider = aws.eu-central-1
} 


 
module "ec2" {
    source ="./modules/ec2"
    providers = { 
        aws = aws.eu-central-1 
    }
    aws_instance = var.aws_instance
    prefix = var.prefix
    owner = var.owner

    kafka_destination =  {
        bootstrap_endpoint = var.kafka_destination.bootstrap_endpoint
        service_account_id = var.kafka_destination.service_account_id
        credentials = {
            id = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials_destination.secret_string)["CONFLUENT_API_KEY"],
            secret = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials_destination.secret_string)["CONFLUENT_API_SECRET"], 
        }
    }
    kafka_source =  {
        bootstrap_endpoint = var.kafka_source.bootstrap_endpoint
        topicWhiteList = var.kafka_source.topicWhiteList
        credentials = {
            id = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials_source.secret_string)["CONFLUENT_API_KEY"],
            secret = jsondecode(data.aws_secretsmanager_secret_version.secret_credentials_source.secret_string)["CONFLUENT_API_SECRET"], 
        }
    }
    license = var.license
}   