# GumballZ Shop - Phase 3: Web Admin Dashboard

## 📊 Phase 3 Overview

Build a **Flutter Web Admin Dashboard** to manage products, categories, orders, and promo codes.

---

## 🏗️ Phase 3 Architecture

### Why Flutter Web for Admin?
- ✅ Same codebase as mobile app
- ✅ Share models, providers, Firebase services
- ✅ Faster development
- ✅ Responsive design (web-friendly)
- ✅ No separate JavaScript learning needed

### Tech Stack
```
Frontend:     Flutter Web (Dart)
State Mgmt:   Provider
Backend:      Firebase/Firestore
Auth:         Firebase Auth with admin role
Hosting:      Firebase Hosting or Vercel
```

### Project Structure
```
lib/
  admin/                          # NEW: Admin-specific code
    screens/
      admin_dashboard.dart        # Main admin screen
      products/
        admin_products_screen.dart
        admin_product_form.dart
      categories/
        admin_categories_screen.dart
        admin_category_form.dart
      orders/
        admin_orders_screen.dart
        order_details.dart
      promo_codes/
        admin_promo_screen.dart
        promo_code_form.dart
    widgets/
      admin_app_bar.dart
      sidebar_navigation.dart
      data_table_components.dart
  services/
    admin_service.dart            # Admin-specific Firestore ops
  providers/
    admin_auth_provider.dart      # Admin authentication
```

---

## 🔐 Phase 3A: Admin Authentication

### Firebase Setup
```
1. Firebase Console → Authentication
2. Enable Email/Password authentication
3. Create admin user: admin@gumballz.shop / password
4. Firestore → admins collection
5. Add document with admin users list
```

### Firestore: admins Collection
```
Collection: admins

Document: admin@gumballz.shop
{
  "email": "admin@gumballz.shop",
  "name": "Admin User",
  "role": "super_admin",
  "permissions": [
    "manage_products",
    "manage_categories",
    "manage_orders",
    "manage_promos",
    "view_analytics"
  ],
  "createdAt": timestamp,
  "lastLogin": timestamp
}
```

### Admin Provider (State Management)
```dart
class AdminAuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _adminUser;
  bool _isAdmin = false;
  
  Future<bool> loginAdmin(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Check if user is admin in Firestore
      _adminUser = result.user;
      bool isAdmin = await _checkAdminStatus(email);
      _isAdmin = isAdmin;
      notifyListeners();
      return isAdmin;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> _checkAdminStatus(String email) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('admins')
      .doc(email)
      .get();
    return doc.exists;
  }
  
  Future<void> logoutAdmin() async {
    await _auth.signOut();
    _adminUser = null;
    _isAdmin = false;
    notifyListeners();
  }
}
```

---

## 📦 Phase 3B: Product Management

### Admin Products Screen
```
Features:
- Data table showing all products
- Columns: ID, Name, Price, Stock, Discount, Actions
- Add Product button
- Edit button (per row)
- Delete button (per row)
- Search/Filter products
- Sort by price, stock, discount
```

### Add/Edit Product Form
```
Fields:
- Title (text)
- Brand Name (text)
- Category (dropdown from categories)
- Price (number)
- Price After Discount (auto-calc)
- Discount Percent (number)
- Description (multiline text)
- Stock (number)
- Image URL (text + preview)
- Gallery URLs (list)
- Rating (number 0-5)

Actions:
- Save Product
- Delete Product
- Cancel
```

### Product Operations (firebase_service.dart extension)
```dart
// Create product
Future<void> createAdminProduct(Map<String, dynamic> data) async {
  await _firestore
    .collection('products')
    .add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
}

// Update product
Future<void> updateAdminProduct(String id, Map<String, dynamic> data) async {
  await _firestore
    .collection('products')
    .doc(id)
    .update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
}

// Delete product
Future<void> deleteAdminProduct(String id) async {
  await _firestore.collection('products').doc(id).delete();
}
```

---

## 🏷️ Phase 3C: Category Management

### Admin Categories Screen
```
Features:
- Data table: ID, Name, Priority, Description, Actions
- Add Category button
- Edit button
- Delete button
- Reorder by priority
- Icon selector
```

### Add/Edit Category Form
```
Fields:
- Name (text)
- Icon Path (SVG file selector)
- Priority (number - 0, 1, 2, 3, etc)
- Description (text)

Note: Priority ordering is crucial!
Lower priority = appears first
```

### Category Priority Management
```
Current priority order:
0 = Woman's (appears first)
1 = Man's
2 = Kids
3 = Accessories

Admin can reorder by changing priority numbers
```

---

## 📋 Phase 3D: Order Management

### Admin Orders Screen
```
Features:
- Data table: Order ID, Customer, Status, Total, Date, Actions
- Status filter: All, Pending, Shipped, Delivered, Cancelled
- View Order Details button
- Update Status button
- Export orders CSV (future)

Columns:
- Order ID
- Customer Email
- Status (badge: red/yellow/green)
- Total Price
- Items Count
- Created Date
- Actions (View, Update)
```

### Order Details Screen
```
Shows:
- Customer info (email, name)
- Order items (product name, qty, price)
- Order total (subtotal, shipping, discount)
- Order status timeline
- Actions: Mark as Shipped, Mark as Delivered, Cancel
```

### Order Status Flow
```
Pending → Shipped → Delivered → Completed
                  ↓
              Cancelled
```

---

## 🎟️ Phase 3E: Promo Code Management

### Admin Promo Codes Screen
```
Features:
- Data table: Code, Discount, Expiry, Used, Status, Actions
- Add Code button
- Edit button
- Delete button
- Deactivate/Activate toggle

Columns:
- Code (e.g., SUMMER20)
- Discount Type (percent/fixed)
- Discount Value
- Expiry Date
- Times Used
- Max Uses
- Active (toggle)
- Actions
```

### Add/Edit Promo Code Form
```
Fields:
- Code (text, uppercase auto)
- Discount Type (dropdown: percent, fixed amount)
- Discount Value (number)
- Expiry Date (date picker)
- Max Uses (number, -1 for unlimited)
- Min Order Amount (optional)
- Applicable Categories (multi-select)

Rules:
- Can't use expired codes
- Max uses enforced
- Min order amount validated
```

### Promo Code Firestore Structure
```
Collection: promoCodes

Document: SUMMER20
{
  "code": "SUMMER20",
  "discountType": "percent",  // or "fixed"
  "discountValue": 20,
  "expiryDate": timestamp,
  "maxUses": 100,
  "timesUsed": 15,
  "minOrderAmount": 500,
  "applicableCategories": ["woman", "man"],
  "isActive": true,
  "createdAt": timestamp,
  "createdBy": "admin@gumballz.shop"
}
```

---

## 🎨 Phase 3F: Web UI Components

### Admin App Shell
```
    ┌─────────────────────────────────────┐
    │  GumballZ Admin Dashboard           │ (App Bar)
    ├──────────────┬──────────────────────┤
    │              │                      │
    │  Sidebar     │   Main Content       │
    │              │                      │
    │  • Dashboard │                      │ (Responsive)
    │  • Products  │                      │
    │  • Category  │                      │
    │  • Orders    │                      │
    │  • Promos    │                      │
    │  • Logout    │                      │
    │              │                      │
    └──────────────┴──────────────────────┘
```

### Sidebar Navigation
```dart
Sidebar shows:
- Logo/Brand
- Navigation items (with icons)
- Current route highlight
- Logout button
- User email display
```

### Data Table Component
```
Generic admin_data_table.dart:
- Customizable columns
- Built-in pagination
- Sort by column
- Row actions (edit/delete)
- Search/filter
- Responsive (scrollable on mobile web)
```

---

## 🚀 Implementation Order

### Week 1: Core Setup
1. Create admin folder structure
2. Admin authentication (Firebase Auth)
3. Admin app shell layout
4. Sidebar navigation
5. Admin dashboard home screen

### Week 2: Product Management  
6. Admin products list screen
7. Add product form
8. Edit product form
9. Delete product functionality
10. Product search/filter

### Week 3: Other Management
11. Category management
12. Order management
13. Promo code management
14. Admin analytics dashboard (optional)

### Week 4: Deployment
15. Web deployment (Firebase Hosting)
16. APK build
17. IPA build
18. Testing

---

## 🔧 Setup &  build web

### Enable Flutter Web
```bash
cd "d:\Code Dev\BUYING_APP"
flutter config --enable-web
```

### Create Web Entry Point
```
web/
  index.html          (already exists)
  main.dart          → web/main.dart (needs config)
```

### Update main.dart for Web Detection
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Web-specific config
  if (kIsWeb) {
    // Web-only initialization
  }
  
  await initializeFirebase();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
    ],
    child: const MyApp(),
  ));
}
```

### Build for Web
```bash
flutter build web --release
```

Output: `build/web/` (deploy to Firebase Hosting or Vercel)

---

## 📱 Build Mobile APK

### Build APK (Android)
```bash
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build IPA (iOS)
```bash
flutter build ios --release

# Output: build/ios/ipa/
# Then upload to App Store using Xcode
```

---

## 🐆 Firestore Security Rules (Admin Only)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Admin-only collections
    match /admins/{document=**} {
      allow read, write: if request.auth.uid != null && 
                           request.auth.token.email in 
                           get(/databases/$(database)/documents/admins/emails).data.emails;
      allow read, write: if false;  // Default deny
    }
    
    // Products: Read for all, Write for admins only
    match /products/{document=**} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Categories: Read for all, Write for admins
    match /categories/{document=**} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Orders: Read own orders, Admin full access
    match /orders/{document=**} {
      allow read: if isAdmin() || resource.data.userId == request.auth.uid;
      allow write: if isAdmin();
    }
    
    // Helper function
    function isAdmin() {
      return request.auth.token.email in 
             get(/databases/$(database)/documents/admin_emails).data.emails;
    }
  }
}
```

---

## 📋 Phase 3 Checklist

### Setup
- [ ] Flutter web enabled
- [ ] Admin folder structure created
- [ ] Firebase Auth configured
- [ ] Admin user created (admin@gumballz.shop)
- [ ] firestore_models.dart updated with admin models

### Authentication
- [ ] AdminAuthProvider created
- [ ] Login screen functional
- [ ] Admin role validation working
- [ ] Logout functionality

### Product Management
- [ ] Admin products list screen
- [ ] Add product form
- [ ] Edit product functionality
- [ ] Delete product functionality
- [ ] Product search working

### Category Management
- [ ] Category list screen
- [ ] Add category form
- [ ] Edit category functionality
- [ ] Priority reordering
- [ ] Delete category

### Order Management
- [ ] Orders list screen
- [ ] Order details screen
- [ ] Status update functionality
- [ ] Order filtering by status

### Promo Management
- [ ] Promo codes list
- [ ] Add promo form
- [ ] Edit promo functionality
- [ ] Delete/deactivate promo

### Deployment
- [ ] Web deployment prepared
- [ ] APK built and tested
- [ ] IPA built for iOS
- [ ] Security rules updated
- [ ] Admin dashboard live

---

## 🎯 Success Criteria

Phase 3 Complete when:
✅ Admin can login to dashboard
✅ Can CRUD products
✅ Can CRUD categories
✅ Can manage orders
✅ Can manage promo codes
✅ Web admin dashboard deployed
✅ Mobile APK built
✅ iOS IPA built
✅ No Firebase permission errors
✅ All data syncs in real-time

---

## 📝 Next Steps

1. Proceed with Phase 3A: Admin Authentication
2. Create AdminAuthProvider
3. Build login/logout screens
4. Then: Product management (Phase 3B)

Ready to start Phase 3! 🚀
