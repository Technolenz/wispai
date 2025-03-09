import 'exports.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentGradient = themeProvider.currentGradient;

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;
    final iconSize = isDesktop ? 60.0 : 40.0;
    final titleSize = isDesktop ? 24.0 : 18.0;

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text("Settings"),
              backgroundColor: themeProvider.themeData.primaryColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
      body: Container(
        decoration: BoxDecoration(
          gradient: currentGradient, // Use the current gradient
        ),
        child: isDesktop
            ? _buildDesktopLayout(context, iconSize, titleSize)
            : _buildMobileLayout(context, iconSize, titleSize),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, double iconSize, double titleSize) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lightBlack,
                  AppColors.grey.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Wisp AI",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.greywhite,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.grey,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: _buildSettingsOptions(context, iconSize, titleSize),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, double iconSize, double titleSize) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          infoCard(
            title: "Settings",
            subtitle: "Customize your Wisp AI experience.",
            cardColor: AppColors.lightBlack,
            borderColor: AppColors.grey,
            borderWidth: 2,
            titleColor: AppColors.greywhite,
            titleSize: 24,
            subtitleColor: AppColors.grey,
            subtitleSize: 16,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildSettingsOptions(context, iconSize, titleSize),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context, double iconSize, double titleSize) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      children: [
        // Theme Toggle
        _buildSettingTile(
          context,
          icon: Icons.color_lens,
          title: "Change Theme",
          subtitle: themeProvider.isGreenTheme ? "Green Theme" : "Light Theme",
          onTap: () {
            themeProvider.toggleTheme(); // Toggle the theme
          },
        ),
        const Divider(color: AppColors.grey),

        // Search History
        _buildSettingTile(
          context,
          icon: Icons.history,
          title: "Chat History",
          subtitle: "View your Chat history",
          onTap: () {
            Navigator.pushNamed(context, '/history'); // Navigate to history screen
          },
        ),
        const Divider(color: AppColors.grey),

        // Navigation Tutorial
        _buildSettingTile(
          context,
          icon: Icons.directions,
          title: "Navigation Tutorial",
          subtitle: "Learn how to navigate the app",
          onTap: () {
            Navigator.pushNamed(context, '/tutorial'); // Navigate to tutorial screen
          },
        ),
        const Divider(color: AppColors.grey),

        _buildSettingTile(
          context,
          icon: Icons.edit,
          title: "User Info",
          subtitle: "Edit your information (name, api-key, etc)",
          onTap: () {
            Navigator.pushNamed(context, '/edit'); // Navigate to tutorial screen
          },
        ),
        const Divider(color: AppColors.grey),

        // Logout Button
        _buildSettingTile(
          context,
          icon: Icons.logout,
          title: "Logout",
          subtitle: "Sign out of your account",
          onTap: () {
            logoutUser(context); // Call your logout function
          },
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30, color: AppColors.greywhite),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: AppColors.greywhite,
          fontFamily: 'RobotoMono',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.grey,
          fontFamily: 'RobotoMono',
        ),
      ),
      onTap: onTap,
      tileColor: AppColors.lightBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
