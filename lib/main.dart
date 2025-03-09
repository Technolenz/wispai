import 'package:wisp_ai/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Load .env file
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Ensure Firebase options are configured
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Provide the ThemeProvider
      child: const WispAI(),
    ),
  );
}

class WispAI extends StatelessWidget {
  const WispAI({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WispAI',
      theme: themeProvider.themeData, // Use the theme from ThemeProvider
      home: AuthWrapper(), // Use AuthWrapper as the home
      routes: {
        '/history': (context) => const HistoryScreen(),
        '/chat': (context) => const ChatScreen(),
        '/tools': (context) => const SettingsScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/edit': (context) => const EditInfoScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return FutureBuilder<bool>(
        future: AuthService().needsSignIn(firebaseUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.data == true) {
            // User needs to sign in again
            return LoginScreen();
          } else {
            // User is logged in and doesn't need to sign in again
            return HomeScreen();
          }
        },
      );
    } else {
      // User is not authenticated
      return LoginScreen();
    }
  }
}
