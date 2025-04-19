import 'package:flutter/material.dart';
import '../utils/styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: Styles.heading1),
        backgroundColor: Styles.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildSettingsSection(),
            const Spacer(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Styles.primaryColor,
          child: const Text(
            'JD',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: Styles.fontFamily,
              ),
            ),
            Text(
              'john.doe@recipeapp.com',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: Styles.fontFamily,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Recipes Created', '12'),
            _buildStatItem('Favorites', '23'),
            _buildStatItem('Following', '45'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Styles.primaryColor,
            fontFamily: Styles.fontFamily,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontFamily: Styles.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingsItem(Icons.person_outline, 'Edit Profile'),
        _buildSettingsItem(Icons.settings_outlined, 'App Settings'),
        _buildSettingsItem(Icons.notifications_none, 'Notifications'),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Styles.primaryColor),
      title: Text(
        text,
        style: TextStyle(fontFamily: Styles.fontFamily),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Handle settings navigation
      },
    );
  }

  Widget _buildLogoutButton() {
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
          // TODO: Handle logout
        },
      ),
    );
  }
}