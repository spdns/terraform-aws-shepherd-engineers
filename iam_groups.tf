resource "aws_iam_group" "shepherd_engineers" {
  name = "shepherd_engineers"
}

// Using a data resource validates that the users exist before applying
data "aws_iam_user" "shepherd_engineers" {
  count     = length(var.shepherd_engineers)
  user_name = var.shepherd_engineers[count.index]
}

resource "aws_iam_group_membership" "shepherd_engineers" {
  count = length(var.shepherd_engineers) > 0 ? 1 : 0

  name  = "shepherd_engineers_group_membership"
  group = aws_iam_group.shepherd_engineers.name
  users = data.aws_iam_user.shepherd_engineers[*].user_name
}