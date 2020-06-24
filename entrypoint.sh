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

    echo $value
    #key=$(jq -r '.key' <<< "$value");
    #value=$(jq -r '.value' <<< "$value");
    #sensitive=$(jq -r '.sensitive' <<< "$value");
    #printf '%s\t%s\t%s\n' "$key" "$value" "$sensitive";
done | column -t -s$'\t'


#x=$(cat /github/workspace/variables.json | jq -r ".vars[].key" | wc -l | awk '{print $1}')
#for (( i=0; i<$x; i++ ))
#do
#  ESCAPED_VALUE=$(echo $2 | sed -e 's/[]\/$*.^[]/\\&/g')
#  curl --header "Authorization: Bearer $TF_TOKEN" --header "Content-Type: application/vnd.api+json" --request DELETE https://app.terraform.io/api/v2/vars/$(cat vars.json | jq -r ".data[$i].id")
#done
