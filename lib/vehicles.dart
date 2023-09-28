import 'package:flutter/material.dart';

class VehicleSelectionScreen extends StatefulWidget {
  @override
  _VehicleSelectionScreenState createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int _selectedIndex = 0; // Keep track of the selected vehicle index

  // List of vehicle options
  final List<VehicleOption> _vehicleOptions = [
    VehicleOption(name: 'Auto', price: 50.0, iconAsset: 'assets/rickshaw.png'),
    VehicleOption(name: 'Micro Car', price: 100.0, iconAsset: 'assets/car.png'),
    VehicleOption(name: 'Sedan', price: 130.0, iconAsset: 'assets/sedan.png'),
    VehicleOption(name: 'SUV', price: 250.0, iconAsset: 'assets/suv.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the selected vehicle
            Text(
              'Selected Vehicle: ${_vehicleOptions[_selectedIndex].name}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            // Display vehicle options using BottomNavigationBar
            BottomNavigationBar(
              items: _vehicleOptions.map((vehicle) {
                return BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage(vehicle.iconAsset),
                    size: 30,
                  ),

                  label: vehicle.name,
                );
              }).toList(),
              elevation: 0,
              selectedFontSize: 18,
              unselectedFontSize: 14,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue, // Color when selected
              unselectedItemColor: Colors.black,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              // backgroundColor: Colors.black12,
              onTap: _onItemTapped,
            ),
            // SizedBox(height: 20),
            // Button to show fare details
            ElevatedButton(
              onPressed: () {
                _showFareDetails(context);
              },
              child: Text('Fare Details'),
            ),
            SizedBox(height: 20,),
          ],
        ),
    );
  }

  // Function to handle when a vehicle option is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showConfirmationDialog(context, _vehicleOptions[index]);
    });
  }
  void _showConfirmationDialog(
      BuildContext context, VehicleOption selectedOption) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Vehicle Selection'),
          content: Text(
              'You have selected ${selectedOption.name}. Price: Rs.${selectedOption.price.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
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
  // Function to show fare details in a BottomSheet
  void _showFareDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        final selectedVehicle = _vehicleOptions[_selectedIndex];
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Fare Details - ${selectedVehicle.name}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              ListTile(
                title: Text('Ride Fare:', style: TextStyle(fontSize: 18),),
                trailing: Text('Rs.${selectedVehicle.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18),),
              ),
              const ListTile(
                title: Text('Platform Fee:', style: TextStyle(fontSize: 18),),
                trailing: Text('Rs.27.00', style: TextStyle(fontSize: 18),),
              ),
              ListTile(
                title: Text('Total Fee:', style: TextStyle(fontSize: 18),),
                trailing: Text('Rs.'+(selectedVehicle.price+27).toStringAsFixed(2), style: TextStyle(fontSize: 18),),
              ),
              // Add more fare details here as needed
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the BottomSheet
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VehicleOption {
  final String name;
  final double price;
  final String iconAsset;

  VehicleOption({
    required this.name,
    required this.price,
    required this.iconAsset,
  });
}

void main() {
  runApp(MaterialApp(
    home: VehicleSelectionScreen(),
  ));
}
