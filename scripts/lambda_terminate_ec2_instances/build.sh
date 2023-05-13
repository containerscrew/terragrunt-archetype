#!/usr/bin/env bash

echo -en "Building lambda...\n"
GOOS=linux GOARCH=amd64 go build -o bin/main main.go
echo -en "Done!"
