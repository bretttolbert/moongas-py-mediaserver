#!/bin/bash
set -euo pipefail
cd mediascan
go run cmd/scanfilesyaml/main.go conf/conf.yaml out/files.yaml
cd ..
