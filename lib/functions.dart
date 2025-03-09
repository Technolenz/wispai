import "package:flutter/cupertino.dart";
import "package:wisp_ai/exports.dart";

// Wisp Dialog
void activateWisp(BuildContext context) {
  runChatVoicing();
}

void runChatVoicing() {
  return;
}

// Info Card
Widget infoCard({
  required String title,
  required String subtitle,
  required Color cardColor,
  required Color borderColor,
  required double borderWidth,
  required Color titleColor,
  required double titleSize,
  required Color subtitleColor,
  required double subtitleSize,
}) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: cardColor,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: TextStyle(
            color: subtitleColor,
            fontSize: subtitleSize,
          ),
        ),
      ],
    ),
  );
}

//Tutorial Dialog
void tutorial(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Prevents closing by tapping outside
    builder: (context) => TutorialDialog(),
  );
}

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to WispAI!",
              style: TextStyle(color: AppColors.greywhite, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              "Use gestures to navigate.",
              style: TextStyle(color: AppColors.grey, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              " Swipe left for history,\n down for quick tools, and \n Hold to begin chat",
              style: TextStyle(color: AppColors.grey, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  onPressed: () {
                    // Navigate to the TutorialScreen using the named route
                    Navigator.of(context).pushNamed('/tutorial');
                  },
                  child: Text(
                    "Open Tutorial",
                    style: TextStyle(color: AppColors.greenGrey, fontSize: 16),
                  ),
                ),
                CupertinoButton(
                  onPressed: () {
                    // Navigate to the next instruction (you can change this)
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SharedPreferencesService {
  static const String _userNameKey = 'userName';
  static const String _geminiApiKeyKey = 'geminiApiKey';
  static const String _userBioKey = 'userBio';

  // Save user name
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Retrieve user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Save Gemini API Key
  static Future<void> saveGeminiApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiApiKeyKey, apiKey);
  }

  // Retrieve Gemini API Key
  static Future<String?> getGeminiApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_geminiApiKeyKey);
  }

  // Save user bio
  static Future<void> saveUserBio(String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userBioKey, bio);
  }

  // Retrieve user bio
  static Future<String?> getUserBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userBioKey);
  }
}

class ToolDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const ToolDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.lightBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.grey, width: 2),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.greywhite,
          fontSize: 24,
          fontFamily: 'RobotoMono',
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 16,
          fontFamily: 'RobotoMono',
        ),
      ),
      actions: actions,
    );
  }
}

void _showRandomQuoteDialog(BuildContext context) {
  final List<String> quotes = [
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "Believe you can and you're halfway there.",
    "Do what you can, with what you have, where you are.",
  ];
  final random = Random();
  final quote = quotes[random.nextInt(quotes.length)];

  showDialog(
    context: context,
    builder: (context) => ToolDialog(
      title: "Random Quote",
      content: quote,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Close",
            style: TextStyle(
              color: AppColors.greywhite,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ],
    ),
  );
}

void logoutUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => ToolDialog(
      title: "Logout",
      content: "Are you sure you want to logout?",
      actions: [
        TextButton(
          onPressed: () {
            AuthService().signOut();
            Navigator.pop(context); // Close the dialog
            Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
          },
          child: Text(
            "Yes",
            style: TextStyle(
              color: AppColors.greywhite,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "No",
            style: TextStyle(
              color: AppColors.greywhite,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ],
    ),
  );
}

// For web compatibility
void showFloatingSnackbar(BuildContext context, String message,
    {Duration duration = const Duration(seconds: 3)}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    duration: duration,
    behavior: SnackBarBehavior.floating, // Makes it float
    margin: EdgeInsets.all(16), // Adds some space around it
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
    backgroundColor: Colors.black87, // Custom background color
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
