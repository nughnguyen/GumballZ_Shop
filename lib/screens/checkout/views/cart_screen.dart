import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/screens/checkout/views/components/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Cart",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (cartProvider.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${cartProvider.itemCount}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: blackColor20,
                  ),
                  const SizedBox(height: defaultPadding),
                  Text(
                    "Your cart is empty",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add items to your cart to get started",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: blackColor60,
                        ),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Cart items list
              ListView.builder(
                padding: const EdgeInsets.all(defaultPadding),
                itemCount: cartProvider.itemCount,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return CartItemTile(
                    item: item,
                    index: index,
                    onQuantityChanged: (newQuantity) {
                      cartProvider.updateQuantity(index, newQuantity);
                    },
                    onRemove: () {
                      cartProvider.removeFromCart(index);
                    },
                  );
                },
              ),
              // Bottom order summary
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: blackColor10,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subtotal
                        _SummaryRow(
                          label: "Subtotal",
                          value: "\u{20b1}${cartProvider.subtotal.toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 8),
                        // Discount if applicable
                        if (cartProvider.totalDiscount > 0)
                          Column(
                            children: [
                              _SummaryRow(
                                label: "Discount",
                                value:
                                    "-\u{20b1}${cartProvider.totalDiscount.toStringAsFixed(2)}",
                                valueColor: successColor,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        // Shipping (fixed or can be dynamic)
                        _SummaryRow(
                          label: "Shipping",
                          value: "\u{20b1}${(cartProvider.subtotal * 0.05).toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 12),
                        // Divider
                        Container(
                          height: 1,
                          color: blackColor10,
                        ),
                        const SizedBox(height: 12),
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              "\u{20b1}${(cartProvider.subtotal + (cartProvider.subtotal * 0.05)).toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        // Proceed to checkout button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Navigate to checkout screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Proceeding to checkout..."),
                                ),
                              );
                            },
                            child: const Text("Proceed to Checkout"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Helper widget for displaying summary rows
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: blackColor60,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
