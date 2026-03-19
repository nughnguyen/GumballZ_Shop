# GumballZ Shop - Phase 2 Testing Guide

## 🧪 Phase 2: Firebase Integration Testing

Complete guide để test Firestore integration trước Phase 3.

---

## 📋 Testing Checklist

### 1. **Firebase Setup** ✓
- [ ] Firebase Project created (gumballzshop)
- [ ] Firestore Database enabled (Test Mode)
- [ ] google-services.json in `android/app/`
- [ ] API keys configured in firebase_options.dart

### 2. **Add Sample Data to Firestore**
- [ ] Create "categories" collection
- [ ] Create "products" collection  
- [ ] Add 5+ sample products with discounts
- [ ] Verify data in Firebase Console

### 3. **Run the App**
- [ ] `flutter pub get` - Download dependencies
- [ ] `flutter run` - Start app
- [ ] Check for Firebase initialization logs

### 4. **Test Product Display**
- [ ] Home screen shows products
- [ ] Products from Firestore or demo data fallback
- [ ] Product images load correctly
- [ ] Prices and discounts display

### 5. **Test Real-Time Updates**
- [ ] Add product in Firebase Console
- [ ] Watch app update automatically (no restart needed)
- [ ] Update product price
- [ ] Delete product

### 6. **Test Providers**
- [ ] ProductProvider loads products
- [ ] CategoryProvider loads categories
- [ ] Cart persists to Firestore (Phase 2 feature)
- [ ] Search functionality works

### 7. **Performance Check**
- [ ] No lag when loading products
- [ ] Smooth scrolling in product lists
- [ ] Cache reduces database queries

---

## 🔥 Bước 1: Chuẩn Bị Firebase

### A. Firebase Console Setup

```
1. Vào: https://console.firebase.google.com
2. Chọn project: gumballzshop
3. Firestore Database → Create Database
   - Start in Test Mode (cho testing)
   - Location: us-central1
4. Lưu Project ID: gumballzshop
```

### B. Download Google Services File

**For Android**:
```
1. Firebase Console → Settings (gear icon)
2. Go to "Service Accounts" tab
3. Click "Generate new private key" → google-services.json
4. Copy to: d:\Code Dev\BUYING_APP\android\app\google-services.json
```

**For iOS** (nếu cần test trên iOS):
```
1. Firebase Console → Settings
2. Download GoogleService-Info.plist
3. Thêm vào iOS project bằng Xcode
```

---

## 📊 Bước 2: Thêm Sample Data

### A. Create "categories" Collection

Trong Firebase Console → Firestore:

```
1. Click "+ Start collection"
2. Collection ID: categories
3. Add Documents:

Document 1 (tự động ID):
{
  "name": "Woman's",
  "icon": "assets/icons/Woman.svg",
  "priority": 0,
  "description": "Women's fashion and clothing",
  "createdAt": (Server timestamp),
  "updatedAt": (Server timestamp)
}

Document 2:
{
  "name": "Man's",
  "icon": "assets/icons/Man.svg",
  "priority": 1,
  "description": "Men's fashion and clothing",
  "createdAt": (Server timestamp)
}

Document 3:
{
  "name": "Kids",
  "icon": "assets/icons/Child.svg",
  "priority": 2,
  "description": "Kids' clothing and accessories",
  "createdAt": (Server timestamp)
}

Document 4:
{
  "name": "Accessories",
  "icon": "assets/icons/Accessories.svg",
  "priority": 3,
  "description": "Fashion accessories",
  "createdAt": (Server timestamp)
}
```

### B. Create "products" Collection

```
Collection ID: products

Document 1:
{
  "title": "Mountain Warehouse for Women",
  "brandName": "Lipsy London",
  "image": "https://i.imgur.com/CGCyp1d.png",
  "gallery": [
    "https://i.imgur.com/CGCyp1d.png",
    "https://i.imgur.com/5M89G2P.png"
  ],
  "price": 540.0,
  "priceAfterDiscount": 420.0,
  "discountPercent": 20,
  "description": "Premium mountain warehouse collection for women",
  "categoryId": "WOMAN_CATEGORY_ID",  // Copy ID từ woman's document
  "stock": 50,
  "rating": 4.5,
  "reviewCount": 120,
  "createdAt": (Server timestamp),
  "updatedAt": (Server timestamp)
}

Document 2:
{
  "title": "FS - Nike Air Max 270",
  "brandName": "Nike",
  "image": "https://i.imgur.com/MsppAcx.png",
  "price": 650.62,
  "priceAfterDiscount": 390.36,
  "discountPercent": 40,
  "description": "Nike Air Max 270 Really React",
  "categoryId": "MAN_CATEGORY_ID",
  "stock": 30,
  "rating": 4.8,
  "reviewCount": 250,
  "createdAt": (Server timestamp)
}

Document 3:
{
  "title": "Green Poplin Ruched Front",
  "brandName": "Lipsy London",
  "image": "https://i.imgur.com/h2LqppX.png",
  "price": 1264.0,
  "priceAfterDiscount": 1200.8,
  "discountPercent": 5,
  "description": "Elegant green poplin dress",
  "categoryId": "WOMAN_CATEGORY_ID",
  "stock": 15,
  "rating": 4.3,
  "reviewCount": 85,
  "createdAt": (Server timestamp)
}

Document 4:
{
  "title": "White Satin Corset Top",
  "brandName": "Lipsy London",
  "image": "https://i.imgur.com/tXyOMMG.png",
  "price": 450.0,
  "priceAfterDiscount": 350.0,
  "discountPercent": 22,
  "description": "Stylish white satin corset",
  "categoryId": "WOMAN_CATEGORY_ID",
  "stock": 25,
  "rating": 4.6,
  "reviewCount": 180,
  "createdAt": (Server timestamp)
}

Document 5:
{
  "title": "Kids Adventure Jacket",
  "brandName": "Adventure Kids",
  "image": "https://i.imgur.com/Lp0D6k5.png",
  "price": 299.99,
  "priceAfterDiscount": 239.99,
  "discountPercent": 20,
  "description": "Waterproof jacket for kids",
  "categoryId": "KIDS_CATEGORY_ID",
  "stock": 40,
  "rating": 4.7,
  "reviewCount": 130,
  "createdAt": (Server timestamp)
}

Document 6 (Flash Sale):
{
  "title": "Super Discount Blazer",
  "brandName": "Premium Brand",
  "image": "https://i.imgur.com/3mSE5sN.png",
  "price": 800.0,
  "priceAfterDiscount": 320.0,
  "discountPercent": 60,
  "description": "Professional blazer with huge discount",
  "categoryId": "MAN_CATEGORY_ID",
  "stock": 20,
  "rating": 4.9,
  "reviewCount": 200,
  "createdAt": (Server timestamp)
}
```

### ⚠️ Important: Lấy Category IDs

```
1. Vào Firestore Console → categories collection
2. Click vào từng document xem "Document ID"
3. Copy Document ID → Paste vào "categoryId" trong products

Ví dụ:
- Document ID của "Woman's": abc123xyz
- Dùng abc123xyz cho categoryId trong women products
```

---

## 🚀 Bước 3: Chạy Ứng Dụng

### A. Install Dependencies

```bash
cd "d:\Code Dev\BUYING_APP"
flutter clean
flutter pub get
```

### B. Run on Android

```bash
# Kết nối device hoặc emulator
flutter devices

# Run app
flutter run

# Hoặc chạy trên specific device
flutter run -d <device_id>
```

### C. Expected Console Output

```
✓ Firebase initialized successfully
✓ Products stream initialized
✓ Categories stream initialized
✓ App running on device
```

---

## ✅ Bước 4: Test Scenarios

### Test 1: Products Load from Firestore

**Steps**:
1. Open home screen
2. Scroll to "Popular products" section
3. ✓ Products từ Firestore hiển thị OR demo data fallback

**Expected Result**:
- Nhìn thấy product cards với image, name, price, discount
- Nếu không có Firestore data → demo products hiển thị

### Test 2: Flash Sale Section

**Steps**:
1. Scroll down to "Flash sale" section
2. Chờ 2-3 giây để load
3. Nhìn thấy products với discount > 20%

**Expected Result**:
- Flash sale products hiển thị
- Discount percentage badge in top-right corner
- Discounted price in red/bold

### Test 3: Real-Time Updates (Important!)

**Steps**:
1. App đang chạy
2. Open Firebase Console → products
3. Add new product hoặc change price
4. Watch app update WITHOUT restart

**Expected Result**:
- App tự động update
- Product list thay đổi ngay lập tức
- NO LAG, smooth transition

### Test 4: Category Filtering (Future Phase)

**Steps**:
1. Discover screen
2. Tap category
3. Products filtered by category

**Expected Result**:
- Only products từ selected category hiển thị
- Categories sorted by priority (0, 1, 2, 3...)

### Test 5: Cart Persistence (Phase 2)

**Steps**:
1. Add products to cart
2. Click "Proceed to Checkout"
3. Cart persists (refresh app, cart still there)

**Expected Result**:
- Cart saved to Firestore
- Reload app → cart data restored

### Test 6: Search (Phase 3)

**Steps**:
1. Go to Search screen
2. Type product name
3. Results from Firestore

**Expected Result**:
- Search results show matching products
- Real-time search as you type

---

## 🐛 Troubleshooting

### Error: "Firebase not initialized"

**Solution**:
```
1. Check google-services.json in android/app/
2. Verify package name matches in Firebase Console
3. Run: flutter clean && flutter pub get
4. Restart app
```

### Error: "Permission denied" (Firestore)

**Solution**:
```
1. Firebase Console → Firestore → Rules
2. Switch from Test Mode to Production (temporarily)
3. Or use test mode rules:
   
match /databases/{database}/documents {
  match /{document=**} {
    allow read, write: if true;  // Test mode only!
  }
}
```

### Products Not Loading (Demo Fallback Showing)

**This is NORMAL** - Có 2 trường hợp:
1. Firestore still loading → chờ 2-3 giây
2. No data in Firestore → thêm sample data (bước 2)
3. Demo fallback working → OK, app vẫn hoạt động

### No Images Loading

**Solution**:
```
1. Check image URLs in Firestore (phải là public URLs)
2. Use: https://i.imgur.com/ or Firebase Storage
3. NOT local paths like assets/images/
4. Verify URL valid by opening in browser
```

---

## 📊 Performance Testing

### 1. Check Firebase Calls

```
1. Open DevTools (Chrome)
2. Network tab
3. Add/update product in Firestore
4. Watch Firestore API calls in Network tab
```

### 2. Monitor Cache

```
ProductProvider:
- First load: Queries Firestore
- Subsequent loads: Uses _productCache (in-memory)
- Search: Cache + Firestore query
```

### 3. Load Time Test

```
Ideal times:
- First load: 1-2 seconds
- Cached load: < 100ms
- Real-time update: < 500ms
```

---

## ✨ Success Criteria

✅ **Phase 2 Testing Passed When**:

1. Firebase initialized successfully
2. Products load from Firestore (or demo fallback)
3. Price and discount display correctly
4. Real-time updates work (no app restart needed)
5. No console errors
6. App runs smoothly on device
7. Images load properly
8. Categories sorted by priority
9. Cart can be added to (Phase 1 feature)
10. No permission/security errors

---

## 🎯 Phase 2 Complete Success = Ready for Phase 3!

Once all tests pass:
- Firestore backend is working ✓
- Real-time streams operational ✓
- Providers properly integrated ✓
- Ready for Web Admin Dashboard (Phase 3) ✓

---

## 📱 Test Device Requirements

**Minimum**:
- Android 5.0+
- 50MB free space
- Internet connection
- Google Play Services (for Android)

**Recommended**:
- Android 10+
- 100MB free space
- WiFi connection
- Physical device or good emulator

---

## 📝 Test Report Template

Copy vào file `TEST_REPORT.md`:

```markdown
# Phase 2 Test Report

**Date**: March 19, 2026
**Tester**: [Your Name]
**Device**: [Device/Emulator]
**OS**: [Android/iOS]

## Firebase Setup
- [ ] google-services.json configured
- [ ] Firestore Database enabled
- [ ] Test data added

## Product Loading
- [ ] Firestore products load
- [ ] Demo fallback works
- [ ] Images display
- [ ] Prices correct

## Real-Time Updates
- [ ] Product added → App updates
- [ ] Price changed → App updates
- [ ] Product deleted → App updates
- [ ] No restart needed

## Performance
- [ ] First load: ___ seconds
- [ ] Scrolling: Smooth / Laggy
- [ ] Real-time update: ___ ms
- [ ] No memory leaks

## Errors Encountered
- [ ] None
- [ ] List:
  1. 
  2. 

## Overall Status
- [ ] PASSED - Phase 3 ready
- [ ] FAILED - Needs fixes
```

---

## 🤝 Need Help?

If tests fail:
1. Check console for error messages
2. Look at Firebase Console logs
3. Verify Firestore data structure
4. Check google-services.json
5. Test on real device (not just emulator)

Good luck with testing! Once Phase 2 passes, Phase 3 (Web Admin Dashboard) is next! 🚀
