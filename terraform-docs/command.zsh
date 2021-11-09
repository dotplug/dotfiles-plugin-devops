#!/bin/bash

# https://terraform-docs.io/user-guide/installation/

function terraform-docs() {
    docker run --rm \
        --name terraform-docs \
        -v $(pwd):/project \
        -w /project \
        quay.io/terraform-docs/terraform-docs:latest $*
}
