import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class LocationSearchWidget extends StatefulWidget {
  final String googleApiKey;
  final Function(String, LatLng)? onPlaceSelected;
  final String location;

  LocationSearchWidget({required this.googleApiKey, this.onPlaceSelected, required this.location});

  @override
  _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  String location = "Search Location";

  Future<void> _onTapLocation(BuildContext context) async {
    final place = await PlacesAutocomplete.show(
      context: context,
      apiKey: widget.googleApiKey,
      mode: Mode.overlay,
      types: [],
      strictbounds: false,
      components: [Component(Component.country, 'in')],
      onError: (err) {
        print(err);
      },
    );

    if (place != null && widget.onPlaceSelected != null) {
      final plist = GoogleMapsPlaces(
        apiKey: widget.googleApiKey,
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

      // widget.mapController?.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: newLatLang, zoom: 17),
      //   ),
      // );

      widget.onPlaceSelected!(place.description.toString(), newLatLang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTapLocation(context),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: ListTile(
              title: Text(widget.location, style: TextStyle(fontSize: 18), maxLines: 1),
              trailing: Icon(Icons.search),
              dense: true,
            ),
          ),
        ),
      ),
    );
  }
}
