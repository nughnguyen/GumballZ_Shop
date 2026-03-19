import 'package:cloud_firestore/cloud_firestore.dart';

/// AdminService
/// Singleton service for all admin-specific Firestore operations
class AdminService {
  static final AdminService _instance = AdminService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminService._internal();

  factory AdminService() {
    return _instance;
  }

  // ============ PRODUCT OPERATIONS ============

  /// Get all products with admin details
  Future<List<Map<String, dynamic>>> getAllProductsForAdmin() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting products for admin: $e');
      rethrow;
    }
  }

  /// Add new product
  Future<String> addProduct(Map<String, dynamic> productData) async {
    try {
      final docRef = await _firestore.collection('products').add({
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }

  /// Update product
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

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  // ============ CATEGORY OPERATIONS ============

  /// Get all categories for admin (sorted by priority)
  Future<List<Map<String, dynamic>>> getAllCategoriesForAdmin() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .orderBy('priority', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting categories for admin: $e');
      rethrow;
    }
  }

  /// Add new category
  Future<String> addCategory(Map<String, dynamic> categoryData) async {
    try {
      final docRef = await _firestore.collection('categories').add({
        ...categoryData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      print('Error adding category: $e');
      rethrow;
    }
  }

  /// Update category (including priority reordering)
  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }

  // ============ ORDER OPERATIONS ============

  /// Get all orders for admin
  Future<List<Map<String, dynamic>>> getAllOrdersForAdmin() async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting orders for admin: $e');
      rethrow;
    }
  }

  /// Get orders filtered by status
  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting orders by status: $e');
      rethrow;
    }
  }

  /// Update order status (pending → shipped → delivered)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  /// Get order details with product info
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }
      return null;
    } catch (e) {
      print('Error getting order details: $e');
      rethrow;
    }
  }

  // ============ PROMO CODE OPERATIONS ============

  /// Get all promo codes for admin
  Future<List<Map<String, dynamic>>> getAllPromoCodesForAdmin() async {
    try {
      final snapshot = await _firestore
          .collection('promoCodes')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting promo codes for admin: $e');
      rethrow;
    }
  }

  /// Add new promo code
  Future<String> addPromoCode(Map<String, dynamic> promoData) async {
    try {
      final code = promoData['code'] as String;
      await _firestore.collection('promoCodes').doc(code).set({
        ...promoData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return code;
    } catch (e) {
      print('Error adding promo code: $e');
      rethrow;
    }
  }

  /// Update promo code
  Future<void> updatePromoCode(String code, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('promoCodes').doc(code).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating promo code: $e');
      rethrow;
    }
  }

  /// Delete promo code
  Future<void> deletePromoCode(String code) async {
    try {
      await _firestore.collection('promoCodes').doc(code).delete();
    } catch (e) {
      print('Error deleting promo code: $e');
      rethrow;
    }
  }

  /// Deactivate promo code (soft delete)
  Future<void> deactivatePromoCode(String code) async {
    try {
      await _firestore.collection('promoCodes').doc(code).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error deactivating promo code: $e');
      rethrow;
    }
  }

  // ============ ANALYTICS OPERATIONS ============

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      // Total products
      final productsSnap = await _firestore.collection('products').count().get();
      int totalProducts = productsSnap.count ?? 0;

      // Total orders
      final ordersSnap = await _firestore.collection('orders').count().get();
      int totalOrders = ordersSnap.count ?? 0;

      // Pending orders
      final pendingSnap = await _firestore
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .count()
          .get();
      int pendingOrders = pendingSnap.count ?? 0;

      // Active promos
      final promosSnap = await _firestore
          .collection('promoCodes')
          .where('isActive', isEqualTo: true)
          .count()
          .get();
      int activePromos = promosSnap.count ?? 0;

      return {
        'totalProducts': totalProducts,
        'totalOrders': totalOrders,
        'pendingOrders': pendingOrders,
        'activePromos': activePromos,
      };
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return {
        'totalProducts': 0,
        'totalOrders': 0,
        'pendingOrders': 0,
        'activePromos': 0,
      };
    }
  }
}
