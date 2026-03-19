import 'package:flutter/foundation.dart';
import 'package:shop/models/cart_item_model.dart';
import 'package:shop/models/product_model.dart';

/// Provider class for managing shopping cart state
/// 
/// Responsibilities:
/// - Add/remove items from cart
/// - Update item quantities
/// - Calculate totals and discounts
/// - Provide cart item count and status
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Get all items in the cart
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get the total number of items in the cart
  int get itemCount => _items.length;

  /// Get the total number of products (considering quantities)
  int get totalProductCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get the subtotal before discount and shipping
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Get the total original price before any discounts
  double get originalSubtotal {
    return _items.fold(0.0, (sum, item) => sum + item.originalTotalPrice);
  }

  /// Get total discount amount
  double get totalDiscount => originalSubtotal - subtotal;

  /// Get whether the cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Get whether the cart has items
  bool get isNotEmpty => _items.isNotEmpty;

  /// Add a product to the cart
  /// If the product already exists, increment its quantity
  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.title == product.title && item.brandName == product.brandName,
    );

    if (existingIndex >= 0) {
      // Product already in cart, increase quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // New product, add to cart
      _items.add(CartItem.fromProduct(product, quantity: quantity));
    }

    notifyListeners();
  }

  /// Remove an item from the cart by index
  void removeFromCart(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Remove an item from the cart by its ID
  void removeItemById(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      removeFromCart(index);
    }
  }

  /// Update the quantity of an item in the cart
  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _items.length) {
      if (newQuantity <= 0) {
        removeFromCart(index);
      } else {
        _items[index].quantity = newQuantity;
        notifyListeners();
      }
    }
  }

  /// Increment the quantity of an item
  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Decrement the quantity of an item
  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeFromCart(index);
      }
    }
  }

  /// Find an item in the cart by product title and brand
  CartItem? findItem(String title, String brandName) {
    try {
      return _items.firstWhere(
        (item) => item.title == title && item.brandName == brandName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if a product is in the cart
  bool isInCart(String title, String brandName) {
    return _items.any(
      (item) => item.title == title && item.brandName == brandName,
    );
  }

  /// Get the quantity of a product in the cart
  int getQuantity(String title, String brandName) {
    final item = findItem(title, brandName);
    return item?.quantity ?? 0;
  }

  /// Clear the entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Apply a discount/coupon code (for future use)
  /// This is a placeholder for coupon functionality
  void applyCoupon(String couponCode, {double discountPercentage = 0}) {
    // TODO: Implement coupon logic with Firebase integration
    notifyListeners();
  }
}
