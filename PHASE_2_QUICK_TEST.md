# Phase 2 Quick Testing Checklist

**Mục tiêu**: Test Firebase integration trước Phase 3

## ⚡ Quick Start (15 phút)

### Step 1: Setup Firestore (5 min)
```
1. Vào https://console.firebase.google.com
2. Chọn gumballzshop project
3. Firestore Database → Create Database (Test Mode)
4. Copy Project ID: gumballzshop
```

### Step 2: Add Sample Categories (2 min)
```
Firebase Console → Firestore
+ Start collection
Collection ID: categories

Add 4 documents:
□ Document 1: { name: "Woman's", priority: 0 }
□ Document 2: { name: "Man's", priority: 1 }
□ Document 3: { name: "Kids", priority: 2 }
□ Document 4: { name: "Accessories", priority: 3 }

Note: Copy Document IDs - cần dùng cho products!
```

### Step 3: Add Sample Products (5 min)
```
Products collection

□ Add 3-5 products với:
  - title: Product name
  - price: 100-800
  - priceAfterDiscount: Lower than price  
  - discountPercent: auto calculate
  - categoryId: Paste ID từ categories
  - image: URL (e.g., https://i.imgur.com/...)
  - stock: 10+
```

### Step 4: Run App (3 min)
```
Terminal:
cd "d:\Code Dev\BUYING_APP"
flutter clean
flutter pub get
flutter run
```

### Step 5: Test (5 min)
```
✓ Home screen opens
✓ Products show (Firestore or demo)
✓ Prices display correctly
✓ No red errors in console
```

---

## 🧪 Full Testing (30 phút)

| Test | Status | Notes |
|------|--------|-------|
| Firebase initializes | ☐ | Check console for "Firebase initialized" |
| Products load | ☐ | Should see 3-5 products on home screen |
| Flash sale shows | ☐ | Products with discount > 20% |
| Real-time update | ☐ | Add product in Firebase → App updates |
| Categories load | ☐ | Sorted by priority in Discover screen |
| Cart works | ☐ | Can add products to cart |
| Images load | ☐ | No broken image icons |
| No console errors | ☐ | Scroll through logs |
| Smooth scrolling | ☐ | No lag when scrolling product lists |
| Search works (Phase 3) | ☐ | Search screen functional |

---

## 📍 Sample Firestore Data (Copy-Paste)

### Categories
```json
{
  "name": "Woman's",
  "icon": "Woman.svg",
  "priority": 0,
  "description": "Women's fashion"
}
```

### Products
```json
{
  "title": "Mountain Warehouse for Women",
  "brandName": "Lipsy London",
  "image": "https://i.imgur.com/CGCyp1d.png",
  "price": 540.0,
  "priceAfterDiscount": 420.0,
  "discountPercent": 20,
  "description": "Premium mountain collection",
  "categoryId": "PASTE_CATEGORY_ID_HERE",
  "stock": 50,
  "rating": 4.5,
  "reviewCount": 120
}
```

---

## 🚨 Common Issues & Fixes

| Issue | Fix |
|-------|-----|
| "Permission denied" | Firebase Console → Rules → Test Mode |
| "No products showing" | Add products to Firestore collection |
| Firebase not initializing | Check google-services.json in android/app/ |
| Images not loading | URLs must be public (imgur, Firebase Storage) |
| App crashes | Run: `flutter clean && flutter pub get` |

---

## ✅ Completion Criteria

Phase 2 PASSED when:
- [ ] 1 category collection created
- [ ] 5+ products added
- [ ] App runs without errors
- [ ] Products visible on home screen
- [ ] Real-time update works
- [ ] No permission errors

→ **When ALL checked = Phase 3 Ready!** 🚀

---

## 📊 Test Results

Date: ______
Device: ______
Passed: ☐ YES ☐ NO

**Issues found**:
```

```

**Ready for Phase 3**? ☐ YES - Start web admin dashboard
                     ☐ NO - Fix issues above first
