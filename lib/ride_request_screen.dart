import 'package:flutter/material.dart';
import 'package:ui_practice/ui_elements.dart';
import 'package:ui_practice/user_profile_screen.dart';

class RideRequestScreen extends StatefulWidget {
  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  String pickupLocation = '';
  String dropOffLocation = '';
  String selectedVehicle = 'Standard';
  bool isSharingLocation = false;

  List<String> vehicleOptions = ['Standard', 'SUV', 'Luxury'];

  final UserProfile user = UserProfile(
    name: 'John Doe',
    email: 'johndoe@example.com',
    phone: '+917997678666',
    profileImageUrl:
        'https://i.pinimg.com/736x/70/aa/28/70aa28f678193194b4a023e542ce4775.jpg', // Replace with actual URL
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Request'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfileScreen(user: user)),
              );
            },
            child: Hero(
              tag: 'profile',
              child: Padding(
                padding: EdgeInsets.all(7),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.profileImageUrl),
                ),
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.person),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => UserProfileScreen(user: user)),
          //     );
          //   },
          // )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pickup Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter pickup location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  pickupLocation = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Drop-off Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  dropOffLocation = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter drop-off location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Vehicle Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            DropdownButton<String>(
              value: selectedVehicle,
              onChanged: (newValue) {
                setState(() {
                  selectedVehicle = newValue!;
                });
              },
              items: vehicleOptions
                  .map<DropdownMenuItem<String>>((String vehicle) {
                return DropdownMenuItem<String>(
                  value: vehicle,
                  child: Text(vehicle),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isSharingLocation,
                  onChanged: (value) {
                    setState(() {
                      isSharingLocation = value!;
                    });
                  },
                ),
                Text('Share My Location'),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: style,
              onPressed: () {
                _submitRideRequest();
              },
              child: Text(
                'Request Ride',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRideRequest() {
    // Perform logic to submit the ride request
    print('Ride requested');
    print('Pickup Location: $pickupLocation');
    print('Drop-off Location: $dropOffLocation');
    print('Selected Vehicle: $selectedVehicle');
    print('Sharing Location: $isSharingLocation');
  }
}

void main() {
  runApp(MaterialApp(
    home: RideRequestScreen(),
  ));
}
