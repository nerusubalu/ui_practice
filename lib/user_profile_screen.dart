import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_practice/main.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  });
}

// class UserProfileScrreen extends StatelessWidget {
//   final UserProfile user = UserProfile(
//     name: 'John Doe',
//     email: 'johndoe@example.com',
//     profileImageUrl:
//     'https://www.example.com/profile-image.jpg', // Replace with actual URL
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProfilePage(user: user),
//               ),
//             );
//           },
//           child: Text('View Profile'),
//         ),
//       ),
//     );
//   }
// }

class UserProfileScreen extends StatelessWidget {
  final UserProfile user;

  UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 150,
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
            SizedBox(height: 16),
            Divider(color: shrineBrown600, thickness: 2),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.phone,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _removeData(false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: 'Ride App')),
                );
              },
              child: const Text('Sign Out', style: TextStyle(fontSize: 32, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeData(bool auth) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', auth);
  }
}
