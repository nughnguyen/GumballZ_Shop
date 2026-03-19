import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _adminUser;
  bool _isAdmin = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _adminRole;
  List<String>? _adminPermissions;

  // Getters
  User? get adminUser => _adminUser;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get adminRole => _adminRole;
  List<String>? get adminPermissions => _adminPermissions;
  bool get isAuthenticated => _adminUser != null && _isAdmin;

  // Check if admin is logged in
  Future<void> checkAdminStatus() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      bool isAdminUser = await _checkAdminInFirestore(currentUser.email ?? '');
      if (isAdminUser) {
        _adminUser = currentUser;
        _isAdmin = true;
        await _loadAdminData(currentUser.email ?? '');
      } else {
        await _auth.signOut();
        _adminUser = null;
        _isAdmin = false;
      }
    }
    notifyListeners();
  }

  // Admin login
  Future<bool> loginAdmin(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Check if user is admin
      bool isAdminUser = await _checkAdminInFirestore(email);

      if (!isAdminUser) {
        // Not an admin, sign out
        await _auth.signOut();
        _errorMessage = 'User is not an admin';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _adminUser = userCredential.user;
      _isAdmin = true;

      // Load admin data (role, permissions)
      await _loadAdminData(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      _adminUser = null;
      _isAdmin = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      _adminUser = null;
      _isAdmin = false;
      notifyListeners();
      return false;
    }
  }

  // Check if user exists in admins collection
  Future<bool> _checkAdminInFirestore(String email) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('admins').doc(email).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Load admin data (role, permissions, etc)
  Future<void> _loadAdminData(String email) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('admins').doc(email).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _adminRole = data['role'] as String?;
        _adminPermissions =
            List<String>.from(data['permissions'] as List? ?? []);

        // Update last login
        await _firestore.collection('admins').doc(email).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error loading admin data: $e');
    }
  }

  // Logout admin
  Future<void> logoutAdmin() async {
    try {
      await _auth.signOut();
      _adminUser = null;
      _isAdmin = false;
      _adminRole = null;
      _adminPermissions = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      notifyListeners();
    }
  }

  // Create new admin user (super admin only)
  Future<bool> createAdminUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required List<String> permissions,
  }) async {
    try {
      if (!_adminUser!.email!.endsWith('@gumballz.shop')) {
        _errorMessage = 'Only gumballz admins can create new admins';
        notifyListeners();
        return false;
      }

      // Create auth user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save admin data to Firestore
      await _firestore.collection('admins').doc(email).set({
        'email': email,
        'name': name,
        'role': role,
        'permissions': permissions,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': _adminUser!.email,
        'lastLogin': null,
      });

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error creating admin user: $e';
      notifyListeners();
      return false;
    }
  }

  // Check if admin has specific permission
  bool hasPermission(String permission) {
    return _adminPermissions?.contains(permission) ?? false;
  }

  // Check if admin is super admin
  bool isSuperAdmin() {
    return _adminRole == 'super_admin';
  }

  // Get error message from Firebase error code
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Admin account not found';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'Admin account is disabled';
      case 'too-many-requests':
        return 'Too many login attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Login is disabled';
      default:
        return 'Login failed: $code';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
