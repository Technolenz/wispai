import 'exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  double getCardWidth(BuildContext context, int columns) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 32.0;
    final spacing = columns > 1 ? 24.0 : 0.0;
    final availableWidth = screenWidth - padding - spacing * (columns - 1);
    return availableWidth / columns;
  }

  int getWrapColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1400) {
      return 3;
    } else if (screenWidth > 1200) {
      return 2;
    } else if (screenWidth > 900) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentGradient = themeProvider.currentGradient;
    final wrapColumns = getWrapColumns(context);

    return GestureDetector(
      onLongPress: () {
        Navigator.of(context).push(_fadeRoute(ChatScreen()));
        activateWisp(context);
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(_slideLeftToRightRoute(HistoryScreen()));
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 10) {
          Navigator.of(context).push(_slideDownRoute(SettingsScreen()));
        }
      },
      child: Scaffold(
        backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("WispAI"),
          backgroundColor: themeProvider.themeData.primaryColor,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: themeProvider.themeData.textTheme.bodyLarge?.color,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(_fadeRoute(SettingsScreen()));
              },
              icon: const Icon(Icons.settings),
              splashRadius: 24,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: currentGradient,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  // Welcome Card
                  infoCard(
                    title: "Welcome to WispAI!",
                    subtitle: "Hold to start a conversation instantly.",
                    cardColor: themeProvider.themeData.secondaryHeaderColor.withValues(alpha: 0.9),
                    borderColor: AppColors.grey.withValues(alpha: 0.3),
                    borderWidth: 1.5,
                    titleColor: AppColors.greywhite,
                    titleSize: 32,
                    subtitleColor: AppColors.greywhite.withValues(alpha: 0.8),
                    subtitleSize: 16,
                  ),
                  const SizedBox(height: 40),
                  // Feature Cards
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildFeatureCard(
                        context,
                        title: "Effortless Interaction",
                        subtitle: "Navigate seamlessly with intuitive gestures and smart design.",
                        icon: Icons.touch_app,
                        themeProvider: themeProvider,
                        width: getCardWidth(context, wrapColumns),
                      ),
                      _buildFeatureCard(
                        context,
                        title: "AI-Powered by Gemini",
                        subtitle:
                            "WispAI leverages Google's Gemini AI for natural, intelligent conversations.",
                        icon: Icons.auto_awesome,
                        themeProvider: themeProvider,
                        width: getCardWidth(context, wrapColumns),
                      ),
                      _buildFeatureCard(
                        context,
                        title: "Your AI Assistant",
                        subtitle: "Very easy to use, just hold to start a conversation.",
                        icon: Icons.assistant,
                        themeProvider: themeProvider,
                        width: getCardWidth(context, wrapColumns),
                      ),
                      _buildFeatureCard(
                        context,
                        title: "Always Accessible",
                        subtitle:
                            "Use WispAI anywhere—on mobile, desktop, and web, with seamless sync.",
                        icon: Icons.devices,
                        themeProvider: themeProvider,
                        width: getCardWidth(context, wrapColumns),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Start Chatting Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(_fadeRoute(ChatScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: themeProvider.themeData.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Start Chatting",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeProvider themeProvider,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        color: themeProvider.themeData.secondaryHeaderColor.withValues(alpha: 0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: AppColors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: themeProvider.themeData.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greywhite,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _slideLeftToRightRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Route _slideDownRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
