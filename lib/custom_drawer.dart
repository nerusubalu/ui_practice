import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice/ride_history.dart';
import 'package:ui_practice/support.dart';

import 'main.dart';



class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'My App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Ride History'),
            onTap: () {
              // Navigate to the Home Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RideHistory()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to the Settings Screen or perform any other action
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Navigate to the About Screen or perform any other action
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SupportPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Logout'),
            onTap: () {
              _removeData(false);
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: Text(
              'Do you want to Sign Out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(title: 'Ride App')),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _removeData(bool auth) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', auth);
  }
}
