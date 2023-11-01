provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "developer1" {
  name = "developer1"
  path="/system/"
}

resource "aws_iam_group" "developer_group" {
  name = "developers"
  path = "/system/"
}

resource "aws_iam_group_membership" "developer_membership" {
  name = "developer_meembership"

  users = [
    aws_iam_user.developer1.name,
  ]

  group = aws_iam_group.developer_group.name
}