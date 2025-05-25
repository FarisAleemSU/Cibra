import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'setting_p.dart';
import 'edit_profile_screen.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(context), // Pass user here
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const Spacer(),
            _buildLogoutButton(context, authProvider), // Pass authProvider
          ],
        ),
      ),
    );
  }


  Widget _buildProfileHeader(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context);
  final user = authProvider.user;

  String displayName = user?.displayName ?? 'User';
  String email = user?.email ?? 'No email associated';
  String initials = displayName.isNotEmpty 
      ? displayName.split(' ').map((n) => n[0]).take(2).join()
      : email[0].toUpperCase();

  return Row(
    children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          initials,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      const SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            email,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildSettingsItem(context, Icons.person_outline, 'Edit Profile', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          );
        }),
        _buildSettingsItem(context, Icons.settings_outlined, 'App Settings', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingP()),
          );
        }),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        text,
        style: const TextStyle(fontFamily: 'Poppins'),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

   Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Log Out'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          authProvider.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
      ),
    );
  }
  }