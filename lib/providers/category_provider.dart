import 'package:flutter/foundation.dart';
import 'package:shop/models/firestore_models.dart';
import 'package:shop/services/firebase_service.dart';

/// Provider for managing category data from Firestore
class CategoryProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<FirestoreCategory> _categories = [];
  Map<String, FirestoreCategory> _categoryCache = {};

  bool _isLoading = false;
  String? _error;

  // Getters
  List<FirestoreCategory> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize and subscribe to categories stream
  void initializeCategoryStream() {
    _firebaseService.getCategories().listen(
      (categoriesData) {
        _updateCategoriesList(categoriesData);
      },
      onError: (e) {
        _setError('Error loading categories: $e');
      },
    );
  }

  /// Update categories list
  void _updateCategoriesList(List<Map<String, dynamic>> categories) {
    _setLoading(true);
    _categories = categories
        .map((json) => FirestoreCategory.fromJson(json, json['id']))
        .toList();
    _cacheCategories(_categories);
    _setLoading(false);
  }

  /// Cache categories for quick lookup
  void _cacheCategories(List<FirestoreCategory> categories) {
    for (var category in categories) {
      _categoryCache[category.id] = category;
    }
  }

  /// Get category by ID
  FirestoreCategory? getCategoryById(String categoryId) {
    return _categoryCache[categoryId];
  }

  /// Get all categories sorted by priority
  List<FirestoreCategory> getSortedCategories() {
    final sorted = List<FirestoreCategory>.from(_categories);
    sorted.sort((a, b) => a.priority.compareTo(b.priority));
    return sorted;
  }

  /// Add category (admin)
  Future<String?> addCategory(Map<String, dynamic> categoryData) async {
    try {
      _setLoading(true);
      final json = await _firebaseService.firestore.collection('categories').add(
        categoryData,
      );
      _setLoading(false);
      return json.id;
    } catch (e) {
      _setError('Error adding category: $e');
      _setLoading(false);
      return null;
    }
  }

  /// Update category (admin)
  Future<bool> updateCategory(
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    try {
      _setLoading(true);
      await _firebaseService.firestore
          .collection('categories')
          .doc(categoryId)
          .update(updates);
      // Update cache
      if (_categoryCache.containsKey(categoryId)) {
        final updated = _categoryCache[categoryId]!;
        _categoryCache[categoryId] = FirestoreCategory(
          id: updated.id,
          name: updates['name'] ?? updated.name,
          icon: updates['icon'] ?? updated.icon,
          image: updates['image'] ?? updated.image,
          priority: updates['priority'] ?? updated.priority,
          description: updates['description'] ?? updated.description,
          createdAt: updated.createdAt,
          updatedAt: DateTime.now(),
        );
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error updating category: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Delete category (admin)
  Future<bool> deleteCategory(String categoryId) async {
    try {
      _setLoading(true);
      await _firebaseService.firestore
          .collection('categories')
          .doc(categoryId)
          .delete();
      _categoryCache.remove(categoryId);
      _categories.removeWhere((c) => c.id == categoryId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error deleting category: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Refresh categories from Firestore
  Future<void> refreshCategories() async {
    _setLoading(true);
    try {
      final categories = await _firebaseService.getCategories().first;
      _updateCategoriesList(categories);
      _setLoading(false);
    } catch (e) {
      _setError('Error refreshing categories: $e');
      _setLoading(false);
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
}
