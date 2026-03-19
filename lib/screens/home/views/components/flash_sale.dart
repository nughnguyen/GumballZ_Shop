import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
          press: () {
            Navigator.pushNamed(context, onSaleScreenRoute);
          },
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Consumer<ProductProvider>(
          builder: (context, productProvider, _) {
            // Use Firestore flash sale products if available, otherwise use demo
            final products = productProvider.flashSaleProducts.isNotEmpty
                ? productProvider.flashSaleProducts
                : demoFlashSaleProducts;

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final isFirestore =
                      productProvider.flashSaleProducts.isNotEmpty;
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
        ),
      ],
    );
  }
}
