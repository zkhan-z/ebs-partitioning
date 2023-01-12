provider "aws" {
  alias  = "us-east"
  region = "us-east-1"                                                   #specify region
}

resource "aws_ebs_volume" "volume" {
  count = length(var.instance_ids)

  availability_zone = element(var.availability_zones, count.index)
  size              = 20
  type              = "gp2"
  tags              =  { "Key" = "EBS", "Value" = "terraform" }
  provider          = "aws.us-east"
}

resource "aws_volume_attachment" "attachment" {
  count = length(var.instance_ids)

  device_name = "/dev/sdg"                                                #specify device name 
  volume_id   = aws_ebs_volume.volume[count.index].id
  instance_id = var.instance_ids[count.index]
  provider    = "aws.us-east"
}

resource "aws_ebs_volume" "volume2" {
  count = length(var.instance_ids)

  availability_zone = element(var.availability_zones, count.index)
  size              = 15
  type              = "gp2"
  tags              =  { "Key" = "EBS", "Value" = "terraform" }
  provider          = "aws.us-east"
}

resource "aws_volume_attachment" "attachments2" {
  count = length(var.instance_ids)

  device_name = "/dev/sdf"                                                  #specify device name
  volume_id   = aws_ebs_volume.volume2[count.index].id
  instance_id = var.instance_ids[count.index]
  provider    = "aws.us-east"
}

resource "null_resource" "ebs_partitions234sdft" {
  triggers = {
                                                                            # specify a trigger to run the provisioner when the `instance_ids` variable changes
    variable = "instance_ids"
  }

  provisioner "local-exec" { 
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/path/to/file.pem")
      host        = "IP.addr.for.localhost"
    }

    # use the data source to look up the IP addresses
    command = "sudo scp -i /path/to/file.pem create_partition_andlv.sh ubuntu@IP.addr.for.remotehost:/path/to/destination && sudo ssh -i /path/to/file.pem ubuntu@IP.addr.for.remotehost 'sudo bash /home/ubuntu/create_partition_andlv.sh'"
  }

  provisioner "local-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/path/to/file.pem")
      host        = "IP.addr.for.localhost"
    }

    # use the data source to look up the IP addresses
    command = "sudo scp -i /path/to/file.pem create_partition_andlv.sh ubuntu@IP.addr.for.remotehost:/path/to/destination && sudo ssh -i /path/to/file.pem ubuntu@IP.addr.for.remotehost 'sudo bash /home/ubuntu/create_partition_andlv.sh'"
     }
   } 
