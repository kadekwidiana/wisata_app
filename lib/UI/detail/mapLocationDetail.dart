// ignore_for_file: file_names, unused_field, prefer_const_constructors_in_immutables

import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/models/post.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationDetail extends StatefulWidget {
  final Post post;

  const MapLocationDetail({required this.post, Key? key}) : super(key: key);

  @override
  State<MapLocationDetail> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapLocationDetail> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryBackground,
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: Text(
          widget.post.name_location,
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
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(widget.post.latitude),
                    double.parse(widget.post.longitude)),
                zoom: 15,
              ),
              markers: {
                Marker(
                    markerId: MarkerId(widget.post.name_location),
                    position: LatLng(double.parse(widget.post.latitude),
                        double.parse(widget.post.longitude)),
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: InfoWindow(
                      title: widget.post.title,
                      snippet: widget.post.name_location,
                    )),
              },
            ),
          ),
        ],
      ),
    );
  }
}
