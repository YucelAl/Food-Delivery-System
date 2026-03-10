from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('register/', views.register, name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('restaurants/', views.restaurants, name='restaurants'),
    path('restaurants/<int:restaurant_id>/menu/', views.menu, name='menu'),
    path('checkout/', views.checkout, name='checkout'),
    path('order/<int:order_id>/', views.order_detail, name='order_detail'),
    path('driver/', views.driver_home, name='driver_home'),
    path('driver/waiting-orders/', views.waiting_orders, name='waiting_orders'),
    path('driver/orders/', views.driver_orders, name='driver_orders'),
    path('driver/completed-orders/', views.completed_orders, name='completed_orders'),
    path('driver/accept-order/<int:order_id>/', views.accept_order, name='accept_order'),
    path('driver/complete-order/<int:order_id>/', views.complete_order, name='complete_order'),
]
