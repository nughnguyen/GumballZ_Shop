import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Initialize Firebase for the application
Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
    rethrow;
  }
}
