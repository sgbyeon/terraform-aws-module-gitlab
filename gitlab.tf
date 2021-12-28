resource "aws_eip" "this" {
  vpc = true

  tags = merge(var.tags, tomap({Name = format("%s.%s.gitlab.eip", var.prefix, var.vpc_name)}))
}

resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index = 0
  }

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    kms_key_id = var.kms_arn_ebs
    encrypted = true
  }

  ebs_block_device {
    device_name = var.ebs_volume_mount
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    kms_key_id = var.kms_arn_ebs
    encrypted = true
  }

  credit_specification {
    cpu_credits = "standard"
  }

  tags = merge(var.tags, tomap({Name = format("%s.%s.gitlab", var.prefix, var.vpc_name)}))
}

resource "aws_network_interface" "this" {
  description = "NIC eth0 for ${var.vpc_name}-gitlab"
  subnet_id = var.subnet_id
  security_groups = [aws_security_group.this.id]
  tags = merge(var.tags, tomap({Name = format("%s.%s.gitlab.nic", var.prefix, var.vpc_name)}))
}

resource "aws_eip_association" "this" {
  instance_id = aws_instance.this.id
  allocation_id = aws_eip.this.id
}

resource "null_resource" "gitlab-install" {
  provisioner "file" {
    source = "./setup-gitlab.sh"
    destination = "~/setup-gitlab.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 700 ~/setup-gitlab.sh",
      "sudo ~/setup-gitlab.sh"
    ]
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    password = ""
    private_key = file(var.key_path)
    host = aws_eip.this.public_ip
    bastion_host = var.bastion_host
    bastion_host_key = var.bastion_host_key
    bastion_private_key = file(var.bastion_private_key)
    bastion_port = var.bastion_port
    bastion_user = var.bastion_user
  }

  depends_on = [
    aws_eip_association.this,
    aws_s3_bucket.this
  ]
}