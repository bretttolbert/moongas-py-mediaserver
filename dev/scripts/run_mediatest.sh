#!/bin/bash
set -euo pipefail
cd mediatest
python -m pytest . -vv
