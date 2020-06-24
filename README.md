# Terraform Cloud/Enterprise workspace setup
**GitHub Action** to set up **Terraform Cloud/Enterprise** workspace



## Inputs

| name         | description                 | required |
| ------------ | --------------------------- | -------- |
| organization | Terraform Organization name | true     |
| workspace    | Terraform Workspace name    | true     |
| token        | Terraform API token         | true     |



## Usage



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
        uses: recarnot/terraform-github-workspace-setup@master
        with:
          organization: ${{ secrets.TF_ORGANIZATION }}
          workspace: "my-workspace-name"
          token: ${{ secrets.TF_API_TOKEN }}

      - name: Get the output time
        run: echo "The workspace ID is ${{ steps.workspace.outputs.workspace_id }}"
```

