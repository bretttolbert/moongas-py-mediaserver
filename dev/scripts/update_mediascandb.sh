#!/bin/bash
set -euo pipefail
cd mediascan
go run cmd/scantodb/main.go conf/conf.yaml out/mediascan.db
cd ..
