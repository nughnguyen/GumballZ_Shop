import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/admin_auth_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/category_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/services/firebase_init.dart';
import 'package:shop/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await initializeFirebase();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Thanks for using our template. You are using the free version of the template.
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _initialRoute;

  @override
  void initState() {
    super.initState();
    
    // Check admin status and initialize streams
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminAuthProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      
      // Check if admin is already logged in
      adminProvider.checkAdminStatus();
      
      // Initialize product and category streams
      productProvider.initializeProductStreams();
      categoryProvider.initializeCategoryStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminAuthProvider>(
      builder: (context, adminProvider, _) {
        // Determine initial route based on admin authentication
        String initialRoute = adminProvider.isAuthenticated 
            ? adminDashboardRoute 
            : entryPointScreenRoute;
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GumballZ Shop',
          theme: AppTheme.lightTheme(context),
          themeMode: ThemeMode.light,
          onGenerateRoute: router.generateRoute,
          initialRoute: initialRoute,
        );
      },
    );
  }
}
