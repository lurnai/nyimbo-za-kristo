import 'package:flutter/material.dart';
import 'models/song_model.dart';
import 'screens/favourites.dart';
import 'screens/settings.dart';
import 'screens/info.dart';
import 'screens/support.dart';
import 'screens/song_list.dart';
import 'utils/search_delegate.dart';
import 'screens/about.dart';
import 'screens/acknowledgements.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const SongBookApp());
}

class SongBookApp extends StatelessWidget {
  const SongBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyimbo Za Kristo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF145F3A),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // ignore: unused_field
  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;
  late Future<List<Song>> futureSongs;

  Future<void> _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  static final List<Widget> _pages = <Widget>[
    const SongListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForUpdate(); // Automatically check for updates on app start
  }

  Future<void> _startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      setState(() {
        _flexibleUpdateAvailable = true;
      });
    } catch (e) {
      debugPrint("Failed to start flexible update: $e");
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      setState(() {
        _updateInfo = info;
      });

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        _startFlexibleUpdate();
      }
    } catch (e) {
      debugPrint("Error checking for updates: $e");
    }
  }

  Future<void> _performImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint("Failed to perform immediate update: $e");
    }
  }

  Future<void> _completeFlexibleUpdate() async {
    if (_flexibleUpdateAvailable) {
      try {
        await InAppUpdate.completeFlexibleUpdate();
        debugPrint("Flexible update completed successfully.");
      } catch (e) {
        debugPrint("Failed to complete flexible update: $e");
      }
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Available"),
        content: const Text("A new version of this app is available."),
        actions: [
          TextButton(
            child: const Text("Later"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Update"),
            onPressed: () {
              Navigator.pop(context);
              _performImmediateUpdate();
            },
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        _checkForUpdate(); // Check for updates when navigating to Support
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Nyimbo Za Kristo',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SongSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add Drawer widget
        backgroundColor: Colors.white, // Set background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF145F3A),
              ),
              child: Text(
                'Nyimbo Za Kristo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_outline_outlined),
              title: const Text('Favourites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavouritesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Acknowledgments'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcknowledgementsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('Rate Us'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                try {
                  final InAppReview inAppReview = InAppReview.instance;
                  await inAppReview
                      .openStoreListing(); // Open the store listing
                } catch (e) {
                  debugPrint('Error opening store listing: $e');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                // Implement distinct behavior for this item if necessary
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Support'),
              onTap: () async {
                Navigator.pop(context); // Close the drawer
                await _requestReview(); // Trigger the review request
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SupportScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Check for Updates'),
              onTap: () {
                Navigator.pop(context);
                _checkForUpdate(); // Check for updates from Support menu

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.web),
              title: const Text('Website'),
              onTap: () {
                Navigator.pop(context);
                // Implement distinct behavior for this item if necessary
              },
            ),
          ],
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }
}
