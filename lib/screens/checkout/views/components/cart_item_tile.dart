import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/cart_item_model.dart';

/// A single cart item tile showing product image, details, quantity controls, and price
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final int index;
  final Function(int newQuantity) onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: defaultPadding),
        decoration: BoxDecoration(
          color: errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: errorColor,
        ),
      ),
      onDismissed: (_) => onRemove(),
      child: Container(
        margin: const EdgeInsets.only(bottom: defaultPadding),
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: lightGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWithLoader(
                image: item.image,
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(width: defaultPadding),
            // Product Details and Controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand name
                  Text(
                    item.brandName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: blackColor60,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product title
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Quantity controls and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity stepper
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: blackColor20,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (item.quantity > 1) {
                                  onQuantityChanged(item.quantity - 1);
                                } else {
                                  onRemove();
                                }
                              },
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/Minus.svg",
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      blackColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: blackColor20,
                            ),
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: Center(
                                child: Text(
                                  "${item.quantity}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 32,
                              color: blackColor20,
                            ),
                            InkWell(
                              onTap: () => onQuantityChanged(item.quantity + 1),
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icons/Plus1.svg",
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      blackColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${item.effectivePrice.toStringAsFixed(2)} ل.ع",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: blackColor60,
                                ),
                          ),
                          if (item.hasDiscount)
                            Text(
                              "${item.price.toStringAsFixed(2)} ل.ع",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: blackColor40,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            "${item.totalPrice.toStringAsFixed(2)} ل.ع",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
