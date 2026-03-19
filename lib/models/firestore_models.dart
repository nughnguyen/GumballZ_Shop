import 'package:cloud_firestore/cloud_firestore.dart';

/// Extended Product Model for Firestore integration
class FirestoreProduct {
  final String id;
  final String title;
  final String brandName;
  final String image;
  final List<String>? gallery;
  final double price;
  final double? priceAfterDiscount;
  final int? discountPercent;
  final String? description;
  final String? categoryId;
  final int? stock;
  final double? rating;
  final int? reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FirestoreProduct({
    required this.id,
    required this.title,
    required this.brandName,
    required this.image,
    this.gallery,
    required this.price,
    this.priceAfterDiscount,
    this.discountPercent,
    this.description,
    this.categoryId,
    this.stock,
    this.rating,
    this.reviewCount,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from Firestore document
  factory FirestoreProduct.fromJson(Map<String, dynamic> json, String docId) {
    return FirestoreProduct(
      id: docId,
      title: json['title'] as String? ?? '',
      brandName: json['brandName'] as String? ?? 'Unknown',
      image: json['image'] as String? ?? '',
      gallery: (json['gallery'] as List?)?.map((e) => e.toString()).toList(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble(),
      discountPercent: json['discountPercent'] as int?,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      stock: json['stock'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'brandName': brandName,
      'image': image,
      'gallery': gallery,
      'price': price,
      'priceAfterDiscount': priceAfterDiscount,
      'discountPercent': discountPercent,
      'description': description,
      'categoryId': categoryId,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  /// Check if product is in stock
  bool get isInStock => stock == null || stock! > 0;

  /// Check if product has discount
  bool get hasDiscount => priceAfterDiscount != null && priceAfterDiscount! < price;

  /// Get effective price (discounted or original)
  double get effectivePrice => priceAfterDiscount ?? price;

  @override
  String toString() {
    return 'FirestoreProduct(id: $id, title: $title, price: $price, discount: $discountPercent%)';
  }
}

/// Extended Category Model for Firestore
class FirestoreCategory {
  final String id;
  final String name;
  final String? icon;
  final String? image;
  final int priority;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FirestoreCategory({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    required this.priority,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from Firestore document
  factory FirestoreCategory.fromJson(Map<String, dynamic> json, String docId) {
    return FirestoreCategory(
      id: docId,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      priority: json['priority'] as int? ?? 0,
      description: json['description'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'image': image,
      'priority': priority,
      'description': description,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() => 'FirestoreCategory(id: $id, name: $name, priority: $priority)';
}

/// Order model for Firestore
class FirestoreOrder {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double shipping;
  final double? discount;
  final double total;
  final String status;
  final String? promoCode;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FirestoreOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    this.discount,
    required this.total,
    required this.status,
    this.promoCode,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create from Firestore document
  factory FirestoreOrder.fromJson(Map<String, dynamic> json, String docId) {
    return FirestoreOrder(
      id: docId,
      userId: json['userId'] as String? ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] as List? ?? []),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shipping: (json['shipping'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
      promoCode: json['promoCode'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items,
      'subtotal': subtotal,
      'shipping': shipping,
      'discount': discount,
      'total': total,
      'status': status,
      'promoCode': promoCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'FirestoreOrder(id: $id, userId: $userId, total: $total, status: $status)';
  }
}
