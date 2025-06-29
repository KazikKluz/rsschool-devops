### Project Structure:

```bash
├── .github
│   └── workflows
│       └── deploy.yml
├── .gitignore
├── iam.tf
├── instances.tf
├── k3s_agent.sh
├── k3s_server.sh
├── network-acls.tf
├── outputs.tf
├── routing.tf
├── security_groups.tf
├── README.md
├── variables.tf
├── versions.tf
└── vpc.tf
```

### Folders/Files Description:

- **.github/workflows/**:

  A hidden directory is where workflows for GitHub Actions are stored.

- **.gitignore**:
- This file instructs Git which folders or files should be ignored when tracking changes.
- **README.md**:

  Documentation - The file you're reading right now

- **iam.tf**:
  This file creates a GithubAction role and attached to it necessary role policies
- **instances.tf**:

  This file creates instances for a Bastion Host / NAT Instances as well as two virtual machines for the cluster: K3s Server and Agent.

- **k3s_agent.sh**:
  This files contains a Bash script that is attached to Agent instance as user data. It creates an K3s agent node and subscribes it to the K3s server node running on Server instance
- **k3s_server.sh**:

  This file contains a Bash script that is attached to Server instance as user data. It creates an K3s server node, copies its kube configuration and creates a non-root access kubeconfig

- **network-acls.tf**:

  This file creates a Network ACL. its rules and attachments in order to control traffic within the VPC

- **routing.tf**:
  This file defines VPC routing tables, its rules and associations
- **security_groups.tf**:

  This file defines security groups for the provisioned instances. They describe what traffic and ports are allowed for communication to, from and between instances.

- **variables.tf**

  This file contains a number or variables that are used as default values in the described infrastructure.

- **versions.tf**

  This file defines the minimum allowed version of Terraform, the remote backend and provider.

- **vpc.tf**

  This file creates Virtual Private Cloud where all other resources are placed, allong with private and public subnets and Internet Gateway

### Usage

After commiting changes or creating a pull request, the GitHub Actions pipeline will trigger the **check**,**plan** & **apply** terraform statements to verify changes & update your project infrastracture.

In order to use this code you need to:

- Create your own aws s3 bucket that you will use for terraform backend. Modify the _versions.tf_ config with your s3 bucket name.
- Add necessary environment variables to GitHub Secrets. The values are specified in **terraform.tfvars** , a hidden and not commited private configuration file while they are declared in **variables.tf** without a `default` parameter.
- To connect to launched instances, update ~./ssh/config file with Bastion Host Address as well as other private instances within vpc's private subnets, like k3s' Server & Agent Nodes and use the `ProxyJump` parameter in config file (known as `ssh -J`):

```bash
Host Bastion
    HostName 255.255.255.255
    User ec2-user
    IdentityFile ~/.ssh/your_key_rsa
    ForwardAgent yes

Host Server
    HostName 10.0.0.0
    User ec2-user
    IdentityFile ~/.ssh/your_key_rsa
    ProxyJump Bastion

###
Host Agent
    HostName 10.0.0.0
    User ec2-user
    IdentityFile ~/.ssh/aws/your_key_rsa
    ProxyJump Bastion

```

### To access `kubectl` remotely from your local machine, setup a _SOCKS5_ proxy:

- Have `kubectl` installed on your local machine
- Copy kube config from your k3s server instance to your local machine update it with the k3s Server's private ip address and proxy-url parameter, and finally set `KUBECONFIG` environment variable to its path:
  - Download the kube config: `ssh k3s_server "cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/k3s.yaml`
  - Update `~/.kube/k3s.yaml` Description [here](https://kubernetes.io/docs/tasks/extend-kubernetes/socks5-proxy-access-api/).
  - Export `KUBECONFIG` env variable: `export KUBECONFIG=~/.kube/k3s.yaml`
- In another terminal open a tunnel: `ssh -D 1080 -N -q Bastion` that will launch a SOCKS5 Proxy through the Bastion host
- Run `kubectl get nodes` to validate the cluster from your local machine
