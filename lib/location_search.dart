
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
class LocationSearchWidget extends StatefulWidget {
  final ValueChanged<PlaceDetails>? onPlaceSelected;
  final GoogleMapController? mapController;

  LocationSearchWidget({Key? key, this.onPlaceSelected, this.mapController})
      : super(key: key);

  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  String location = "Search Location";
  String googleApiKey = "AIzaSyC_fTRYkMSyaBZTxS7CkE2P-WLVs-craq0"; // Replace with your API key

  Future<void> _onTapLocation() async {
    final place = await PlacesAutocomplete.show(
      context: context,
      apiKey: googleApiKey,
      mode: Mode.overlay,
      types: [],
      strictbounds: false,
      components: [Component(Component.country, 'in')],
      onError: (err) {
        print(err);
      },
    );

    if (place != null) {
      final plist = GoogleMapsPlaces(
        apiKey: googleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );

      final placeId = place.placeId ?? "0";
      final detail = await plist.getDetailsByPlaceId(placeId);
      final geometry = detail.result.geometry!;
      final lat = geometry.location.lat;
      final lng = geometry.location.lng;
      final newLatLang = LatLng(lat, lng);

      setState(() {
        location = place.description.toString();
      });

      widget.mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLang, zoom: 17),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTapLocation,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width - 40,
            child: ListTile(
              title: Text(location, style: TextStyle(fontSize: 18), maxLines: 1),
              trailing: Icon(Icons.search),
              dense: true,
            ),
          ),
        ),
      ),
    );
  }
}

//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   GoogleMapController? mapController;
//   LatLng startLocation = const LatLng(13.439835573409283, 78.3927378579796);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Location Search with AutoComplete"),
//       ),
//       body: Column(
//         children: [
//           LocationSearchWidget(
//             mapController: mapController,
//             onPlaceSelected: (place) {
//               final lat = place.geometry?.location.lat;
//               final lng = place.geometry?.location.lng;
//
//               if (lat != null && lng != null) {
//                 mapController?.animateCamera(
//                   CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17.0),
//                 );
//               }
//             },
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
// class LocationSearchWidget extends StatefulWidget {
//   final ValueChanged<PlaceDetails>? onPlaceSelected;
//   final GoogleMapController? mapController;
//
//   LocationSearchWidget({Key? key, this.onPlaceSelected, this.mapController})
//       : super(key: key);
//
//   @override
//   _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
// }
//
// class _LocationSearchWidgetState extends State<LocationSearchWidget> {
//   String location = "Search Location";
//   String googleApiKey = "AIzaSyC_fTRYkMSyaBZTxS7CkE2P-WLVs-craq0";
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         var place = await PlacesAutocomplete.show(
//           context: context,
//           apiKey: googleApiKey,
//           mode: Mode.overlay,
//           types: [],
//           strictbounds: false,
//           components: [Component(Component.country, 'in')],
//           onError: (err) {
//             print(err);
//           },
//         );
//
//         if (place != null) {
//           setState(() {
//             location = place.description.toString();
//           });
//
//           final plist = GoogleMapsPlaces(
//             apiKey: googleApiKey,
//             apiHeaders: await GoogleApiHeaders().getHeaders(),
//           );
//
//           String placeId = place.placeId ?? "0";
//           final detail = await plist.getDetailsByPlaceId(placeId);
//           final geometry = detail.result.geometry!;
//           final lat = geometry.location.lat;
//           final lang = geometry.location.lng;
//           var newLatLang = LatLng(lat, lang);
//           // print(newLatLang);
//           widget.mapController?.animateCamera(
//             CameraUpdate.newCameraPosition(
//               CameraPosition(target: newLatLang, zoom: 17),
//             ),
//           );
//         }
//       },
//       child: Padding(
//         padding: EdgeInsets.all(15),
//         child: Card(
//           child: Container(
//             padding: EdgeInsets.all(0),
//             width: MediaQuery.of(context).size.width - 40,
//             child: ListTile(
//               title: Text(location, style: TextStyle(fontSize: 18), maxLines: 1, ),
//               trailing: Icon(Icons.search),
//               dense: true,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
