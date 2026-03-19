# GumballZ Shop – Phase 1: Paywall Removal & Cart Redesign

Transform the Shoplon template into GumballZ Shop by permanently removing the "Get full template" paywall overlay and replacing the paywalled Cart screen with a fully functional cart UI. This is the prerequisite step before Firebase integration.

## User Review Required

> [!IMPORTANT]
> **Step-by-step approach:** Per your instruction, this plan covers **Phase 1 only** (paywall removal + cart redesign). Phases 2–5 (Firebase, Admin Dashboard, Deployment) will follow in subsequent steps after your approval.

> [!WARNING]  
> **Figma reference:** The Figma link you provided requires authentication to view (it's a private file). I will design the cart screen based on modern e-commerce best practices matching the existing app's design system (Plus Jakarta Sans font, purple primary color `#7B61FF`, rounded corners), featuring:  
> - Scrollable list of cart items with thumbnail, name, quantity stepper (+/-), price per unit & total  
> - Swipe-to-delete on items  
> - Order summary section (subtotal, shipping, total)  
> - "Proceed to Checkout" button  
> Please confirm if you can share the Figma asset images directly or describe the layout otherwise.

> [!NOTE]
> **Screens still behind paywall (intentionally kept as stubs for Phase 2):** Password Recovery, Search, Reviews, Product Details → Shipping Info panel, Orders — these will be fully replaced in Phase 2 when Firebase is wired in.

---

## Proposed Changes

### Component: Paywall Removal

#### [MODIFY] [buy_full_ui_kit.dart](file:///d:/Code%20Dev/BUYING_APP/lib/components/buy_full_ui_kit.dart)
Replace the entire [BuyFullKit](file:///d:/Code%20Dev/BUYING_APP/lib/components/buy_full_ui_kit.dart#10-18) widget with a transparent wrapper that simply shows its `child` content (or a `Scaffold` with a "Coming Soon" placeholder for screens not yet implemented). This removes all "Get full template" and "Get full code" overlays from every screen that uses it.

---

### Component: App Branding

#### [MODIFY] [main.dart](file:///d:/Code%20Dev/BUYING_APP/lib/main.dart)
- Change `title` from `'Shop Template by The Flutter Way'` → `'GumballZ Shop'`
- Change `initialRoute` to bypass onboarding and go directly to `entryPointScreenRoute` (optional, can be discussed)

#### [MODIFY] [entry_point.dart](file:///d:/Code%20Dev/BUYING_APP/lib/entry_point.dart)
- Replace the Shoplon SVG logo with a `Text` widget showing **"GumballZ"** in the `grandisExtendedFont` (already present in the project), styled with `primaryColor`

---

### Component: Cart Screen (Major Redesign)

#### [NEW] [cart_item_model.dart](file:///d:/Code%20Dev/BUYING_APP/lib/models/cart_item_model.dart)
A simple `CartItem` model:
```dart
class CartItem {
  final String id, image, brandName, title;
  int quantity;
  final double price;
  final double? priceAfterDiscount;
  // ...
}
```

#### [NEW] [cart_provider.dart](file:///d:/Code%20Dev/BUYING_APP/lib/providers/cart_provider.dart)
A `ChangeNotifier`-based `CartProvider` that manages the list of `CartItem`s (add, remove, update quantity, compute subtotal). Using `provider` package (added to pubspec).

#### [MODIFY] [cart_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/checkout/views/cart_screen.dart)
Full replacement. New layout:
- **AppBar**: "My Cart" title + item count badge
- **Body**: `ListView` of `CartItemTile` widgets (swipe-to-dismiss to remove)
- **CartItemTile**: Row with `NetworkImageWithLoader` (80×80, rounded), product name/brand, quantity stepper (−/+), and line-item price
- **Bottom Sheet / Footer** (pinned): Order summary card (Subtotal, Shipping, Discount row if coupon applied, **Total** in bold) + "Proceed to Checkout" ElevatedButton

#### [NEW] [cart_item_tile.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/checkout/views/components/cart_item_tile.dart)
Extracted widget for a single cart item row, matching the app's design system.

---

### Component: Functional Stub Screens (Phase 2 prep)

#### [MODIFY] [on_sale_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/on_sale/views/on_sale_screen.dart)
Replace [BuyFullKit](file:///d:/Code%20Dev/BUYING_APP/lib/components/buy_full_ui_kit.dart#10-18) with a scrollable `GridView` of products from `demoFlashSaleProducts` (existing demo data).

#### [MODIFY] [kids_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/kids/views/kids_screen.dart)
Replace [BuyFullKit](file:///d:/Code%20Dev/BUYING_APP/lib/components/buy_full_ui_kit.dart#10-18) with a `GridView` using `kidsProducts` data.

#### [MODIFY] [search_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/search/views/search_screen.dart)
Minimal search bar + product list stub (Phase 2 will wire Firestore).

#### [MODIFY] [orders_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/order/views/orders_screen.dart)
Simple "No orders yet" empty state screen.

#### [MODIFY] [addresses_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/address/views/addresses_screen.dart)
Simple "No saved addresses" empty state screen.

#### [MODIFY] [notificatios_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/notification/view/notificatios_screen.dart)
Simple empty notifications list.

#### [MODIFY] [notification_ontions_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/notification/view/notification_ontions_screen.dart)
Simple toggle options screen.

#### [MODIFY] [enable_notification_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/notification/view/enable_notification_screen.dart)
Simple "Enable Notifications" prompt screen.

#### [MODIFY] [no_notification_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/notification/view/no_notification_screen.dart)
Simple "No notifications" empty state.

#### [MODIFY] [password_recovery_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/auth/views/password_recovery_screen.dart)
Functional password reset form (email input + submit).

#### [MODIFY] [product_reviews_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/reviews/view/product_reviews_screen.dart)
Simple reviews list using existing `ReviewCard` component.

#### [MODIFY] [user_info_screen.dart](file:///d:/Code%20Dev/BUYING_APP/lib/screens/user_info/views/user_info_screen.dart)
Simple profile info form.

#### [MODIFY] [pubspec.yaml](file:///d:/Code%20Dev/BUYING_APP/pubspec.yaml)
Add `provider: ^6.1.2` for state management.

---

## Verification Plan

### Automated Tests
The project only has a default Flutter test scaffold ([test/widget_test.dart](file:///d:/Code%20Dev/BUYING_APP/test/widget_test.dart)). No existing meaningful tests.

```bash
# From d:\Code Dev\BUYING_APP
flutter analyze
```
This catches compile errors and lint warnings across all modified files.

### Manual Verification
After changes are applied, run the app and verify:

1. **Start app**: `flutter run` (or use VS Code/Android Studio)
2. **Paywall removed**: Navigate to every bottom nav tab and any screen — confirm NO "Get the full template" overlay appears anywhere
3. **Cart screen**: Tap the "Cart" tab (bag icon) → confirm a real cart UI loads (not a paywall screenshot)
4. **Add to cart** (Phase 1 test): Tap any product card → tap "Add to Cart" button on product details → navigate to Cart tab → confirm item appears with quantity controls
5. **Quantity stepper**: Tap + and − buttons on a cart item → confirm count changes and subtotal updates in real-time
6. **Swipe to remove**: Swipe left on a cart item → confirm item is removed and total recalculates
7. **Branding**: Confirm app title bar shows "GumballZ" instead of Shoplon logo
8. **On Sale / Kids screens**: Navigate via the router — confirm product grids show, not paywalls
