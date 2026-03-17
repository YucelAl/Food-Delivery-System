#!/usr/bin/env bash
# exit on error
set -o errexit

# Run migrations at startup
echo "DEBUG: Running migrations at startup..."
# Set +e to allow error handling for migrations
set +o errexit
# We try to migrate normally, but if it fails (likely due to existing tables), we fake it.
python manage.py migrate --noinput --fake-initial
if [ $? -ne 0 ]; then
    echo "WARNING: Normal migration failed, attempting to fake the delivery migration..."
    python manage.py migrate delivery --fake
    # Try one more time for everything else
    python manage.py migrate --noinput --fake-initial
fi
# Re-enable exit on error
set -o errexit

# DEBUG: List tables after migration
echo "DEBUG: Listing database tables..."
python manage.py shell -c "from django.db import connection; print('Tables:', connection.introspection.table_names())"

# Import initial data from fooddeliverysys.sql (safe to run multiple times due to update_or_create)
echo "DEBUG: Importing data from fooddeliverysys.sql..."
python import_sql_data.py

# Start Gunicorn
echo "DEBUG: Starting Gunicorn..."
gunicorn FoodDeliverySystem.wsgi:application
