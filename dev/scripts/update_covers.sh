#!/bin/bash
set -euo pipefail
python moongas-py-mediascan/scripts/copy_covers.py
python moongas-py-mediascan/scripts/convert_covers.py
