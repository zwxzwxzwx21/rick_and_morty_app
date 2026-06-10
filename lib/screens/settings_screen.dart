import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            subtitle: const Text('Logged in as Guest'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile feature coming soon!')),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: true,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.notifications),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false,
            onChanged: (bool value) {},
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            subtitle: const Text('Rick and Morty App v1.0.0'),
            onTap: () {
               showAboutDialog(
                context: context,
                applicationName: 'Rick and Morty App',
                applicationVersion: '1.0.0',
                children: [
                  const Text('This is a project for mobile applications course.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
