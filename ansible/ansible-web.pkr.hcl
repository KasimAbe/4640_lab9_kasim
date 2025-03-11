packer {
  required_plugins {
    # COMPLETE ME
    # add necessary plugins for ansible and aws
	ansible = {
		version = ">= 1.1.2"
		source = "github.com/hashicorp/ansible"
	}	
	amazon = {
		version = ">= 1.3"
		source = "github.com/hashicorp/amazon"
	}
  }
}

source "amazon-ebs" "ubuntu" {
  # COMPLETE ME
  # add configuration to use Ubuntu 24.04 image as source image
	ami_name = "lab9"
	instance_type = "t2.micro"
	region = "us-west-2"
	source_ami_filter {
		filters = {
			name = "ubuntu/images/*ubuntu-noble-24.04-amd64-server-*"
      			root-device-type    = "ebs"
      			virtualization-type = "hvm"
    		}
   	most_recent = true
    	owners      = ["099720109477"] 

	}
	ssh_username = "ubuntu"
}

build {
  # COMPLETE ME
  # add configuration to: 
  # - use the source image specified above
  # - use the "ansible" provisioner to run the playbook in the ansible directory
  # - use the ssh user-name specified in the "variables.pkr.hcl" file
	name = "packer-ansible-nginx"
	sources = ["source.amazon-ebs.ubuntu"]
	
	provisioner "shell" {
		inline = [
			"echo installing ansible",
			"sudo apt update",
			"sudo apt install software-properties-common",
			"sudo add-apt-repository --yes --update ppa:ansible/ansible",
			"sudo apt install -y ansible",
		]
	}

	provisioner "ansible" {
		playbook_file = "../ansible/playbook.yml"
		extra_arguments = ["-vvv"]
		ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
		user = "ubuntu"
	}
}
