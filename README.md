
#### tips and tricks for Terrafrom
```
unset GITHUB_TOKEN && gh auth login -h github.com -p https -s delete_repo -w
```

Kubernetes Providers
Version control constrain

```
terraform init
```
State of the resources

it's stored in some where.

Backend

Local and Remote

By Default TF stored in locally.

##### Terrafrom Create resources?

Attributes Referrence

GitHub Repository list and delete using git command line tool
```
gh repo view mtc-repo --web
gh repo delete mtc-repo-50121 --yes
```

#### State File

1. `Lineage`
2. `Serial => it will incremented every time you apply`


#### Apply or Refresh Command
```
terraform show
terraform show -json | jq .
```
### Terraform State Commands

`show` show the current state or a saved plan
`state` advanced state
```
terraform show -json | jq .
terraform state list
terraform state show github_repository.mtc_repo
terrafrom state show github_repository.mtc_repo | grep description

```
### The Random Provider

The naming things<br/>
Hasicrop Created multiple random provider<br/>

### Resources

1. `random_id`

#### terrafrom console and Interpolation
```
terraform console -state=path
terraform console -state="../state/terrafrom.tfstate"
```

#### Interpolation Syntax

"mtc-repo-${random_id.random.dec}"

#### terraform state list

github_repository.mtc_repo
github_repository_file.index
github_repository_file.readme
random_id.random

#### terraform state show github_repository.mtc_repo

```
full_name                   = "Najumudeen/mtc-repo-12043"
id                          = "mtc-repo-12043"
name                        = "mtc-repo-12043"
```

Using Random Generated File then

### Count

> [!NOTE]
> Keep the Deployment DRY

[count.index].name


### Splat and Output

`Splat` Expression to display

it's run a for loop all of the resources

`[ for o in var.list : o.id ]`

*

#### Output
```
terraform output
terraform output -json repo-names
```

### Terraform Types
```
1. String
2. number
3. bool
4. list (or tuple)
5. set
6. map
```

##### How Access Elements in the list

```
[1,2,3,4][3]
4
elements([1,2,3,4], 2)
3
toset([1,1,2,3,4])
toset([
  1,
  2,
  3,
  4,
])
```

#### set everything to string
```
Map
{"happy" = true, "sad" = false}
{
  "happy" = true
  "sad" = false
}
```

#### Access Value with the help of key
```
{"happy" = true, "sad" = false}["happy"]
true

{ "repo1" = (github_repository.mtc_repo[0].name), "repo2" = (github_repository.mtc_repo[1].name) }
{
  "repo1" = (known after apply)
  "repo2" = (known after apply)
}

type(github_repository.mtc_repo[*].auto_init)
dynamic
```

### For Expressions

```
[ for i in github_repository.mtc_repo[*] : i ]

[ for i in github_repository.mtc_repo[*] : i.name ] OR github_repository.mtc_repo[*].name will give the same output

[ for i in github_repository.mtc_repo[*] : "${i.name} : ${i.http_clone_url}" ]

[ for i in github_repository.mtc_repo[*] : "${i.name} : ${i.http_clone_url}" ][0]

{ for i in github_repository.mtc_repo[*] : i.name => i.http_clone_url }

{
    "mtc-repo-2345" = "https://name/name/git"
    "mtc-repo-2745" = "https://name/name/git"
}
{ for i in github_repository.mtc_repo[*] : i.name => i.http_clone_url }["mtc-repo-2345"]
```

### Variablepw

If tfvars variable not set then fall back to `variable.tfvars` files default values

### Variable Precedence

Loads variable in the following order

- Environment Variables
- The Terraform.tfvars file, if present
- The Terraform.tfvars.json file, if present
- Any *.auto.tfvars or *.auto.tfvars.json file, processed in lexical order of their filenames
- Any -var and -var-file options on the command line, in the order they are provided

First, Command line var varibale consider the first variable variable

```
terraform plan -var 'varsource=cli'
terraform plan -var 'varsource=cli' -var-file='prod.tfvars'
```

Order is very important while providing command line argument. Example above --var-file is second. So it will consider file variable first.

### Variable Validation

validation{
    condition = "error_message = "
}

Comes under variable block

terraform console -state="../state/terrafrom.tfstate"

```
$ var.repo_count < 5
true
```

variable "env" {

  type = string
  description = "Deployment environment"
  validation {
    condition = var.env == "dev" || var.env == "prod"
    error_message = "Env must be 'dev' or 'prod'"
  }

}

### The Constians Function
```
$ contains(["dev", "prod"],"prod")
true
```
### Conditionals

Syntax:

```
condition ? true_val : false-val

$ var.env == "prod" ? "public" : "private"
"private"

$ var.env == "dev" ? "public" : "private"
"public"
```
You cann't referenc variable with another varible instaed you can use local.

### Terrafrom State rm and refresh-only

How sync terrafrom state file?

terraform console -state="../state/terraform.tfstate"
```
{ for k,v in github_repository.mtc_repo : k => v.name }
{
  "0" = "mtc-repo-50121"
  "1" = "mtc-repo-31808"
}
```

#### Remove context from the state file

```
terraform plan --refresh-only
terraform state rm -dry-run 'github_repository.mtc_repo[0]'
terraform apply -refresh-only -auto-approve
```

### for_each Meta Argument

Count will make too mucjh complication while deleting

We will try to refactor with for_each

```
{ for k, v in ["prod","dev","prod"] : k => "mtc-repo-${v}" }
{
  "0" = "mtc-repo-prod"
  "1" = "mtc-repo-dev"
  "2" = "mtc-repo-prod"
}
```

#### All the key and value unique now
```
{ for k, v in toset(["prod","dev","prod"]) : k => "mtc-repo-${v}" }
{
  "dev" = "mtc-repo-dev"
  "prod" = "mtc-repo-prod"
}
```
```
$ keys({ for k, v in toset(["prod","dev","prod"]) : k => "mtc-repo-${v}" })
[
  "dev",
  "prod",
]
$ values({ for k, v in toset(["prod","dev","prod"]) : k => "mtc-repo-${v}" })
[
  "mtc-repo-dev",
  "mtc-repo-prod",
]
for_each    = toset(["dev", "prod"])
```

### for_each: Terrafrom Apply Yourself

### The Length Function
```
length([])
0
length(["a", "b"])
2
length({"a" = "b"})
1
lenght("hello")
5
```

### Local-exe Provisioner

This Invokes a process on the machine running terraform

Example Usage

resource "aws_instance" "web" {
provisioner "local-exec" {
  command = "echo ${self.private_ip} >> private_ips.txt"
}
}

### depends_on Meta arguments

depends_on = [
  aws_iam_role_policy.example
]

### for_each with Maps

```
repos = {
    infra = {
        lang = "terraform",
        filename = "main.tf"
    },
    backend ={
        lang = "python",
        filename = "main.py"
    }
}

map(map(string))

keys(var.repos)
tolist([
  "backend",
  "infra",
])

$ values(var.repos)[0]["filename"]
"main.py"
$ values(var.repos)[0]["filename"]
"main.py"
$ values(var.repos)[0]["lang"]
"python"
```
> [!TIP]
> Terraform Written in GO

#### Interfaces with the API of the "provider"
```
Create
Read
Update
Delete
```


resource "docker_image" "nodered_image" {      // = docker pull nodered/node-red:latest
    name = nodered/node-red:latest            //
}

### Iac Workfloe

```
1. Terraform Code
2. Git Repositories
3. CICD Tools
```

### Declarative

### Depentent on state

### Procedural