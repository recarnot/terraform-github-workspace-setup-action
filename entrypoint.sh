#!/bin/sh -l

echo "Terraform Organization: $1"
echo "Terraform Workspace: $2"

echo "$4" > variables.json
cat variables.json

#Create workspace
sed "s/T_WS/$2/" < ./template/workspace.payload > workspace.json
curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request POST --data @workspace.json "https://app.terraform.io/api/v2/organizations/$1/workspaces" > workspace_result

#Retreive Workspace ID
wid=$(curl -s --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/organizations/$1/workspaces/$2" | jq -r .data.id)
echo "::set-output name=workspace_id::$wid"

#Clean existing variables
curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/workspaces/$wid/vars" > vars.json
x=$(cat vars.json | jq -r ".data[].id" | wc -l | awk '{print $1}')
i=0

while [ $i -lt $x ]
do
  curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request DELETE "https://app.terraform.io/api/v2/workspaces/$wid/vars/$(cat vars.json | jq -r ".data[$i].id")"
  i=`expr $i + 1`
done

#Create variables
for k in $(jq '.vars | keys | .[]' variables.json); do
    value=$(jq -r ".vars[$k]" variables.json);

    key=$(echo $value | jq '.key')
    raw_value=$(echo $value | jq '.value')
    escaped_value=$(echo $raw_value | sed -e 's/[]\/$*.^[]/\\&/g');
    sensitive=$(echo $value | jq '.sensitive')

    echo -e "\n$key = $escaped_value"

    sed -e "s/T_KEY/$key/" -e "s/my-hcl/false/" -e "s/T_VALUE/$escaped_value/" -e "s/T_SECURED/$sensitive/" -e "s/T_WSID/$wid/" < ./template/variable.payload  > paylaod.json
    curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request POST --data @paylaod.json "https://app.terraform.io/api/v2/workspaces/$wid/vars"
done
