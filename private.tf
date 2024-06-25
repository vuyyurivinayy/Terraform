resource "aws_instance" "instances" {

tags = {
Name = "Private"
}

ami = "ami-0eaf7c3456e7b5b68"
instance_type = "t2.micro"
count = 1
availability_zone = "us-east-1b"
subnet_id = aws_subnet.private_subnet.id
vpc_security_group_ids = [aws_security_group.sg.id]
}


