resource "aws_instance" "instance" {

tags = {
Name = "terraform-instance"
}

ami = "ami-0eaf7c3456e7b5b68"
instance_type = "t2.micro"
count = 2
availability_zone = "us-east-1a"
subnet_id = aws_subnet.public_subnet.id
vpc_security_group_ids = [aws_security_group.sg.id]
}


