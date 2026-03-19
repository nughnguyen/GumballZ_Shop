import 'package:shop/models/product_model.dart';

/// Represents an item in the shopping cart with quantity tracking
class CartItem {
  final String id;
  final String image;
  final String brandName;
  final String title;
  final double price;
  final double? priceAfterDiscount;
  final int? discountPercent;
  int quantity;

  CartItem({
    required this.id,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfterDiscount,
    this.discountPercent,
    this.quantity = 1,
  });

  /// Create CartItem from ProductModel
  factory CartItem.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItem(
      id: product.title.replaceAll(' ', '_').toLowerCase(),
      image: product.image,
      brandName: product.brandName,
      title: product.title,
      price: product.price,
      priceAfterDiscount: product.priceAfetDiscount,
      discountPercent: product.dicountpercent,
      quantity: quantity,
    );
  }

  /// Get the effective price (discounted if available, otherwise original)
  double get effectivePrice => priceAfterDiscount ?? price;

  /// Calculate the total price for this item (effective price × quantity)
  double get totalPrice => effectivePrice * quantity;

  /// Calculate the original total price before discount
  double get originalTotalPrice => price * quantity;

  /// Check if this item has a discount
  bool get hasDiscount => priceAfterDiscount != null && priceAfterDiscount! < price;

  @override
  String toString() {
    return 'CartItem(id: $id, title: $title, quantity: $quantity, totalPrice: $totalPrice)';
  }
}
