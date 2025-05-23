resource "aws_instance" "public-server" {
  
  #ami = var.ami # This is not the right way to call
  # terraform lookup function

  count = length(var.public_cird_block)

  # lookup Function
  # lookup(map, key, default)
  ami = "${lookup(var.amis), var.aws_region}"

  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index + 1)}"
  vpc_security_group_ids = [ "${aws_security_group.allow_all.id}" ]
  associate_public_ip_address = true

  tags = {
    Name = "${var.vpc_name}-Public-Server-${count.index + 1}"
    Owner = local.Owner
    costcenter = local.costcenter
    TeamDL = local.TeamDL
    environment = "${var.environment}"
  }
  user_data = <<-EOF

  EOF
}