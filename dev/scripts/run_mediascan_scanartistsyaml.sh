#!/bin/bash
set -euo pipefail

pushd moongas-go-mediascan > /dev/null
go run cmd/scanartistsyaml/main.go ../mediascan-config.yaml ../mediascan-artists.yaml
popd > /dev/null