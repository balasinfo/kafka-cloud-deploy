#cloud-config
locale: en_US.UTF-8
output: { all: "| tee -a /var/log/cloud-init-output.log" }