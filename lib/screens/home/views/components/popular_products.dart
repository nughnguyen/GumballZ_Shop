import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            // Use Firestore products if available, otherwise use demo data
            final products = productProvider.filteredProducts.isNotEmpty
                ? productProvider.filteredProducts.take(10).toList()
                : demoPopularProducts;

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final isFirestore =
                      productProvider.filteredProducts.isNotEmpty;
                  final product = products[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == products.length - 1 ? defaultPadding : 0,
                    ),
                    child: isFirestore
                        ? ProductCard(
                            image: product.image,
                            brandName: product.brandName,
                            title: product.title,
                            price: product.price,
                            priceAfetDiscount: product.priceAfterDiscount,
                            dicountpercent: product.discountPercent,
                            press: () {
                              Navigator.pushNamed(
                                context,
                                productDetailsScreenRoute,
                                arguments: product.id,
                              );
                            },
                          )
                        : ProductCard(
                            image: product.image,
                            brandName: product.brandName,
                            title: product.title,
                            price: product.price,
                            priceAfetDiscount: product.priceAfetDiscount,
                            dicountpercent: product.dicountpercent,
                            press: () {
                              Navigator.pushNamed(
                                context,
                                productDetailsScreenRoute,
                                arguments: index.isEven,
                              );
                            },
                          ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
