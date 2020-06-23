#!/bin/sh -l

echo "Organization $1"
echo "Workspace $2"


sed "s/T_WS/$2/" < ./template/workspace.payload.template > workspace.json
curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request POST --data @workspace.json "https://app.terraform.io/api/v2/organizations/$1/workspaces" > workspace_result
wid=$(cat workspace_result | jq -r .data.id)

wid=$(curl -s --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/organizations/$1/workspaces/$2" | jq -r .data.id)



echo "::set-output name=workspace_id::$wid"

