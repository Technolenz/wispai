import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'exports.dart'; // Ensure this import points to your theme provider or other necessary files

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  int _currentStep = 0;
  final List<Map<String, dynamic>> _tutorialSteps = [
    {
      'title': 'Welcome to WispAI!',
      'description': 'Let’s learn how to navigate and use WispAI effectively.',
      'icon': FontAwesomeIcons.solidHand, // Example icon
    },
    {
      'title': 'Main Menu Navigation',
      'description': 'Swipe left to right from the edge to open the main menu.',
      'icon': FontAwesomeIcons.bars, // Menu icon
      'webHint': 'On web, use the menu button in the top-left corner.',
    },
    {
      'title': 'Hold to Start Speaking',
      'description': 'Press and hold the microphone button to start speaking to Wisp.',
      'icon': FontAwesomeIcons.microphone, // Microphone icon
      'webHint': 'On web, click the microphone button to start speaking.',
    },
    {
      'title': 'Triple Tap in Chat',
      'description': 'Triple tap in the chat screen to unify the UI for better readability.',
      'icon': FontAwesomeIcons.handPointer, // Hand pointer icon
      'webHint': 'On web, click the "Unify UI" button in the chat screen.',
    },
    {
      'title': 'Hold in Chat to Record',
      'description': 'Press and hold in the chat screen to begin recording a voice message.',
      'icon': FontAwesomeIcons.solidCircle, // Record icon
      'webHint': 'On web, click the "Record" button to start recording.',
    },
    {
      'title': 'Swipe Down for Quick Tools',
      'description': 'Swipe down from the top of the menu to access quick tools.',
      'icon': FontAwesomeIcons.arrowDown, // Swipe down icon
      'webHint': 'On web, click the "Quick Tools" button in the menu.',
    },
    {
      'title': 'Swipe for History',
      'description': 'Swipe left to right in the menu to open your chat history.',
      'icon': FontAwesomeIcons.arrowLeft, // Swipe left icon
      'webHint': 'On web, click the "History" button in the menu.',
    },
  ];

  void _nextStep() {
    if (_currentStep < _tutorialSteps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentGradient = themeProvider.currentGradient;
    final step = _tutorialSteps[_currentStep];

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tutorial'),
        backgroundColor: themeProvider.themeData.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient, // Use the current gradient
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Font Awesome Icon
              Icon(
                step['icon'], // Use the Font Awesome icon
                size: 100,
                color: themeProvider.themeData.textTheme.bodyLarge?.color,
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
                  .shake(duration: 1000.ms),

              const SizedBox(height: 20),

              // Title
              Text(
                step['title'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeData.textTheme.bodyLarge?.color,
                  fontFamily: 'RobotoMono',
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5), end: Offset.zero),

              const SizedBox(height: 10),

              // Description
              Text(
                step['description'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                  fontFamily: 'RobotoMono',
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slide(begin: const Offset(0, 0.5), end: Offset.zero),

              // Web Hint (if applicable)
              if (step['webHint'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    step['webHint'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeProvider.themeData.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.8),
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: _previousStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.themeData.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: themeProvider.themeData.textTheme.bodyLarge?.color,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                  if (_currentStep < _tutorialSteps.length - 1)
                    ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.themeData.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: themeProvider.themeData.textTheme.bodyLarge?.color,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                  if (_currentStep == _tutorialSteps.length - 1)
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.themeData.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          color: themeProvider.themeData.textTheme.bodyLarge?.color,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
