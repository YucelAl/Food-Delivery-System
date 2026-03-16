#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
pip install -r requirements.txt

# Run migrations
echo "Running migrations..."
python manage.py migrate --noinput
