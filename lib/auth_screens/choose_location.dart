import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoder/geocoder.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  GoogleMapController _controller;
  String _address = "";
  List<Marker> myMarker = [];
  Marker marker;
  LatLng tappedPoint;

  void onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
  }

  _handleTap(LatLng latlng) {
    setState(() {
      myMarker = [];
      tappedPoint = latlng;
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true));
      print(tappedPoint);
      _getAddress(tappedPoint.latitude, tappedPoint.longitude).then(
        (value) {
          setState(
            () {
              _address = "${value.first.addressLine}";
              print("Address = " + _address);
            },
          );
        },
      );
    });
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF785B),
        centerTitle: true,
        title: Text("Choose Location",
            style: GoogleFonts.lexendDeca(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF785B),
        child: Text('GO'),
        onPressed: () => Navigator.pop(context, _address),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: GoogleMap(
              zoomControlsEnabled: false,
              initialCameraPosition:
                  CameraPosition(target: LatLng(19.0473, 73.0699), zoom: 14),
              onMapCreated: onMapCreated,
              onTap: _handleTap,
              markers: Set.from(myMarker),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                _address == "" ? "Choose Location" : _address,
                style: GoogleFonts.lexendDeca(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
