import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Addresses",
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
              Icons.location_on_outlined,
              size: 64,
              color: blackColor20,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "No addresses saved",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Add an address to get started",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: blackColor60,
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to add address screen
              },
              child: const Text("Add Address"),
            ),
          ],
        ),
      ),
    );
  }
}
