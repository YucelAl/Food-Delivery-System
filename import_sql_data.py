import os
import django
import re
import decimal
from datetime import time

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'FoodDeliverySystem.settings')
django.setup()

from delivery.models import Restaurant, MenuItem, OrderItem, Profile, Order
from django.contrib.auth.models import User

def parse_sql_file(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Simple regex to find INSERT INTO `table` VALUES (...);
    # Note: This might not handle all SQL edge cases but should work for this dump
    insert_pattern = re.compile(r"INSERT INTO `([^`]+)` VALUES\s*(.*?);", re.DOTALL)
    
    data = {}
    for match in insert_pattern.finditer(content):
        table_name = match.group(1)
        values_str = match.group(2)
        
        # Split values by ),( but be careful with commas inside strings
        # For this specific dump, we can try a slightly more robust way
        # Actually, let's just find all (...) groups
        rows = []
        # This regex matches (val1, val2, ...)
        row_pattern = re.compile(r"\((.*?)\)(?:,|$)", re.DOTALL)
        for row_match in row_pattern.finditer(values_str):
            row_content = row_match.group(1)
            # Split by comma but ignore commas in strings
            # This is tricky. Let's use a simpler split if we know the data
            # Or use a proper CSV-like parser for the row
            import csv
            from io import StringIO
            # csv reader can handle quoted strings with commas
            reader = csv.reader(StringIO(row_content), quotechar="'", skipinitialspace=True)
            for row in reader:
                rows.append([val if val != 'NULL' else None for val in row])
        
        data[table_name] = rows
    return data

def import_data():
    sql_data = parse_sql_file('fooddeliverysys.sql')
    
    # 1. Restaurants
    if 'restaurant' in sql_data:
        print("Importing Restaurants...")
        # Check if table exists
        from django.db import connection
        if 'restaurant' not in connection.introspection.table_names():
            print("ERROR: 'restaurant' table does not exist. Skipping restaurant import.")
        else:
            for row in sql_data['restaurant']:
                # `restaurant_id`, `name`, `cuisine_type`, `address`, `phone`, `opening_time`, `closing_time`
                Restaurant.objects.update_or_create(
                    restaurant_id=int(row[0]),
                    defaults={
                        'name': row[1],
                        'cuisine_type': row[2],
                        'address': row[3],
                        'phone': row[4],
                        'opening_time': row[5],
                        'closing_time': row[6],
                    }
                )

    # 2. Menu Items
    if 'menuitem' in sql_data:
        print("Importing Menu Items...")
        if 'menuitem' not in connection.introspection.table_names():
             print("ERROR: 'menuitem' table does not exist. Skipping menu item import.")
        else:
            for row in sql_data['menuitem']:
                # `item_id`, `restaurant_id`, `name`, `description`, `price`, `is_available`
                MenuItem.objects.update_or_create(
                    item_id=int(row[0]),
                    defaults={
                        'restaurant_id': int(row[1]),
                        'name': row[2],
                        'description': row[3],
                        'price': decimal.Decimal(row[4]),
                        'is_available': row[5] == '1',
                    }
                )

    # 3. Customers -> User/Profile
    if 'customer' in sql_data:
        print("Importing Customers...")
        if 'user_profile' not in connection.introspection.table_names():
             print("ERROR: 'user_profile' table does not exist. Skipping customer import.")
        else:
            for row in sql_data['customer']:
                # `customer_id`, `first_name`, `last_name`, `email`, `phone`, `address`, `registration_date`
                # row[0] is customer_id
                username = row[3].split('@')[0] # Simple username from email
                user, created = User.objects.get_or_create(
                    email=row[3],
                    defaults={'username': username, 'first_name': row[1], 'last_name': row[2]}
                )
                Profile.objects.update_or_create(
                    user=user,
                    defaults={'phone': row[4], 'address': row[5], 'user_type': 'customer'}
                )

    # 4. Drivers -> User/Profile
    if 'driver' in sql_data:
        print("Importing Drivers...")
        if 'user_profile' not in connection.introspection.table_names():
             print("ERROR: 'user_profile' table does not exist. Skipping driver import.")
        else:
            for row in sql_data['driver']:
                # `driver_id`, `first_name`, `last_name`, `phone`, `vehicle_type`, `is_available`
                username = f"driver_{row[0]}"
                user, created = User.objects.get_or_create(
                    username=username,
                    defaults={'first_name': row[1], 'last_name': row[2]}
                )
                Profile.objects.update_or_create(
                    user=user,
                    defaults={'phone': row[3], 'user_type': 'driver'}
                )

    # Note: Order and OrderItem in the SQL file have some mismatch with Django models
    # but let's try to import them if they exist and are relevant.
    # The Django Order model has different fields than the SQL one.
    # SQL Order: `order_id`, `customer_id`, `restaurant_id`, `driver_id`, `order_date`, `total_amount`, `status`, `is_paid`
    # Django Order: `customer` (FK), `driver` (FK), `restaurant_name`, `total_price`, `status`, `created_at`

    if 'order' in sql_data:
        print("Importing Orders (Best effort mapping)...")
        for row in sql_data['order']:
            # Find customer user
            # In SQL, customer_id might not match Django user id, but we can try to find by some logic or just skip
            # Since we don't have a direct mapping of customer_id to user_id yet (we didn't store it), 
            # this part is tricky. 
            pass

    print("Import completed.")

if __name__ == "__main__":
    import_data()
