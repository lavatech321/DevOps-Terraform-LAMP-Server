provider "aws" {
    access_key = "change-me"
    secret_key = "change-me"
    region = "us-east-2"
}

resource "aws_key_pair" "mykey" {
    key_name = "terraform-ansible-key1"
    #public_key = file("C:/Users/username/.ssh/id_rsa.pub")
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh-allow" {
    name = "allow-ssh-ansible"
    description = "Allow only ssh port"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "http-allow" {
    name = "allow-http-ansible"
    description = "Allow only http port"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "reactjs-allow" {
    name = "allow-reactjs"
    description = "Allow only reactjs port"
    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "spring-allow" {
    name = "allow-spring"
    description = "Allow only spring port"
    ingress {
        from_port = 7081
        to_port = 7081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "mysql-allow" {
    name = "allow-mysql"
    description = "Allow only mysql port"
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "servers" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "m7i-flex.large"
    key_name = aws_key_pair.mykey.key_name
    root_block_device {
	  volume_size           = 40
	  volume_type           = "gp3"
	  delete_on_termination = true
	  encrypted             = true
    }
    vpc_security_group_ids = [aws_security_group.ssh-allow.id,aws_security_group.http-allow.id,aws_security_group.reactjs-allow.id,aws_security_group.spring-allow.id,aws_security_group.mysql-allow.id]

    connection {
                type     = "ssh"
                user     = "ec2-user"
                private_key = file("~/.ssh/id_rsa")
                host = aws_instance.servers.public_ip
        }
        provisioner "file" {
    		source      = "code"
		destination = "/home/ec2-user/code"
  	}
        provisioner "file" {
    		source      = "docker-compose.yaml"
		destination = "/home/ec2-user/docker-compose.yaml"
  	}

	provisioner "remote-exec" {
    		inline = [
			"sudo yum install git -y",
			"sudo yum install docker-io -y",
  			"sudo hostnamectl set-hostname demo.example.com",
			"sudo systemctl start docker",
			"sudo systemctl enable docker",
			"sudo usermod -aG docker $USER",
			"sudo mkdir -p /usr/local/lib/docker/cli-plugins",
			"sudo curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose",
			"sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose",
			"unzip code/frontend.zip",
			# replace IP dynamically
			"sed -i 's/REPLACE_IP/${self.public_ip}/g' /home/ec2-user/docker-compose.yaml",
			"sudo docker compose up -d",
   		 ]
  	}
}

output "public_ip" {
	value = "Public IP address: ec2-user@${aws_instance.servers.public_ip}\n"
}

output "sshkey" {
	value = "SSH Key location: ~/.ssh/id_rsa \n"
}

output "Docker-compose" {
	value = "LAMP server: docker compose ps -a \n"
}

output "MYsql-Live" {
	value = "MySQL Credentails: mysql -uappuser -papppass appdb \n"
}

output "App-Live" {
	value = "Reactjs and Spring boot Live: http://${aws_instance.servers.public_ip}:3000 \n"
}

