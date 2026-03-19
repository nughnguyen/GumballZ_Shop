# Firestore Database Schema - GumballZ Shop

This document outlines the Firestore database structure required for GumballZ Shop.

## Collections Overview

### 1. `products` Collection

**Purpose**: Store all product information

**Document Structure**:
```json
{
  "id": "doc_id",
  "title": "Product Name",
  "brandName": "Brand",
  "image": "https://cdn.example.com/product1.jpg",
  "gallery": [
    "https://cdn.example.com/product1-1.jpg",
    "https://cdn.example.com/product1-2.jpg"
  ],
  "price": 99.99,
  "priceAfterDiscount": 79.99,
  "discountPercent": 20,
  "description": "Detailed product description",
  "categoryId": "category_doc_id",
  "stock": 50,
  "rating": 4.5,
  "reviewCount": 120,
  "createdAt": "2024-03-19T10:00:00Z",
  "updatedAt": "2024-03-19T15:30:00Z"
}
```

**Indexes Required**:
- `categoryId` (Ascending)
- `discount` (Descending) 
- `createdAt` (Descending)
- `rating` (Descending)

---

### 2. `categories` Collection

**Purpose**: Store product categories with priority ordering

**Document Structure**:
```json
{
  "id": "doc_id",
  "name": "Women's Clothing",
  "icon": "assets/icons/Woman.svg",
  "image": "https://cdn.example.com/category-women.jpg",
  "priority": 1,
  "description": "Women's fashion and clothing items",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-03-19T00:00:00Z"
}
```

**Query**: Ordered by `priority` ascending

**Sample Data**:
```
1. "Woman's" - priority: 0
2. "Man's" - priority: 1
3. "Kids" - priority: 2
4. "Accessories" - priority: 3
```

---

### 3. `users/{userId}` Document

**Purpose**: Store user-specific data (cart, addresses, preferences)

**Structure**:
```json
{
  "email": "user@example.com",
  "displayName": "John Doe",
  "phoneNumber": "+1234567890",
  "profileImage": "https://cdn.example.com/user-profile.jpg",
  "cart": [
    {
      "productId": "product_id",
      "quantity": 2,
      "priceAtTime": 79.99
    }
  ],
  "addresses": [
    {
      "id": "address_id",
      "label": "Home",
      "street": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "country": "USA",
      "isDefault": true
    }
  ],
  "createdAt": "2024-01-15T12:00:00Z",
  "updatedAt": "2024-03-19T10:30:00Z"
}
```

### 4. `users/{userId}/favorites` Subcollection

**Purpose**: Store user's favorite/bookmarked products

**Document Structure**:
```json
{
  "productId": {
    "addedAt": "2024-03-19T10:00:00Z"
  }
}
```

---

### 5. `orders` Collection

**Purpose**: Store all customer orders

**Document Structure**:
```json
{
  "id": "doc_id",
  "userId": "user_doc_id",
  "items": [
    {
      "productId": "product_id",
      "title": "Product Name",
      "price": 79.99,
      "quantity": 2,
      "image": "https://cdn.example.com/product.jpg"
    }
  ],
  "subtotal": 159.98,
  "shipping": 10.00,
  "discount": 20.00,
  "total": 149.98,
  "status": "pending",
  "promoCode": "SAVE20",
  "shippingAddress": {
    "street": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001"
  },
  "paymentMethod": "card",
  "trackingNumber": "TRACK123456",
  "createdAt": "2024-03-19T14:00:00Z",
  "updatedAt": "2024-03-19T14:05:00Z"
}
```

**Indexes Required**:
- `userId` (Ascending)
- `createdAt` (Descending)
- `status` (Ascending)

---

### 6. `promoCodes` Collection

**Purpose**: Store promotional codes for discounts

**Document Structure**:
```json
{
  "id": "SAVE20",
  "code": "SAVE20",
  "description": "Save 20% on orders over $100",
  "discountType": "percentage",
  "discountValue": 20,
  "minOrderAmount": 100,
  "maxUsageCount": 100,
  "currentUsageCount": 45,
  "startDate": "2024-03-01T00:00:00Z",
  "expiryDate": "2024-04-30T23:59:59Z",
  "isActive": true,
  "createdAt": "2024-02-20T10:00:00Z"
}
```

---

### 7. `reviews` Collection

**Purpose**: Store product reviews (Optional - for Phase 3)

**Document Structure**:
```json
{
  "id": "doc_id",
  "productId": "product_id",
  "userId": "user_id",
  "rating": 5,
  "title": "Great product!",
  "comment": "Excellent quality and fast shipping",
  "images": ["url1", "url2"],
  "helpful": 15,
  "unhelpful": 2,
  "createdAt": "2024-03-15T12:00:00Z"
}
```

---

## Security Rules (Firestore)

Recommended security rules for production:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Public read access to products and categories
    match /products/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid != null && hasRole('admin');
    }
    
    match /categories/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid != null && hasRole('admin');
    }
    
    // User-specific data
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      
      match /favorites/{document=**} {
        allow read, write: if request.auth.uid == userId;
      }
    }
    
    // Orders - users can read/write their own orders
    match /orders/{orderId} {
      allow read: if request.auth.uid == resource.data.userId;
      allow create: if request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth.uid == resource.data.userId && hasRole('admin');
    }
    
    // Helper function to check user roles
    function hasRole(role) {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == role;
    }
  }
}
```

---

## Initialization Script (Cloud Functions or Manual)

To initialize Firestore with sample data:

```dart
// Add this to a Firebase Cloud Function or run manually
Future<void> initializeSampleData() async {
  final db = FirebaseFirestore.instance;
  
  // Add sample categories
  await db.collection('categories').add({
    'name': "Woman's",
    'icon': 'assets/icons/Woman.svg',
    'priority': 0,
    'createdAt': FieldValue.serverTimestamp(),
  });
  
  // Add sample products
  await db.collection('products').add({
    'title': 'Mountain Warehouse for Women',
    'brandName': 'Lipsy london',
    'image': 'https://i.imgur.com/CGCyp1d.png',
    'price': 540,
    'priceAfterDiscount': 420,
    'discountPercent': 20,
    'categoryId': 'category_id_here',
    'stock': 50,
    'rating': 4.5,
    'reviewCount': 120,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
```

---

## Indexing Strategy

Create the following Firestore indexes for optimal performance:

1. **Products by Category**: `categoryId` + `createdAt` (desc)
2. **Flash Sales**: `discountPercent` (desc) + `stock` (asc)
3. **User Orders**: `userId` + `createdAt` (desc)
4. **Active Promo Codes**: `isActive` + `expiryDate` (asc)

---

## Data Migration

To migrate existing demo data to Firestore:

1. Export products from `product_model.dart`
2. Map demo data to Firestore schema
3. Use Firebase Console bulk import or write a migration script
4. Verify data integrity

---

## Notes

- All timestamps use `FieldValue.serverTimestamp()` for consistency
- Images should be hosted on Firebase Storage or CDN
- Product IDs should be auto-generated by Firestore
- Regular backups recommended for production
- Enable Firestore emulator for local development testing
