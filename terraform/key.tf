resource "aws_key_pair" "bosh" {
  key_name   = var.key_name
  public_key = file("${path.module}/secret/id_ed.pub")
}
