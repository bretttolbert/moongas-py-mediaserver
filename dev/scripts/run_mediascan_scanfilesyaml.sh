#!/bin/bash
set -euo pipefail

pushd moongas-go-mediascan > /dev/null
go run cmd/scanfilesyaml/main.go ../mediascan-config.yml ../mediascan-files.yml
popd > /dev/null