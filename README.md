# Terraform Cloud/Enterprise workspace setup
**GitHub Action** to set up **Terraform Cloud/Enterprise** workspace

![Setup Workspace](https://github.com/recarnot/terraform-github-workspace-setup-action/workflows/Setup%20Workspace/badge.svg)


## Inputs

| name         | description                    | required |
| ------------ | ------------------------------ | -------- |
| organization | Terraform Organization name    | true     |
| workspace    | Terraform Workspace name       | true     |
| token        | Terraform API token            | true     |
| hostname     | Terraform Hostname             | false    |
| vars         | Workspace variables definition | false    |



## Usage

Simple example : 

```yaml
on: [push]

jobs:
  setup-tf-workspace:
    runs-on: ubuntu-latest
    name: Setup Terraform workspace
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: setup workspace
        id: workspace
        uses: recarnot/terraform-github-workspace-setup-action@master
        with:
          organization: ${{ secrets.TF_ORGANIZATION }}
          workspace: "my-workspace-name"
          token: ${{ secrets.TF_API_TOKEN }}

      - name: Get the output time
        run: echo "The workspace ID is ${{ steps.workspace.outputs.workspace_id }}"
```



Now with variables : 
```yaml
on: [push]

jobs:
  setup-tf-workspace:
    runs-on: ubuntu-latest
    name: Setup Terraform workspace
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: setup workspace
        id: workspace
        uses: recarnot/terraform-github-workspace-setup-action@master
        with:
          organization: ${{ secrets.TF_ORGANIZATION }}
          workspace: "my-workspace-name"
          token: ${{ secrets.TF_API_TOKEN }}
          vars: '
            {
              "key": "region",
              "value": "eu-west-3",
              "sensitive": "false"
            },
            {
              "key": "access_key_id",
              "value": "${{ secrets.AWS_ACCESS_KEY_ID }}",
              "sensitive": "true"
            }
          '
          
      - name: Get the output time
        run: echo "The workspace ID is ${{ steps.workspace.outputs.workspace_id }}"
```
