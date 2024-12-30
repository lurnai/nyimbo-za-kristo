import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF145F3A),
      ),
      body: const Center(
        child: Text(
          'This is the settings page. We will add more features here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
