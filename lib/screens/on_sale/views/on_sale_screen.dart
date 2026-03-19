import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "On Sale",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Text("On Sale Screen - Coming Soon"),
      ),
    );
  }
}
