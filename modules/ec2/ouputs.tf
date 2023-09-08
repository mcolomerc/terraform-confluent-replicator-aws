
output "instance" {
  value = "${aws_instance.host.id}"
}

output "instance_type" {
  value = "${aws_instance.host.instance_type}"
}

output "instance_public_dns" {
  value = "${aws_instance.host.public_dns}"
}