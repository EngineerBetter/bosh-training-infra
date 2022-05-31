resource "aws_key_pair" "bosh" {
  key_name   = "bosh-training-key"
  public_key = file("${path.module}/secret/id_ed.pub")
}
