resource "google_compute_instance" "vm1" {
    name          = "k8s-master"
    machine_type  = "n1-standard-2"
    zone          = "${format("%s","${var.var_region_name}-c")}"

    tags          = ["ssh","http"]

    boot_disk {
        initialize_params {
            image = "centos-7-v20180129"
        }
    }

    metadata {
        foo = "bar"
    }

    network_interface {
        subnetwork = "${google_compute_subnetwork.public_subnet.name}"

        access_config {
            // Ephemeral IP
        }
    }

    provisioner "remote-exec" {
        # You cannot open interactive session with "sudo -i". You must also run all yum commands with -y flag
        inline = [
            "sudo yum install ansible -y"
        ]

        connection {
            host        = "${self.network_interface.0.access_config.0.nat_ip}"
            type        = "ssh"
            user        = "${var.ssh_user}"
            private_key = "${file("~/.ssh/id_rsa")}"
        }
    }

    provisioner "local-exec" {
        environment {
            PUBLIC_IP  = "${self.network_interface.0.access_config.0.nat_ip}"
            ANSIBLE_HOST_KEY_CHECKING = false # This is must to avoid the error "The authenticity of host can't be established"
        }

        # You must install "ansible" on the machine where terraform-ansible suites get executed
        # working_dir = "../../ansible/"
        command     = "ansible-playbook -u ${var.ssh_user} --private-key ~/.ssh/id_rsa k8s-master.yaml -i $PUBLIC_IP,"
    }
}

resource "google_compute_instance" "vm2" {
    name          = "k8s-node1"
    machine_type  = "n1-standard-1"
    zone          = "${format("%s","${var.var_region_name}-c")}"

    tags          = ["ssh","http"]

    boot_disk {
        initialize_params {
            image = "centos-7-v20180129"
        }
    }

    metadata {
        foo = "bar"
    }

    network_interface {
        subnetwork = "${google_compute_subnetwork.public_subnet.name}"

        access_config {
            // Ephemeral IP
        }
    }

    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo -i",
    #         "yum install -y https://centos7.iuscommunity.org/ius-release.rpm",
    #         "yum update",
    #         "yum install -y python36u python36u-libs python36u-devel python36u-pip",
    #         "python3.6 -V"
    #     ]

    #     connection {
    #         host        = "${self.network_interface.0.access_config.0.nat_ip}"
    #         type        = "ssh"
    #         user        = "${var.ssh_user}"
    #         private_key = "${file("~/.ssh/id_rsa")}"
    #     }
    # }

    # provisioner "local-exec" {
    #     environment {
    #         PUBLIC_IP  = "${self.network_interface.0.access_config.0.nat_ip}"
    #     }

    #     working_dir = "../../../ansible/"
    #     command     = "ansible-playbook -u root --private-key ${var.ssh_key_private} k8s-node.yaml -i ${self.network_interface.0.access_config.0.nat_ip},"
    # }
}

resource "google_compute_instance" "vm3" {
    name          = "k8s-node2"
    machine_type  = "n1-standard-1"
    zone          = "${format("%s","${var.var_region_name}-c")}"

    tags          = ["ssh","http"]

    boot_disk {
        initialize_params {
            image = "centos-7-v20180129"
        }
    }

    metadata {
        foo = "bar"
    }

    network_interface {
        subnetwork = "${google_compute_subnetwork.public_subnet.name}"

        access_config {
            // Ephemeral IP
        }
    }

    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo -i",
    #         "yum install -y https://centos7.iuscommunity.org/ius-release.rpm",
    #         "yum update",
    #         "yum install -y python36u python36u-libs python36u-devel python36u-pip",
    #         "python3.6 -V"
    #     ]

    #     connection {
    #         host        = "${self.network_interface.0.access_config.0.nat_ip}"
    #         type        = "ssh"
    #         user        = "${var.ssh_user}"
    #         private_key = "${file("~/.ssh/id_rsa")}"
    #     }
    # }

    # provisioner "local-exec" {
    #     environment {
    #         PUBLIC_IP  = "${self.network_interface.0.access_config.0.nat_ip}"
    #     }

    #     working_dir = "../../../ansible/"
    #     command     = "ansible-playbook -u root --private-key ${var.ssh_key_private} k8s-node.yaml -i ${self.network_interface.0.access_config.0.nat_ip},"
    # }
}

resource "google_compute_instance" "vm4" {
    name          = "k8s-node3"
    machine_type  = "n1-standard-1"
    zone          = "${format("%s","${var.var_region_name}-c")}"

    tags          = ["ssh","http"]

    boot_disk {
        initialize_params {
            image = "centos-7-v20180129"
        }
    }

    metadata {
        foo = "bar"
    }

    network_interface {
        subnetwork = "${google_compute_subnetwork.public_subnet.name}"

        access_config {
            // Ephemeral IP
        }
    }

    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo -i",
    #         "yum install -y https://centos7.iuscommunity.org/ius-release.rpm",
    #         "yum update",
    #         "yum install -y python36u python36u-libs python36u-devel python36u-pip",
    #         "python3.6 -V"
    #     ]

    #     connection {
    #         host        = "${self.network_interface.0.access_config.0.nat_ip}"
    #         type        = "ssh"
    #         user        = "${var.ssh_user}"
    #         private_key = "${file("~/.ssh/id_rsa")}"
    #     }
    # }

    # provisioner "local-exec" {
    #     environment {
    #         PUBLIC_IP  = "${self.network_interface.0.access_config.0.nat_ip}"
    #     }

    #     working_dir = "../../../ansible/"
    #     command     = "ansible-playbook -u root --private-key ${var.ssh_key_private} k8s-node.yaml -i ${self.network_interface.0.access_config.0.nat_ip},"
    # }
}