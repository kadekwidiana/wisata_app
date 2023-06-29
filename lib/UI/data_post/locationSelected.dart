// ignore_for_file: file_names

import 'package:app_wisata/UI/constanta.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationSelectionScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  // ignore: use_key_in_widget_constructors
  const LocationSelectionScreen({
    required this.initialLatitude,
    required this.initialLongitude,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  late GoogleMapController mapController;
  late LatLng selectedLocation;

  // ignore: prefer_final_fields
  List<MapType> _mapTypes = [
    MapType.normal,
    MapType.satellite,
    MapType.terrain,
    MapType.hybrid,
  ];
  // ignore: prefer_final_fields
  MapType _selectedMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    selectedLocation = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTap(LatLng location) {
    setState(() {
      selectedLocation = location;
    });
  }

  void _selectLocation() {
    Navigator.pop(context, selectedLocation);
  }

  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();

  void _searchLocation() async {
    String address = _searchController.text;
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          15,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<MapType>(
                value: _selectedMapType,
                items: _mapTypes.map((MapType mapType) {
                  return DropdownMenuItem<MapType>(
                    value: mapType,
                    child: Text(mapType.toString()),
                  );
                }).toList(),
                onChanged: (MapType? value) {
                  setState(() {
                    _selectedMapType = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLocation,
                zoom: 14,
              ),
              mapType: _selectedMapType,
              onMapCreated: _onMapCreated,
              onTap: _onMapTap,
              markers: {
                Marker(
                  markerId: const MarkerId('selected_location'),
                  position: selectedLocation,
                ),
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants.primaryBackground,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  cursorHeight: 20,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: "Type address...",
                    contentPadding: const EdgeInsets.only(left: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchLocation,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Constants.secondaryBackground, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Constants.secondaryBackground,
                          width: 2), // Warna border saat fokus
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _selectLocation,
        // ignore: sort_child_properties_last
        child: const Icon(Icons.check),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: const BorderSide(color: Constants.secondaryColor, width: 3.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
