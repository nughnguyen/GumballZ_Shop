import 'package:flutter/foundation.dart';
import 'package:shop/models/firestore_models.dart';
import 'package:shop/services/firebase_service.dart';

/// Provider for managing product data from Firestore
class ProductProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<FirestoreProduct> _allProducts = [];
  List<FirestoreProduct> _filteredProducts = [];
  List<FirestoreProduct> _flashSaleProducts = [];
  Map<String, FirestoreProduct> _productCache = {};

  bool _isLoading = false;
  String? _error;
  String _selectedCategoryId = '';

  // Getters
  List<FirestoreProduct> get allProducts => List.unmodifiable(_allProducts);
  List<FirestoreProduct> get filteredProducts => List.unmodifiable(_filteredProducts);
  List<FirestoreProduct> get flashSaleProducts => List.unmodifiable(_flashSaleProducts);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategoryId => _selectedCategoryId;

  /// Initialize and subscribe to product streams
  void initializeProductStreams() {
    // Subscribe to all products
    _firebaseService.getAllProducts().listen(
      (products) {
        _updateProductsList(products);
      },
      onError: (e) {
        _setError('Error loading products: $e');
      },
    );

    // Subscribe to flash sale products
    _firebaseService.getFlashSaleProducts().listen(
      (products) {
        _flashSaleProducts = products
            .map((json) => FirestoreProduct.fromJson(json, json['id']))
            .toList();
        notifyListeners();
      },
      onError: (e) {
        _setError('Error loading flash sales: $e');
      },
    );
  }

  /// Update products list and refresh filtered list
  void _updateProductsList(List<Map<String, dynamic>> products) {
    _setLoading(true);
    _allProducts = products
        .map((json) => FirestoreProduct.fromJson(json, json['id']))
        .toList();
    _cacheProducts(_allProducts);
    _applyFilters();
    _setLoading(false);
  }

  /// Cache products for quick lookup
  void _cacheProducts(List<FirestoreProduct> products) {
    for (var product in products) {
      _productCache[product.id] = product;
    }
  }

  /// Filter products by category
  void filterByCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _applyFilters();
  }

  /// Apply all active filters
  void _applyFilters() {
    if (_selectedCategoryId.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((product) => product.categoryId == _selectedCategoryId)
          .toList();
    }
    notifyListeners();
  }

  /// Search products
  Future<List<FirestoreProduct>> searchProducts(String query) async {
    if (query.isEmpty) {
      _applyFilters();
      notifyListeners();
      return _filteredProducts;
    }

    _setLoading(true);
    try {
      final results = await _firebaseService.searchProducts(query);
      final searchResults = results
          .map((json) => FirestoreProduct.fromJson(json, json['id']))
          .toList();
      _setLoading(false);
      return searchResults;
    } catch (e) {
      _setError('Search error: $e');
      _setLoading(false);
      return [];
    }
  }

  /// Get product by ID
  Future<FirestoreProduct?> getProductById(String productId) async {
    // Check cache first
    if (_productCache.containsKey(productId)) {
      return _productCache[productId];
    }

    // Fetch from Firestore
    _setLoading(true);
    try {
      final json = await _firebaseService.getProduct(productId);
      if (json != null) {
        final product = FirestoreProduct.fromJson(json, productId);
        _productCache[productId] = product;
        _setLoading(false);
        return product;
      }
    } catch (e) {
      _setError('Error fetching product: $e');
    }
    _setLoading(false);
    return null;
  }

  /// Get related products (same category, exclude current)
  List<FirestoreProduct> getRelatedProducts(
    String productId, {
    int limit = 5,
  }) {
    final product = _productCache[productId];
    if (product == null || product.categoryId == null) {
      return [];
    }

    return _allProducts
        .where((p) =>
            p.categoryId == product.categoryId &&
            p.id != productId &&
            p.hasDiscount)
        .take(limit)
        .toList();
  }

  /// Get recommended products (on sale or high rating)
  List<FirestoreProduct> getRecommendedProducts({int limit = 10}) {
    return _allProducts
        .where((p) => p.hasDiscount || (p.rating ?? 0) >= 4.0)
        .toList()
        .take(limit)
        .toList();
  }

  /// Get products on sale
  List<FirestoreProduct> getProductsOnSale({int limit = 20}) {
    return _allProducts
        .where((p) => p.hasDiscount)
        .toList()
        .take(limit)
        .toList();
  }

  /// Refresh products from Firestore
  Future<void> refreshProducts() async {
    _setLoading(true);
    try {
      final allProducts = await _firebaseService.getAllProducts().first;
      _updateProductsList(allProducts);
      _setLoading(false);
    } catch (e) {
      _setError('Error refreshing products: $e');
      _setLoading(false);
    }
  }

  /// Add product (admin)
  Future<String?> addProduct(Map<String, dynamic> productData) async {
    try {
      final productId = await _firebaseService.addProduct(productData);
      return productId;
    } catch (e) {
      _setError('Error adding product: $e');
      return null;
    }
  }

  /// Update product (admin)
  Future<bool> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firebaseService.updateProduct(productId, updates);
      // Update cache
      if (_productCache.containsKey(productId)) {
        final updated = _productCache[productId]!;
        // In a real app, reconstruct the product with updates
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Error updating product: $e');
      return false;
    }
  }

  /// Delete product (admin)
  Future<bool> deleteProduct(String productId) async {
    try {
      await _firebaseService.deleteProduct(productId);
      _productCache.remove(productId);
      _allProducts.removeWhere((p) => p.id == productId);
      _applyFilters();
      return true;
    } catch (e) {
      _setError('Error deleting product: $e');
      return false;
    }
  }

  /// Helper to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Helper to set error message
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset filters
  void resetFilters() {
    _selectedCategoryId = '';
    _applyFilters();
  }
}
