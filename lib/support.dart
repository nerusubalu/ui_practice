import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SupportPage(),
    );
  }
}

class SupportPage extends StatelessWidget {
  final String phoneNumber = '+1234567890';
  final String emailAddress = 'support@example.com';
  final String websiteUrl = 'https://example.com';
  final Map<String, String> socialMediaLinks = {
    'Facebook': 'https://facebook.com/example',
    'Twitter': 'https://twitter.com/example',
    'Instagram': 'https://instagram.com/example',
  };

  @override
  Widget build(BuildContext context) {
    return //WillPopScope(
        //   onWillPop: () async {
        //     Navigator.of(context).pop();
        //     return false;
        //     // Check if you're on the first screen.
        //     // if (Navigator.of(context).canPop()) {
        //     //   // Navigate to the previous page if not on the first screen.
        //     //   Navigator.of(context).pop();
        //     //   return false; // Prevent the default back gesture behavior.
        //     // } else {
        //     //   // Handle the back gesture for the first screen (e.g., show a confirmation dialog).
        //     //   return true; // Allow the default back gesture behavior.
        //     // }
        //   },
        Scaffold(
      appBar: AppBar(
        title: Text('Support'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => RideHistory()),
            // );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 24),
                SizedBox(width: 8),
                Text(
                  phoneNumber,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _launchPhoneCall(phoneNumber),
                  icon: Icon(Icons.call),
                  label: Text('Call'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, size: 24),
                SizedBox(width: 8),
                Text(
                  emailAddress,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _launchEmail(emailAddress),
                  icon: Icon(Icons.email),
                  label: Text('Email'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.web, size: 24),
                SizedBox(width: 8),
                Text(
                  websiteUrl,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _launchWebsite(websiteUrl),
                  icon: Icon(Icons.open_in_browser),
                  label: Text('Visit'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Social Media:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              children: socialMediaLinks.entries.map((entry) {
                return ListTile(
                  leading: Image.asset('${entry.key.toLowerCase()}_icon.png',
                      width: 32, height: 32),
                  title: Text(entry.key),
                  onTap: () => _launchURL(entry.value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _launchWebsite(String website) async {
    final uri = Uri.parse(website);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
