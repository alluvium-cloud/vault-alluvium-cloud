resource "vault_aws_secret_backend_role" "aws-alluvium-master-traditional" {
  backend         = "aws/alluvium-master"
  name            = "traditional"
  credential_type = "iam_user"

  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "vault_aws_secret_backend_role" "aws-alluvium-master-admin" {
  backend         = "aws/alluvium-master"
  name            = "admin"
  credential_type = "iam_user"

  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
