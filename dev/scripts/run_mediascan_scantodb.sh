#!/bin/bash
set -euo pipefail

pushd moongas-go-mediascan > /dev/null
go run cmd/scantodb/main.go ../mediascan-config.yml ../mediascan.db
popd > /dev/null