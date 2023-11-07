resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_c.id]
}

resource "aws_db_parameter_group" "db_pg" {
  name = "db-pg"
  family = "postgres14"

  parameter {
    name = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "primary-rds-instance" {
  identifier             = "primary-rds-instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.3"
  username               = "moon"
  password               = "moonstar"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  parameter_group_name   = aws_db_parameter_group.db_pg.name
  #   publicly_accessible     = true
  skip_final_snapshot     = true
  multi_az                = true
  backup_retention_period = 1
}

resource "aws_db_instance" "replica-rds-instance" {
  nchar_character_set_name = "replica-rds-instance"
  identifier               = "replica-rds-instance"
  replicate_source_db      = aws_db_instance.primary-rds-instance.identifier
  instance_class           = "db.t3.micro"
  apply_immediately        = true
  #   publicly_accessible      = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  parameter_group_name   = aws_db_parameter_group.db_pg.name
  multi_az               = true
}