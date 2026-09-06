#!/bin/bash
set -euo pipefail

pushd moongas-go-mediascan > /dev/null
go run cmd/scantodb/main.go ../mediascan-config.yaml ../mediascan.db
popd > /dev/null