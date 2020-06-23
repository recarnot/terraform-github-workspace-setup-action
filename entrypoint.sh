#!/bin/sh -l

echo "Organization $1"
echo "Workspace $2"


sed "s/T_WS/$2/" < ./template/workspace.payload.template > workspace.json
curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" --request POST --data @workspace.json "https://app.terraform.io/api/v2/organizations/$1/workspaces" > workspace_result
wid=$(cat workspace_result | jq -r .data.id)
wid=$(curl -s --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/organizations/$1/workspaces/$2" | jq -r .data.id)

curl --header "Authorization: Bearer $3" --header "Content-Type: application/vnd.api+json" "https://app.terraform.io/api/v2/vars?filter%5Borganization%5D%5Bname%5D=$1&filter%5Bworkspace%5D%5Bname%5D=$2" > vars.json
x=$(cat vars.json | jq -r ".data[].id" | wc -l | awk '{print $1}')

if [ $x -ge 0 ]
then
  for (( i=0; i<$x; i++ ))
  do
    curl --header "Authorization: Bearer $1" --header "Content-Type: application/vnd.api+json" --request DELETE https://app.terraform.io/api/v2/vars/$(cat vars.json | jq -r ".data[$i].id")
  done
fi

echo "::set-output name=workspace_id::$wid"

