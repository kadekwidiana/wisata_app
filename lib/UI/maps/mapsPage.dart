// ignore_for_file: file_names, unused_field

import 'package:app_wisata/UI/constanta.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  // ignore: prefer_final_fields
  List<MapType> _mapTypes = [
    MapType.normal,
    MapType.satellite,
    MapType.terrain,
    MapType.hybrid,
  ];
  // ignore: prefer_final_fields
  MapType _selectedMapType = MapType.normal;
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
      backgroundColor: Constants.primaryBackground,
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: const Text('Survey location'),
        leading: null,
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
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              mapType: _selectedMapType,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-8.3778989, 115.0632632),
                zoom: 10,
              ),
              markers: {
                const Marker(
                    markerId: MarkerId('value'),
                    position: LatLng(-8.140017769824222, 115.09374381485483))
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
    );
  }
}
