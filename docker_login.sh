#!/bin/bash

# CR_PAT must be defined to a PAT that has package registry access
echo $CR_PAT | docker login ghcr.io -u nfrechette --password-stdin
