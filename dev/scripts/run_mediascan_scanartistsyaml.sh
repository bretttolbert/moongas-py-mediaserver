#!/bin/bash
set -euo pipefail

pushd moongas-go-mediascan > /dev/null
go run cmd/scanartistsyaml/main.go ../mediascan-config.yml ../mediascan-artists.yml
popd > /dev/null