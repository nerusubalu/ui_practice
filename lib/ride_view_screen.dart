import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as directionspkg;
import 'package:ui_practice/ride_request_screen.dart';

class RideInfo {
  final String pickupLocation;
  final String dropLocation;
  final String rideDuration;
  final String startTime;
  final String endTime;
  final String distance;
  final LatLng sourceLatLng;
  final LatLng destinationLatLng;
  RideInfo({
    required this.pickupLocation,
    required this.dropLocation,
    required this.rideDuration,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.sourceLatLng,
    required this.destinationLatLng,
  });
}
// import 'package:polyline/polyline.dart' as polyline;

class RideViewScreen extends StatefulWidget {
  final RideInfo rideInfo;

  RideViewScreen({required this.rideInfo});

  @override
  _RideViewScreenState createState() => _RideViewScreenState();
}

class _RideViewScreenState extends State<RideViewScreen> {
  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
      ),
      body: Column(
        children: [
          // Display Ride Details
          ListTile(
            title: Text('Pickup Location: ${widget.rideInfo.pickupLocation}'),
            subtitle: Text('Drop Location: ${widget.rideInfo.dropLocation}'),
          ),
          ListTile(
            title: Text('Ride Duration: ${widget.rideInfo.rideDuration}'),
            subtitle: Text('Distance: ${widget.rideInfo.distance}'),
          ),
          ListTile(
            title: Text('Start Time: ${widget.rideInfo.startTime}'),
            subtitle: Text('End Time: ${widget.rideInfo.endTime}'),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.rideInfo
                    .sourceLatLng, // Set initial camera position to the source location
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                  _fetchAndDrawRoute(widget.rideInfo.sourceLatLng,
                      widget.rideInfo.destinationLatLng);
                });
              },
              polylines: _polylines,
              markers: {
                Marker(
                  markerId: MarkerId('source'),
                  position: widget.rideInfo.sourceLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  infoWindow: InfoWindow(
                      title: 'Source', snippet: widget.rideInfo.pickupLocation),
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: widget.rideInfo.destinationLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                      title: 'Destination',
                      snippet: widget.rideInfo.dropLocation),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ride Details:'),
          ),
          // Display other ride details here using widget.rideInfo
        ],
      ),
    );
  }

  Future<void> _fetchAndDrawRoute(
      LatLng sourceLatLng, LatLng destinationLatLng) async {
    final directionsResponse = await directions.directions(
      directionspkg.Location(
          lat: sourceLatLng.latitude, lng: sourceLatLng.longitude), // Origin
      directionspkg.Location(
          lat: destinationLatLng.latitude,
          lng: destinationLatLng.longitude), // Destination
      travelMode: directionspkg.TravelMode.driving, // Travel mode
      trafficModel: directionspkg.TrafficModel.optimistic,
    );

    if (directionsResponse.isOkay) {
      final route = directionsResponse.routes.first;
      // final encodedPolyline = route.overviewPolyline.points;
      final List<LatLng> polylinePoints = [];
      for (final leg in route.legs) {
        for (final step in leg.steps) {
          final encodedPolyline = step.polyline.points;
          final List<PointLatLng> decodedPolyline =
              PolylinePoints().decodePolyline(encodedPolyline);

          // Convert PointLatLng to LatLng
          final List<LatLng> latLngPoints = decodedPolyline
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          polylinePoints.addAll(latLngPoints);
        }
      }

      // Draw the route on the map as a Polyline
      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylinePoints,
          color: Colors.blue,
          width: 5,
        ));
      });
    } else {
      // Handle API error
      print('Directions API error: ${directionsResponse.errorMessage}');
    }
  }
}
