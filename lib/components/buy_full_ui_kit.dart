import 'package:flutter/material.dart';

/// A wrapper component that previously contained a paywall overlay.
/// Now serves as a simple pass-through widget that displays either:
/// - The passed child widget (if available)
/// - A "Coming Soon" placeholder for screens under development
class BuyFullKit extends StatelessWidget {
  const BuyFullKit({
    super.key,
    this.child,
    this.images,
  });

  /// Child widget to display (takes precedence over images)
  final Widget? child;

  /// Legacy image list parameter (ignored if child is provided)
  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    // If a child widget is provided, display it
    if (child != null) {
      return child!;
    }

    // Fallback: Show a "Coming Soon" placeholder
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: 16),
            Text(
              "Coming Soon",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              "This feature is under development",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
