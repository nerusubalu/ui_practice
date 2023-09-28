import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ui_practice/location_search.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:ui_practice/user_profile_screen.dart';
import 'package:ui_practice/custom_drawer.dart';
import 'package:google_maps_webservice/directions.dart' as directionspkg;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:ui_practice/vehicles.dart';

final directions = directionspkg.GoogleMapsDirections(
    apiKey: 'AIzaSyBKCOVTBJuaYswfKPs0I8WbQxhb_1eKHS8');

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
  Set<Polyline> polylines = {};
  Marker? dropoffMarker;
  bool flag = false;
  LatLng dropoffLocation = LatLng(0, 0);
  String selectedVehicle = 'Standard';
  bool isSharingLocation = false;
  int selectedVehicleIndex = -1;
  GoogleMapController? mapController;
  LocationData? userLocation;
  Set<Marker> markers = <Marker>{};
  // List<Marker> markers = [];
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

  Location location = Location();
  String currentLocationDescription = "Search Destination";

  Future<void> getLocationDescription(LatLng location) async {
    try {
      final List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final geocoding.Placemark placemark = placemarks[0];
        final String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}';
        currentLocationDescription = address;
      } else {
        print('Location not found');
      }
    } catch (e) {
      print('Error: $e');
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
        markers.add(
          Marker(
            markerId: MarkerId("pickupLocation"),
            position: pickupLocation,
            draggable: true,
            onDragEnd: (value) {
              setState(() {
                pickupLocation = value;
              });
            },
          ),
        );
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
          centerTitle: false,
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
                    radius: 17,
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
            LocationSearchWidget(
              googleApiKey: 'AIzaSyC_fTRYkMSyaBZTxS7CkE2P-WLVs-craq0',
              location: "Your Current Location",
              onPlaceSelected: (description, latLng) {
                print('Selected Place: $description');
                print('LatLng: $latLng');
                setState(() {
                  pickupLocation = latLng;
                  mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(pickupLocation, 17));
                  markers.add(
                    Marker(
                      markerId: MarkerId("pickupLocation"),
                      position: pickupLocation,
                      draggable: true,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                      onDragEnd: (value) {
                        setState(() {
                          pickupLocation = value;
                        });
                      },
                    ),
                  );
                  if (dropoffLocation.latitude != 0) {
                    _getAndDrawRoute(pickupLocation, dropoffLocation);
                  }
                });
                // Perform actions with the selected place and LatLng here
              },
            ),
            Expanded(
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 400,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:
                          pickupLocation, // Use currentLocation as the initial camera position
                      zoom: 14.0,
                    ),
                    polylines: polylines,
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    buildingsEnabled: true,
                    markers: markers,
                    onCameraMove: (position) {
                      setState(() {
                        pickupLocation = position.target;
                        if (dropoffLocation.latitude == 0) {
                          // print(dropoffLocation);
                          markers.add(
                            Marker(
                              markerId: MarkerId("pickupLocation"),
                              position: position.target,
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueGreen),
                              draggable: true,
                              onDragEnd: (value) {
                                setState(() {
                                  pickupLocation = value;
                                });
                              },
                            ),
                          );
                          currentLocation = pickupLocation;

                          flag = true;
                        }
                      });
                    },
                    myLocationButtonEnabled: true,
                  ),
                ),
              ]),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Text(
            //   'Drop-off Location',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            LocationSearchWidget(
              googleApiKey: 'AIzaSyC_fTRYkMSyaBZTxS7CkE2P-WLVs-craq0',
              location: currentLocationDescription,
              onPlaceSelected: (description, latLng) {
                print('Selected Place: $description');
                print('LatLng: $latLng');
                setState(() {
                  dropoffLocation = latLng;
                  markers.add(
                    Marker(
                      markerId: MarkerId("dropofLocation"),
                      position: dropoffLocation,
                      draggable: true,
                      onDragEnd: (value) {
                        setState(() {
                          dropoffLocation = value;
                        });
                      },
                    ),
                  );
                  mapController?.animateCamera(
                      CameraUpdate.newLatLngZoom(dropoffLocation, 14));
                  // _drawRoute();
                  currentLocationDescription = description;
                  // _getAndDrawRoute(pickupLocation, dropoffLocation);
                  if (pickupLocation.latitude != 0) {
                    _getAndDrawRoute(pickupLocation, dropoffLocation);
                  }
                });
                // Perform actions with the selected place and LatLng here
              },
            ),
            // SizedBox(height: 16),

            // Vehicle Type Text
            //
            VehicleSelectionScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _submitRideRequest();
            },
          icon: Icon(Icons.rocket_launch),
            label: const Text("Ride", style: TextStyle(fontSize: 20),),
            ));
    // FloatingActionButton.extended(
    //   onPressed: () {
    //     _submitRideRequest();
    //   },
    //   label: Text("Request Ride"),
    // ));
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

  void _submitRideRequest() {
    // Perform logic to submit the ride request
    print('Ride requested');
    print('Pickup Location: $pickupLocation');
    print('Drop-off Location: $dropoffLocation');
    print('Selected Vehicle: $selectedVehicle');
    print('Sharing Location: $isSharingLocation');
  }

  Future<void> _getAndDrawRoute(
      LatLng originPlace, LatLng destinationPlace) async {
    final directionsResponse = await directions.directions(
      directionspkg.Location(
          lat: originPlace.latitude, lng: originPlace.longitude), // Origin
      directionspkg.Location(
          lat: destinationPlace.latitude,
          lng: destinationPlace.longitude), // Destination
      travelMode: directionspkg.TravelMode.driving, // Travel mode
      // trafficModel: directionspkg.TrafficModel.bestGuess,
    );

    if (directionsResponse.isOkay) {
      final route = directionsResponse.routes.first;

      // Extract the polyline points from the route
      final List<LatLng> polylinePoints = [];
      for (final leg in route.legs) {
        for (final step in leg.steps) {
          final encodedPolyline = step.polyline.points;
          final List<PointLatLng> decoded =
              PolylinePoints().decodePolyline(encodedPolyline);

          // Convert PointLatLng to LatLng
          final List<LatLng> latLngPoints = decoded
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          polylinePoints.addAll(latLngPoints);
        }
      }

      // Draw the polyline on the map
      setState(() {
        polylines.clear();
        polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylinePoints,
          color: Colors.black, // Change this to your desired color
          width: 2, // Change this to your desired width
        ));
      });
    } else {
      // Handle API error
      print('Directions API error: ${directionsResponse.errorMessage}');
    }
  }

}

void main() {
  runApp(MaterialApp(
    home: RideRequestScreen(),
  ));
}
