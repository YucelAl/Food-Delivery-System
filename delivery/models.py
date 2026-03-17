from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Profile(models.Model):
    """
    Extends the default Django User model to include additional information 
    like phone number, address, and user type (Customer or Driver).
    """
    USER_TYPES = (
        ('customer', 'Customer'),
        ('driver', 'Driver'),
    )
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    phone = models.CharField(max_length=15, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    user_type = models.CharField(max_length=10, choices=USER_TYPES, default='customer')

    def __str__(self):
        """Returns a string representation of the profile, showing the username and user type."""
        return f"{self.user.username} ({self.get_user_type_display()})"

class Order(models.Model):
    """
    Represents a food delivery order, tracking the customer, driver, 
    restaurant details, total price, and its current status.
    """
    STATUS_CHOICES = (
        ('waiting', 'Waiting'),
        ('ongoing', 'Ongoing'),
        ('completed', 'Completed'),
    )
    customer = models.ForeignKey(User, on_delete=models.CASCADE, related_name='customer_orders')
    driver = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='driver_orders')
    restaurant_name = models.CharField(max_length=255)
    total_price = models.FloatField()
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='waiting')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        """Returns a string representation of the order, including its ID and status."""
        return f"Order #{self.id} - {self.status}"

class MenuItem(models.Model):
    """
    Represents an item on a restaurant's menu. 
    """
    item_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    restaurant_id = models.IntegerField()
    description = models.TextField(blank=True, null=True)
    price = models.DecimalField(max_digits=6, decimal_places=2)
    is_available = models.BooleanField(default=True)

    class Meta:
        managed = True
        db_table = 'menuitem'

class OrderItem(models.Model):
    """
    Represents an item within a specific order, linking a menu item 
    with its price at the time of order and the restaurant ID.
    """
    order_item_id = models.AutoField(primary_key=True)
    order_id = models.IntegerField()
    item_id = models.IntegerField()
    quantity = models.IntegerField()
    subtotal = models.DecimalField(max_digits=8, decimal_places=2)

    class Meta:
        managed = True
        db_table = 'orderitem'

class Restaurant(models.Model):
    """
    Stores information about a restaurant, including its name, cuisine, 
    contact details, and operating hours.
    """
    restaurant_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255)
    cuisine_type = models.CharField(max_length=255, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    phone = models.CharField(max_length=20, blank=True, null=True)
    opening_time = models.TimeField(blank=True, null=True)
    closing_time = models.TimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'restaurant'
