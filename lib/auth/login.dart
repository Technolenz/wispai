import 'package:wisp_ai/exports.dart'; // Your existing imports

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _emailController = TextEditingController(); // Controller for email
  final _passwordController = TextEditingController(); // Controller for password

  final AuthService _authService = AuthService(); // Instance of AuthService

  bool _isLoading = false; // Loading state

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Call the login method from AuthService
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // Navigate to HomeScreen after successful login
        Navigator.pushReplacementNamed(context, '/home');
      } on AuthException catch (e) {
        // Show error message to the user
        showFloatingSnackbar(context, e.toString());
      } catch (e) {
        // Handle unexpected errors
        showFloatingSnackbar(context, 'An unexpected error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  // Forgot Password Functionality
  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      showFloatingSnackbar(context, 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showFloatingSnackbar(context, 'Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      showFloatingSnackbar(context, e.message ?? 'Failed to send password reset email.');
    } catch (e) {
      showFloatingSnackbar(context, 'An unexpected error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppColors.lightBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 100 : 20,
          vertical: 20,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 600 : double.infinity,
          ),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.greywhite,
                    fontWeight: FontWeight.bold,
                    fontSize: isDesktop ? 40 : 32,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to continue using WispAI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.greywhite.withValues(alpha: 0.8),
                    fontSize: isDesktop ? 18 : 16,
                  ),
                ),
                const SizedBox(height: 30),

                // Email Input Field
                TextFormField(
                  autofillHints: const [AutofillHints.email],
                  controller: _emailController,
                  style: TextStyle(
                    color: AppColors.greywhite,
                    fontFamily: 'RobotoMono',
                    fontSize: isDesktop ? 18 : 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: AppColors.greywhite.withValues(alpha: 0.6),
                      fontSize: isDesktop ? 18 : 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greywhite.withValues(alpha: 0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greywhite),
                    ),
                    prefixIcon: Icon(Icons.email, color: AppColors.greywhite),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Input Field
                TextFormField(
                  controller: _passwordController,
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  style: TextStyle(
                    color: AppColors.greywhite,
                    fontFamily: 'RobotoMono',
                    fontSize: isDesktop ? 18 : 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: AppColors.greywhite.withValues(alpha: 0.6),
                      fontSize: isDesktop ? 18 : 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greywhite.withValues(alpha: 0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.greywhite),
                    ),
                    prefixIcon: Icon(Icons.lock, color: AppColors.greywhite),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : _forgotPassword, // Disable when loading
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.greywhite,
                        fontFamily: 'RobotoMono',
                        fontSize: isDesktop ? 16 : 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login, // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greywhite,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                        color: AppColors.lightBlack) // Show loading indicator
                        : Text(
                      'Sign In',
                      style: TextStyle(
                        color: AppColors.lightBlack,
                        fontFamily: 'RobotoMono',
                        fontSize: isDesktop ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Footer: Link to Sign-Up Screen
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to Sign-Up Screen
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text(
                      'Don\'t have an account? Sign Up',
                      style: TextStyle(
                        color: AppColors.greywhite,
                        fontFamily: 'RobotoMono',
                        fontSize: isDesktop ? 18 : 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}