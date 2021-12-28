resource "aws_security_group" "this" {
  name = "${var.prefix}.${var.vpc_name}.gitlab.security-groups"
  description = "${var.prefix}-${var.vpc_name} gitlab security group"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, tomap({Name = format("%s.%s.gitlab.security-groups", var.prefix, var.vpc_name)}))
}

resource "aws_security_group_rule" "this" {
  description = "gitlab for Admin"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = var.gitlab_ingress_sg_rule
  security_group_id = aws_security_group.this.id
}