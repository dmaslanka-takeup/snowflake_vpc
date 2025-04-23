module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["one", "two"])

  name = "instance-${each.key}"

  instance_type          = "t2.micro"
  key_name               = "dmaslanka"
  monitoring             = true
  vpc_security_group_ids = ["sg-0486193e7a57f1510"]
  subnet_id              = "subnet-04482b545aaaa64fd"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
