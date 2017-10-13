provider "vultr" {
  api_key = "${var.api_key}"
}

data "vultr_region" "new_jersey" {
  filter {
    name   = "name"
    values = ["New Jersey"]
  }
}

// Find the ID for CoreOS Container Linux.
data "vultr_os" "ubuntu" {
  filter {
    name   = "name"
    values = ["Ubuntu 16.04 x64"]
  }
}

// Find the ID for a starter plan.
data "vultr_plan" "starter" {
  filter {
    name   = "name"
    values = ["8192 MB RAM,110 GB SSD,10.00 TB BW"]
  }
}

// Create a new SSH key. 
resource "vultr_ssh_key" "bs_server_key" {
  name       = "bs_server_key"
  public_key = "${file(var.ssh_file)}"
}

// Create a new firewall group.
resource "vultr_firewall_group" "example" {
  description = "example group"
}

// Add a firewall rule to the group allowing SSH access.
resource "vultr_firewall_rule" "ssh" {
  firewall_group_id = "${vultr_firewall_group.example.id}"
  cidr_block        = "0.0.0.0/0"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
}

// Add a firewall rule to the group allowing ICMP.
resource "vultr_firewall_rule" "icmp" {
  firewall_group_id = "${vultr_firewall_group.example.id}"
  cidr_block        = "0.0.0.0/0"
  protocol          = "icmp"
}

// Add a firewall rule to the group allowing SSH access.
resource "vultr_firewall_rule" "bs" {
  firewall_group_id = "${vultr_firewall_group.example.id}"
  cidr_block        = "0.0.0.0/0"
  protocol          = "udp"
  from_port         = 27000
  to_port           = 27050
}

resource "vultr_startup_script" "bs_setup_script" {
  name = "bs_setup_script"
  content = "${file("setup_script.sh")}"
}

// Create a Vultr virtual machine.
resource "vultr_instance" "bs-server" {
  name              = "bs-server"
  region_id         = "${data.vultr_region.new_jersey.id}"
  plan_id           = "${data.vultr_plan.starter.id}"
  os_id             = "${data.vultr_os.ubuntu.id}"
  ssh_key_ids       = ["${vultr_ssh_key.bs_server_key.id}"]
  hostname          = "bs-server"
  tag               = "bs-server"
  firewall_group_id = "${vultr_firewall_group.example.id}"
  startup_script_id = "${vultr_startup_script.bs_setup_script.id}"
}

// Output all of the virtual machine's IPv4 addresses to STDOUT when the infrastructure is ready.
output ip_addresses {
  value = "${vultr_instance.bs-server.ipv4_address}"
}