import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ui_practice/location_search.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:ui_practice/user_profile_screen.dart';
import 'package:ui_practice/custom_drawer.dart';

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

//AIzaSyBKCOVTBJuaYswfKPs0I8WbQxhb_1eKHS8 android map api
class CustomMarker extends StatelessWidget {
  final LatLng position;

  CustomMarker({required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(1),
      child: Icon(
        Icons.location_on,
        color: Colors.greenAccent,
        size: 42.0,
      ),
    );
  }
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  LatLng currentLocation = LatLng(0, 0); // Initialize with default coordinates
  LatLng pickupLocation = LatLng(0, 0); // Initialize with default coordinates
  Marker? pickupMarker;
  Marker? dropoffMarker;
  LatLng dropoffLocation = LatLng(0, 0);
  String selectedVehicle = 'Standard';
  bool isSharingLocation = false;
  int selectedVehicleIndex = -1;
  GoogleMapController? mapController;
  LocationData? userLocation;
  // Set<Marker> markers = {};
  final List<VehicleOption> vehicleOptions = [
    VehicleOption(
        name: 'Rickshaw', price: 5.0, iconAsset: 'assets/rickshaw.png'),
    VehicleOption(name: 'Micro Car', price: 10.0, iconAsset: 'assets/car.png'),
    VehicleOption(name: 'Sedan', price: 15.0, iconAsset: 'assets/sedan.png'),
    VehicleOption(name: 'SUV', price: 20.0, iconAsset: 'assets/suv.png'),
  ];
  // ... (other variables and widgets)
  final UserProfile user = UserProfile(
    name: 'John Doe',
    email: 'johndoe@example.com',
    phone: '+917997678666',
    profileImageUrl:
        'https://i.pinimg.com/736x/70/aa/28/70aa28f678193194b4a023e542ce4775.jpg', // Replace with an actual URL
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<String> getLocationDescription(
      double latitude, double longitude) async {
    try {
      final List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final geocoding.Placemark placemark = placemarks[0];
        final String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        return address;
      } else {
        return 'Location not found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> _getUserLocation() async {
    final location = Location();
    try {
      final userLocationResult = await location.getLocation();
      setState(() {
        userLocation = userLocationResult;
        pickupLocation =
            LatLng(userLocation!.latitude!, userLocation!.longitude!);
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(pickupLocation, 17.0),
        );
        print(pickupLocation);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // ... (rest of your build method)

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
          ],
        ),
        drawer: MyDrawer(),
        body: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Pick-up Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            LocationSearchWidget(
              mapController: mapController,
              onPlaceSelected: (place) {
                final lat = place.geometry?.location.lat;
                final lng = place.geometry?.location.lng;

                if (lat != null && lng != null) {
                  setState(() {
                    pickupLocation = LatLng(lat, lng);
                    // Update the pickup marker's position
                    pickupMarker = Marker(
                      markerId: MarkerId("pickupLocation"),
                      position: pickupLocation,
                      draggable: true, // Make the marker draggable
                      onDragEnd: (value) {
                        setState(() {
                          pickupLocation = value;
                        });
                      },
                    );
                    mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(pickupLocation, 17.0),
                    );
                  });
                }
              },
            ),
            Expanded(
              child: Stack(children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        pickupLocation, // Use currentLocation as the initial camera position
                    zoom: 14.0,
                  ),
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  onCameraMove: (position) {
                    setState(() {
                      pickupLocation = position.target;
                      print(pickupLocation);
                    });
                  },

                  // ... (other GoogleMap properties)
                ),
                CustomMarker(position: pickupLocation),
                CustomMarker(position: dropoffLocation),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Drop-off Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            LocationSearchWidget(
              mapController: mapController,
              onPlaceSelected: (place) {
                final lat = place.geometry?.location.lat;
                final lng = place.geometry?.location.lng;

                if (lat != null && lng != null) {
                  setState(() {
                    dropoffLocation = LatLng(lat, lng);
                    // Update the pickup marker's position
                    dropoffMarker = Marker(
                      markerId: MarkerId("dropoffLocation"),
                      position: dropoffLocation,
                      draggable: true, // Make the marker draggable
                      onDragEnd: (value) {
                        setState(() {
                          dropoffLocation = value;
                        });
                      },
                    );
                    mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(dropoffLocation, 17.0),
                    );
                  });
                }
              },
            ),
            // Drop-off Location Text

            // Drop-off Location Text Field
            // TextField(
            //   onChanged: (value) {
            //     setState(() {
            //       // dropOffLocation = value;
            //     });
            //   },
            //   decoration: InputDecoration(
            //     hintText: 'Enter drop-off location',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),

            // Vehicle Type Text
            Expanded(
              child:
              DraggableScrollableSheet(
                initialChildSize:
                    0.3, // Initial size when closed (20% of screen)
                minChildSize: 0.2, // Minimum size (20% of screen)
                maxChildSize:
                    0.9, // Maximum size when fully open (90% of screen)
                expand: true,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      border: Border.all(color: Colors.black,style: BorderStyle.solid),
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: vehicleOptions.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedVehicleIndex = index;
                            });
                            _showConfirmationDialog(
                                context, vehicleOptions[index]);
                          },
                          child: Row(
                            children: [
                              Container(margin: EdgeInsets.all(7),
                              child: ImageIcon(
                                AssetImage(vehicleOptions[index].iconAsset),
                                size: 80,
                                color: selectedVehicleIndex == index
                                    ? Colors.blue // Highlight color
                                    : Colors.black, // Regular color
                              ),),
                              Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    vehicleOptions[index].name,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: selectedVehicleIndex == index
                                          ? Colors.blue // Highlight color
                                          : Colors.black, // Regular color
                                    ),
                                  ),
                                  Text(
                                    '\$${vehicleOptions[index].price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height:20),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Share My Location Checkbox
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
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _submitRideRequest();
          },
          label: Text("Request Ride"),
        ));
  }

  void updatePickupLocation(LatLng newLocation) {
    setState(() {
      pickupLocation = newLocation;
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
    print('Drop-off Location: $dropoffLocation');
    print('Selected Vehicle: $selectedVehicle');
    print('Sharing Location: $isSharingLocation');
  }
}

void main() {
  runApp(MaterialApp(
    home: RideRequestScreen(),
  ));
}
