#!/bin/sh -l

echo "Hello my $1"
time=$(date)
echo "::set-output name=workspace_id::$time"
