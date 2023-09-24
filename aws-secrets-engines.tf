
resource "vault_aws_secret_backend_role" "traditional" {
  backend         = "aws/alluvium-cloud"
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

resource "vault_aws_secret_backend_role" "admin" {
  backend         = "aws/alluvium-cloud"
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
