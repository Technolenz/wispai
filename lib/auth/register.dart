import 'package:wisp_ai/exports.dart'; // Your existing imports

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _emailController = TextEditingController(); // Controller for email
  final _passwordController = TextEditingController(); // Controller for password
  final _confirmPasswordController = TextEditingController(); // Controller for confirm password
  final _nameController = TextEditingController(); // Controller for name
  final _apiKeyController = TextEditingController(); // Controller for Gemini API key
  final _bioController = TextEditingController(); // Controller for bio

  final AuthService _authService = AuthService(); // Instance of AuthService

  bool _isLoading = false; // Loading state

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _apiKeyController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Call the sign-up method from AuthService
        final user = await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
        );

        // Save additional user info to Firestore
        await FirestoreService().saveUserInfo(
          userId: user!.uid,
          name: _nameController.text.trim(),
          geminiApiKey: _apiKeyController.text.trim(),
          bio: _bioController.text.trim(),
        );

        // Navigate to HomeScreen after successful registration
        Navigator.pushReplacementNamed(context, '/login');
      } on AuthException catch (e) {
        showFloatingSnackbar(context, e.toString());
      } catch (e) {
        showFloatingSnackbar(context, 'An unexpected error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
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
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.greywhite,
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 40 : 32,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Create a Flutterlenz Account to get started with WispAI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.greywhite.withValues(alpha: 0.8),
                        fontSize: isDesktop ? 18 : 16,
                      ),
                ),
                const SizedBox(height: 30),

                // Name Input Field
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                    color: AppColors.greywhite,
                    fontFamily: 'RobotoMono',
                    fontSize: isDesktop ? 18 : 16,
                  ),
                  autofillHints: const [AutofillHints.name],
                  decoration: InputDecoration(
                    labelText: 'Full Name',
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
                    prefixIcon: Icon(Icons.person, color: AppColors.greywhite),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

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
                  autofillHints: const [AutofillHints.newPassword],
                  controller: _passwordController,
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
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password Input Field
                TextFormField(
                  autofillHints: const [AutofillHints.newPassword],
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: TextStyle(
                    color: AppColors.greywhite,
                    fontFamily: 'RobotoMono',
                    fontSize: isDesktop ? 18 : 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Gemini API Key Input Field
                TextFormField(
                  controller: _apiKeyController,
                  style: TextStyle(
                    color: AppColors.greywhite,
                    fontFamily: 'RobotoMono',
                    fontSize: isDesktop ? 18 : 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Gemini API Key',
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
                    prefixIcon: Icon(Icons.key, color: AppColors.greywhite),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Gemini API Key';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Step-by-Step Guide for Gemini API Key
                ExpansionTile(
                  title: Text(
                    'How to Get Your Gemini API Key',
                    style: TextStyle(
                      color: AppColors.greywhite,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step 1: Open your browser and go to "https://aistudio.google.com/"',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          Text(
                            'Step 2: Sign in with your Google account if you haven’t already.',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          Text(
                            'Step 3: Click on "Get API Key" at the top-right of the AI Studio dashboard.',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          Text(
                            'Step 4: Copy the API key that appears.',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          Text(
                            'Step 5: Paste this API key in your Flutter project where needed.',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          Text(
                            'Step 6: To test, try sending a request using the Gemini API.',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          Text(
                            'Step 7: If you reach the free limit, you may need to wait for a reset or explore a paid plan.',
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              launchUrl('https://aistudio.google.com/' as Uri);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greywhite,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Open AI Studio'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "You can also follow the guide below for more detailed instructions:",
                            style: TextStyle(
                              color: AppColors.greywhite.withValues(alpha: 0.8),
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                          const SizedBox(height: 20),
                          ResponsiveYoutubeButton(
                            youtubeUrl: 'https://youtu.be/ywPDnh4T2TA?si=mq3BE7hiIaX7jL04',
                            buttonLabel: 'Watch alternative Guide on YouTube',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bio Input Field (Optional)
                TextFormField(
                  style: TextStyle(
                    color: AppColors.greywhite,
                    fontFamily: 'RobotoMono',
                    fontSize: isDesktop ? 18 : 16,
                  ),
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio (Optional)',
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
                    prefixIcon: Icon(Icons.description, color: AppColors.greywhite),
                  ),
                ),
                const SizedBox(height: 30),

                // Sign-Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp, // Disable button when loading
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
                            'Sign Up',
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

                // Link to Login Screen
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        color: AppColors.greywhite,
                        fontFamily: 'RobotoMono',
                        fontSize: isDesktop ? 16 : 14,
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

class ResponsiveYoutubeButton extends StatelessWidget {
  final String youtubeUrl;
  final String buttonLabel;
  final Color backgroundColor;

  const ResponsiveYoutubeButton({
    super.key,
    required this.youtubeUrl,
    required this.buttonLabel,
    this.backgroundColor = const Color(0xFFF0F0F0), // Default grey-white
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600; // Adjust breakpoint as needed
        double paddingVertical = isMobile ? 12.0 : 15.0;
        double fontSize = isMobile ? 16.0 : 18.0;
        double buttonWidth = isMobile ? double.infinity : 250.0; // Full width on mobile

        return SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            onPressed: () async {
              final Uri url = Uri.parse(youtubeUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $youtubeUrl')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(vertical: paddingVertical),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        );
      },
    );
  }
}
