import 'package:flutter/material.dart';
import 'package:ui_practice/ui_elements.dart';
import 'package:ui_practice/user_profile_screen.dart';

class RideRequestScreen extends StatefulWidget {
  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class VehicleOption {
  final String name;
  final double price;
  final String iconAsset;

  VehicleOption(
      {required this.name, required this.price, required this.iconAsset});
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  String pickupLocation = '';
  String dropOffLocation = '';
  String selectedVehicle = 'Standard';
  bool isSharingLocation = false;

  final List<VehicleOption> vehicleOptions = [
    VehicleOption(
        name: 'Rickshaw', price: 5.0, iconAsset: 'assets/rickshaw.png'),
    VehicleOption(name: 'Micro Car', price: 10.0, iconAsset: 'assets/car.png'),
    VehicleOption(name: 'Sedan', price: 15.0, iconAsset: 'assets/sedan.png'),
    VehicleOption(name: 'SUV', price: 20.0, iconAsset: 'assets/suv.png'),
  ];

  // List<String> vehicleOptions = ['Standard', 'SUV', 'Luxury'];

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
            Expanded(
              child: ListView.builder(
                itemCount: vehicleOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ImageIcon(
                      AssetImage(vehicleOptions[index].iconAsset),
                      size: 80,
                    ),
                    title: Text(
                      vehicleOptions[index].name,
                      style: TextStyle(fontSize: 22),
                    ),
                    subtitle: Text(
                      'Price: Rs.${vehicleOptions[index].price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      _showConfirmationDialog(context, vehicleOptions[index]);
                    },
                  );
                },
              ),
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

  void _showConfirmationDialog(
      BuildContext context, VehicleOption selectedOption) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Vehicle Selection'),
          content: Text(
              'You have selected ${selectedOption.name}. Price: \$${selectedOption.price.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
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
