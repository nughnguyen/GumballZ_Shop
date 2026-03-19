import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Orders",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
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
              "No orders yet",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Start shopping to see your orders here",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: blackColor60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
