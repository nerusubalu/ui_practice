import 'package:flutter/material.dart';
import 'package:ui_practice/support.dart';

void main() {
  runApp(MyApp());
}

class RideInfo {
  final String pickupLocation;
  final String dropLocation;
  final String rideDuration;
  final String startTime;
  final String endTime;
  final String distance;

  RideInfo({
    required this.pickupLocation,
    required this.dropLocation,
    required this.rideDuration,
    required this.startTime,
    required this.endTime,
    required this.distance,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RideHistory(),
    );
  }
}

class RideHistory extends StatelessWidget {
  final List<RideInfo> rides = [
    RideInfo(
      pickupLocation: '123 Main St',
      dropLocation: '456 Elm St',
      rideDuration: '15 min',
      startTime: '09:00 AM',
      endTime: '09:15 AM',
      distance: '2.5 miles',
    ),
    RideInfo(
      pickupLocation: '789 Oak St',
      dropLocation: '101 Pine St',
      rideDuration: '20 min',
      startTime: '10:30 AM',
      endTime: '10:50 AM',
      distance: '3.0 miles',
    ),
    // Add more RideInfo objects as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride History'),
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
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(16.0), // Add padding within the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pickup:',
                          style: TextStyle(
                            fontSize: 18, // Larger font size
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                        Text(
                          'Dropoff:',
                          style: TextStyle(
                            fontSize: 18, // Larger font size
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            rides[index].pickupLocation,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            rides[index].dropLocation,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Start Time: \n${rides[index].startTime}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'End Time: \n${rides[index].endTime}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Duration: ${rides[index].rideDuration}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Distance: ${rides[index].distance}',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: Icon(Icons.visibility, size: 20),
                            label:
                            Text("View", style: TextStyle(fontSize: 20))),
                        FilledButton.tonalIcon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SupportPage()),
                              );
                            },
                            icon: Icon(Icons.help, size: 20),
                            label:
                                Text("Help", style: TextStyle(fontSize: 20))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
