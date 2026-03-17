#!/usr/bin/env bash
# exit on error
set -o errexit

# Run migrations at startup
echo "DEBUG: Running migrations at startup..."
python manage.py migrate --noinput

# DEBUG: List tables after migration
echo "DEBUG: Listing database tables..."
python manage.py shell -c "from django.db import connection; print('Tables:', connection.introspection.table_names())"

# Import initial data from fooddeliverysys.sql (safe to run multiple times due to update_or_create)
echo "DEBUG: Importing data from fooddeliverysys.sql..."
python import_sql_data.py

# Start Gunicorn
echo "DEBUG: Starting Gunicorn..."
gunicorn FoodDeliverySystem.wsgi:application
