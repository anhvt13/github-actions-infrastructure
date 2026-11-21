## Project Architecture Overview
### GitHub Actions Authentication using OpenID Connect
***
#### Solution - OpenID Connect (OIDC)

![Github OIDC Architecture Diagram](images/Capstone-Github-OIDC.jpg)

- Decision made: GitHub Actions uses OpenID Connect (OIDC) to authenticate with AWS and assume IAM roles for infrastructure deployment and application deployment workflows
- Alternative considered: Static AWS Access Keys
   - Requires storing long-lived credentials in GitHub secrets
   - Risk on credentials can be leaked or compromised
- Advantages:
   - Eliminates Long-Lived Credentials: Avoids storing permanent AWS access keys in GitHub repository or organization secrets.
   - Least-Privilege Access: Separate IAM roles can be created for infrastructure deployment, application deployment, and other workflows, each with only the required permissions
   - Identity-Based Trust: IAM trust policies can restrict role assumption to specific GitHub repositories, branches, workflows, or GitHub deployment environments
- Disadvantages:
   - Configuration Complexity: Requires configuring the GitHub OIDC identity provider in AWS IAM, role trust policies, and appropriate GitHub workflow permissions.
   - Trust Policy Maintenance: IAM trust policies must correctly define allowed repositories, branches, workflow contexts, or environments
- Trade-offs:
   - Eliminating long-lived AWS credentials from GitHub, reducing credential exposure risk. Following IAM principles on least-privileges and temporary credentials to AWS
   - Introduces additional IAM and workflow configuration complexity

#### IAM Role
- The IAM role infrastructure is provisioned and managed using Terraform, enabling repeatable deployments, consistent infrastructure configuration, and version-controlled infrastructure changes
- Organized into two terraform modules

| Module                 | Resources                                                                            |
|------------------------|--------------------------------------------------------------------------------------|
| infras-role            | Assume IAM role responsible for provisioning whole project foundation infrastructure |
| service-role           | Assume IAM role responsible for ECS service task deployment                          | 