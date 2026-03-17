from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from .models import Profile, MenuItem, OrderItem, Restaurant, Order
from django.contrib import messages
from django.contrib.auth.decorators import login_required

def home(request):
    """
    Renders the home page. 
    If a logged-in user is a driver, they are redirected to the driver home page.
    """
    if request.user.is_authenticated:
        if hasattr(request.user, 'profile') and request.user.profile.user_type == 'driver':
            return redirect('driver_home')
    return render(request, 'delivery/home.html')

def register(request):
    """
    Handles user registration. 
    Captures user details, creates a Django User, and an associated Profile.
    """
    if request.method == 'POST':
        first_name = request.POST.get('first_name')
        last_name = request.POST.get('last_name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        address = request.POST.get('address')
        password = request.POST.get('password')
        user_type = request.POST.get('user_type', 'customer')
        
        # Use email as username for simplicity
        if User.objects.filter(username=email).exists():
            messages.error(request, "A user with this email already exists.")
            return render(request, 'delivery/register.html')
            
        # Create User
        user = User.objects.create_user(username=email, email=email, password=password, first_name=first_name, last_name=last_name)
        user.save()
        
        # Create Profile
        Profile.objects.create(user=user, phone=phone, address=address, user_type=user_type)
        
        messages.success(request, "Account created! You can now login.")
        return redirect('login')
        
    return render(request, 'delivery/register.html')

def login_view(request):
    """
    Handles user login. 
    Authenticates the user and redirects them based on their user type (Customer or Driver).
    """
    if request.method == 'POST':
        email = request.POST.get('email')
        password = request.POST.get('password')
        
        user = authenticate(request, username=email, password=password)
        if user is not None:
            login(request, user)
            if hasattr(user, 'profile') and user.profile.user_type == 'driver':
                return redirect('driver_home')
            return redirect('home')
        else:
            messages.error(request, "Invalid email or password.")
            
    return render(request, 'delivery/login.html')

@login_required
def driver_home(request):
    """
    Renders the driver's dashboard. 
    Only accessible to users with the 'driver' user type.
    """
    if request.user.profile.user_type != 'driver':
        return redirect('home')
    return render(request, 'delivery/Driver_Home.html')

@login_required
def waiting_orders(request):
    """
    Displays all orders that are currently in 'waiting' status.
    Available only to drivers.
    """
    if request.user.profile.user_type != 'driver':
        return redirect('home')
    orders = Order.objects.filter(status='waiting')
    return render(request, 'delivery/Waiting_Orders.html', {'orders': orders})

@login_required
def driver_orders(request):
    """
    Displays orders that the current driver has accepted and are 'ongoing'.
    """
    if request.user.profile.user_type != 'driver':
        return redirect('home')
    orders = Order.objects.filter(driver=request.user, status='ongoing')
    return render(request, 'delivery/Orders.html', {'orders': orders})

@login_required
def completed_orders(request):
    """
    Displays a history of orders that the current driver has successfully 'completed'.
    """
    if request.user.profile.user_type != 'driver':
        return redirect('home')
    orders = Order.objects.filter(driver=request.user, status='completed')
    return render(request, 'delivery/Completed_Orders.html', {'orders': orders})

@login_required
def accept_order(request, order_id):
    """
    Allows a driver to accept a 'waiting' order. 
    Updates the order status to 'ongoing' and assigns the driver.
    """
    if request.user.profile.user_type != 'driver':
        return redirect('home')
    order = get_object_or_404(Order, id=order_id, status='waiting')
    order.driver = request.user
    order.status = 'ongoing'
    order.save()
    messages.success(request, f"Order #{order.id} accepted.")
    return redirect('driver_orders')

@login_required
def complete_order(request, order_id):
    """
    Allows a driver to mark an 'ongoing' order as 'completed'.
    """
    if request.user.profile.user_type != 'driver':
        return redirect('home')
    order = get_object_or_404(Order, id=order_id, driver=request.user, status='ongoing')
    order.status = 'completed'
    order.save()
    messages.success(request, f"Order #{order.id} completed.")
    return redirect('completed_orders')

def logout_view(request):
    """
    Logs out the current user and redirects to the home page.
    """
    logout(request)
    return redirect('home')

def restaurants(request):
    """
    Renders the page listing all available restaurants.
    """
    return render(request, 'delivery/restaurants.html')

def menu(request, restaurant_id):
    """
    Displays the menu for a specific restaurant.
    Retrieves menu items and their corresponding prices.
    """
    restaurant = get_object_or_404(Restaurant, restaurant_id=restaurant_id)
    menu_items = MenuItem.objects.filter(restaurant_id=restaurant_id)
    # MenuItem already has a price field in our model.
    items = []
    for item in menu_items:
        items.append({
            'name': item.name,
            'price': item.price,
            'item_id': item.item_id
        })
        
    return render(request, 'delivery/menu.html', {
        'restaurant': restaurant,
        'items': items
    })

def checkout(request):
    """
    Handles the checkout process.
    On POST: Processes the cart items, calculates the total, and creates an Order.
    On GET: Displays the current cart and total.
    """
    if request.method == 'POST':
        restaurant_id = request.POST.get('restaurant_id')
        if not restaurant_id:
             messages.error(request, "Invalid restaurant selection.")
             return redirect('restaurants')
        
        item_count = int(request.POST.get('item_count', 0))
        
        cart = []
        total = 0.0
        
        for i in range(1, item_count + 1):
            item_id = request.POST.get(f'item_id_{i}')
            if not item_id:
                continue
            quantity = int(request.POST.get(f'quantity_{item_id}', 0))
            if quantity > 0:
                name = request.POST.get(f'item_name_{item_id}')
                price = float(request.POST.get(f'item_price_{item_id}'))
                
                cart.append({
                    'item_id': item_id,
                    'name': name,
                    'price': price,
                    'quantity': quantity,
                    'item_total': price * quantity
                })
                total += price * quantity
        
        # Store in session for current request handling
        request.session['cart'] = cart
        request.session['cart_total'] = total
        request.session['restaurant_id'] = restaurant_id
        
        # Create persistent Order for drivers to see
        if request.user.is_authenticated and cart:
            restaurant = Restaurant.objects.get(restaurant_id=restaurant_id)
            order = Order.objects.create(
                customer=request.user,
                restaurant_name=restaurant.name,
                total_price=total,
                status='waiting'
            )
            
            # Also create OrderItem entries
            for item in cart:
                OrderItem.objects.create(
                    order_id=order.id,
                    item_id=int(item['item_id']),
                    quantity=item['quantity'],
                    subtotal=item['item_total']
                )
            
            messages.success(request, f"Order #{order.id} placed successfully!")
            return redirect('order_detail', order_id=order.id)
        
        return render(request, 'delivery/checkout.html', {
            'cart': cart,
            'total': total
        })
        
    # GET request: return checkout page with session data if exists
    cart = request.session.get('cart', [])
    total = request.session.get('cart_total', 0.0)
    
    if not cart:
        messages.warning(request, "Your cart is empty.")
        return redirect('restaurants')
    
    return render(request, 'delivery/checkout.html', {
        'cart': cart,
        'total': total
    })

def order_detail(request, order_id):
    """
    Displays the summary and details of a specific order after checkout.
    """
    # Fetch cart details and total from session
    cart = request.session.get('cart', [])
    total = request.session.get('cart_total', 0.0)
    
    # Fetch user details
    user = request.user
    profile = None
    if user.is_authenticated:
        try:
            profile = Profile.objects.get(user=user)
        except Profile.DoesNotExist:
            pass
            
    return render(request, 'delivery/order_detail.html', {
        'order_id': order_id,
        'cart': cart,
        'total': total,
        'user': user,
        'profile': profile,
    })
