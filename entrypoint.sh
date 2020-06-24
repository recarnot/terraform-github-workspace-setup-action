#!/bin/sh -l

echo "Terraform Organization: $1"
echo "Terraform Workspace: $2"

#Create workspace
sed "s/T_WS/$2/" < ./template/workspace.payload > workspace.json
curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request POST --data @workspace.json "https://app.terraform.io/api/v2/organizations/$1/workspaces" > workspace_result

#Retreive Workspace ID
wid=$(curl -s --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/organizations/$1/workspaces/$2" | jq -r .data.id)
echo "::set-output name=workspace_id::$wid"


#ESCAPED_VALUE=$(echo $2 | sed -e 's/[]\/$*.^[]/\\&/g');
#sed -e "s/T_KEY/my-key/" -e "s/my-hcl/false/" -e "s/T_VALUE/romain/" -e "s/T_SECURED/false/" -e "s/T_WSID/$wid/" < ./template/variable.payload  > variable.json
#curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --data @variable.json "https://app.terraform.io/api/v2/vars"

for k in $(jq '.vars | keys | .[]' /github/workspace/variables.json); do
    value=$(jq -r ".vars[$k]" /github/workspace/variables.json);

    key=$(echo $value | jq '.key')
    raw_value=$(echo $value | jq '.value')
    escaped_value=$(echo $raw_value | sed -e 's/[]\/$*.^[]/\\&/g');
    sensitive=$(echo $value | jq '.sensitive')

    echo $key
    echo $escaped_value
    echo $sensitive

    sed -e "s/T_KEY/$key/" -e "s/my-hcl/false/" -e "s/T_VALUE/$escaped_value/" -e "s/T_SECURED/$sensitive/" -e "s/T_WSID/$wid/" < ./template/variable.payload  > paylaod.json

    cat paylaod.json

    curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request POST --data @paylaod.json "https://app.terraform.io/api/v2/workspaces/$wid/vars"
done
