# Fargate Terraform

Deploy a service on AWS Fargate.

# Prerequisites

1. Ensure Terraform v0.11.13 or later is installed: `terraform -version`.
2. The AWS provider config assumes the use of a Shared Credentials File. By default this file should be located
at `$HOME/.aws/credentials` on the machine that runs `terraform`  commands. Please read 
[Shared Credentials File](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file) if you are 
unfamiliar with the concept.

# Getting Started

1. Open `terraform.tfvars` and set the following variable values:
    - **(REQUIRED)** `profile_name` is the name of the credential profile to use from a AWS Shared Credentials File.
    - _(OPTIONAL)_ `region` should be the name of the AWS region to provision infrastructure in.
2. Initialize Terraform: `terraform init -get -upgrade`. The configured Terraform backend is `local`.
3. Plan the creation of managed resources `terraform plan -out tfplan`.
4. Review the plan!
5. Apply `terraform apply tfplan`

# Poking the Deployed Service

It takes a little bit of time for everything to spin up and for health checks to pass. Grab a cup of your preferred 
caffeinated beverage then run `./whoami.sh`. If everything is running and health checks have passed then it should
respond with: `I'm ip-10-0-11-188.us-east-2.compute.internal running on linux/amd64`

**NOTE**

It takes a few seconds for the ALB to boot up and start routing traffic (because health checks). You may see these two
errors for a few moments:

1. `curl: (7) Failed to connect to [...] Connection refused` ... this means the ALB listener is not up and running yet.
2. `503 Service Temporarily Unavailable` ... this means the backend is not healthy yet.

# Cleanup

1. Plan the destruction of managed resources: `terraform plan -destroy -out tfplan`
2. Review the plan!
3. Apply the destroy plan: `terraform apply tfplan`

# Architectural Considerations and Notes

- The VPC is provisioned with public subnets only which is a cost trade off as I did not want to run NAT gateways for
each private subnet. For a more serious setup and depending on the threat model I would air gap the backend from the
public internet with a private subnet.

- An ECS Task Definition looks roughly analogous to a Kubernetes Pod. In the real world you probably need in some cases
to run more than one container per Task Definition. This setup does not support that capability right now.

# Known Issues

- Ran into [Terraform #12634](https://github.com/hashicorp/terraform/issues/12634) while developing. Workaround lives 
in [mod/app/tf_issue_12634_workaround.tf](./mod/app/tf_issue_12634_workaround.tf).

# License

Apache 2.0. Please read [LICENSE](LICENSE) for details.
