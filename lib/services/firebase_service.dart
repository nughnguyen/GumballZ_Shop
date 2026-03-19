import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase service singleton for database operations
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal() {
    _firestore = FirebaseFirestore.instance;
    _auth = FirebaseAuth.instance;
  }

  // Getters for Firebase instances
  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;

  // ==================== PRODUCTS ====================
  
  /// Get all products as a Stream
  Stream<List<Map<String, dynamic>>> getAllProducts() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  /// Get products by category
  Stream<List<Map<String, dynamic>>> getProductsByCategory(String categoryId) {
    return _firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  /// Get products on sale
  Stream<List<Map<String, dynamic>>> getFlashSaleProducts() {
    return _firestore
        .collection('products')
        .where('discount', isGreaterThan: 0)
        .orderBy('discount', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  /// Get product by ID
  Future<Map<String, dynamic>?> getProduct(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return {...doc.data()!, 'id': doc.id};
      }
      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  /// Search products by title or description
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      final results = await _firestore
          .collection('products')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(20)
          .get();

      return results.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  /// Add product (Admin only)
  Future<String> addProduct(Map<String, dynamic> productData) async {
    try {
      final ref = await _firestore.collection('products').add({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return ref.id;
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  /// Update product (Admin only)
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  /// Delete product (Admin only)
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  // ==================== CATEGORIES ====================

  /// Get all categories ordered by priority
  Stream<List<Map<String, dynamic>>> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('priority', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  /// Get category by ID
  Future<Map<String, dynamic>?> getCategory(String categoryId) async {
    try {
      final doc = await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        return {...doc.data()!, 'id': doc.id};
      }
      return null;
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }

  // ==================== CART & ORDERS ====================

  /// Save cart for user
  Future<void> saveCart(String userId, List<Map<String, dynamic>> cartItems) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'cart': cartItems,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving cart: $e');
      rethrow;
    }
  }

  /// Get user's cart
  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data()!['cart'] != null) {
        return List<Map<String, dynamic>>.from(doc.data()!['cart']);
      }
      return [];
    } catch (e) {
      print('Error fetching cart: $e');
      return [];
    }
  }

  /// Create an order
  Future<String> createOrder(String userId, Map<String, dynamic> orderData) async {
    try {
      final ref = await _firestore.collection('orders').add({
        'userId': userId,
        ...orderData,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return ref.id;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  /// Get user's orders
  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  // ==================== FAVORITES ====================

  /// Add product to favorites
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .set({'addedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  /// Remove product from favorites
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  /// Get user's favorite products
  Stream<List<String>> getUserFavorites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  /// Check if product is favorited
  Future<bool> isFavorited(String userId, String productId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // ==================== PROMO CODES ====================

  /// Validate and get promo code
  Future<Map<String, dynamic>?> getPromoCode(String code) async {
    try {
      final doc = await _firestore.collection('promoCodes').doc(code).get();
      if (doc.exists) {
        final data = doc.data()!;
        // Check if code is valid (not expired)
        final expiryDate = (data['expiryDate'] as Timestamp?)?.toDate();
        if (expiryDate != null && expiryDate.isBefore(DateTime.now())) {
          return null; // Code expired
        }
        return data;
      }
      return null;
    } catch (e) {
      print('Error fetching promo code: $e');
      return null;
    }
  }
}
