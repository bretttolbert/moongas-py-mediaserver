#!/bin/bash
set -euo pipefail

pushd moongas-go-mediascan > /dev/null
go run cmd/scanfilesyaml/main.go ../mediascan-config.yaml ../mediascan-files.yaml
popd > /dev/null