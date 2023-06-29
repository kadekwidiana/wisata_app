// ignore_for_file: file_names, unnecessary_new, use_key_in_widget_constructors, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:io';

import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/models/category.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/models/post.dart';
import 'package:app_wisata/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:geolocator/geolocator.dart';

import 'dataPost.dart';
import 'locationSelected.dart';

class InputPost extends StatefulWidget {
  final Post post;
  // ignore: prefer_const_constructors_in_immutables
  InputPost({required this.post});

  @override
  State<InputPost> createState() => _InputPostState();
}

class _InputPostState extends State<InputPost> {
  // ignore: unused_field
  late Position _currentPosition;

  late GoogleMapController mapController;
  final _formkey = GlobalKey<FormState>();
  late TextEditingController title,
      // category,
      image,
      name_location,
      latitude,
      longitude,
      description;
  late List<Category> _category = [];
  // ignore: unused_field
  late List<User> _user = [];
  late int id = 0;
  late int idCategory = 0;
  late int idUser = 0;
  bool _isupdate = false;
  // ignore: unused_field
  bool _validate = false;
  bool _success = false;
  late ErrorMSG response;
  late String _imagePath = '';
  late String _imageURL = '';
  final ImagePicker _picker = ImagePicker();
  void getCategory() async {
    final response = await ApiStatic.getCategory();
    setState(() {
      _category = response.toList();
    });
  }

  void getUser() async {
    final response = await ApiStatic.getUser();
    setState(() {
      _user = response.toList();
    });
  }

  @override
  void initState() {
    title = TextEditingController();
    name_location = TextEditingController();
    latitude = TextEditingController();
    longitude = TextEditingController();
    description = TextEditingController();
    // selectedCategory = null;
    getCategory();
    getUser();
    // selectedCategory = widget.post.category;
    if (widget.post.id != 0) {
      id = widget.post.id;
      idCategory = widget.post.idCategory;
      idUser = widget.post.idUser;
      title = TextEditingController(text: widget.post.title);
      name_location = TextEditingController(text: widget.post.name_location);
      latitude = TextEditingController(text: widget.post.latitude);
      longitude = TextEditingController(text: widget.post.longitude);
      description = TextEditingController(text: widget.post.description);
      _isupdate = true;
      // ignore: prefer_interpolation_to_compose_strings
      _imageURL = ApiStatic.host + '/storage/' + widget.post.image;
      // selectedCategory = widget.post.category;
    }
    // init getlocation
    // _getCurrentLocation();
    if (!_isupdate) {
      _getCurrentLocation();
    }

    super.initState();
  }

  // func submit
  void submit() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      var params = {
        'id_user': idUser,
        'id_category': idCategory,
        'title': title.text.toString(),
        'name_location': name_location.text.toString(),
        'latitude': latitude.text.toString(),
        'longitude': longitude.text.toString(),
        'description': description.text.toString(),
      };
      response = await ApiStatic.savePost(id, params, _imagePath);
      _success = response.success;
      final snackBar = SnackBar(
        content: Text(response.message),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (_success) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => const DataPosts()));
      } else {}
    } else {
      _validate = true;
    }
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       _currentPosition = position;
  //       latitude.text = _currentPosition.latitude.toString();
  //       longitude.text = _currentPosition.longitude.toString();
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, display an error message.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text('Please enable location services.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, display an error message.
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location Permissions Denied'),
              content: const Text(
                  'Please grant location permissions to access your current location.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, display an error message.
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permissions Denied Forever'),
            content: const Text(
                'Location permissions are permanently denied. Please enable them in your device settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Permissions are granted, get the current position.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude.text = position.latitude.toString();
      longitude.text = position.longitude.toString();
    });
  }

  void _editLocation() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
            initialLatitude: double.parse(latitude.text),
            initialLongitude: double.parse(longitude.text)),
      ),
    );

    if (selectedLocation != null && selectedLocation is LatLng) {
      setState(() {
        latitude.text = selectedLocation.latitude.toString();
        longitude.text = selectedLocation.longitude.toString();
      });
    }
  }

  // ignore: unused_element
  void _moveToLocation(double lat, double lng) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isupdate
            // ignore: prefer_interpolation_to_compose_strings
            ? Text('Update ' + widget.post.title)
            : const Text('Input data'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: DropdownButtonFormField(
                    value: idUser == 0 ? null : idUser,
                    hint: const Text("Author"),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                    ),
                    items: _user.map((item) {
                      return DropdownMenuItem(
                        // ignore: sort_child_properties_last
                        child: Text(item.name),
                        value: item.id.toInt(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        idUser = value as int;
                      });
                    },
                    validator: (u) => u == null ? "Wajib Diisi " : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: title,
                    validator: (u) => u == "" ? "Wajib isi" : null,
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.title),
                        hintText: "Title",
                        labelText: "Title"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: DropdownButtonFormField(
                    value: idCategory == 0 ? null : idCategory,
                    hint: const Text("Pilih Category"),
                    items: _category.map((item) {
                      return DropdownMenuItem(
                        // ignore: sort_child_properties_last
                        child: Text(item.categoryName),
                        value: item.id.toInt(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        idCategory = value as int;
                      });
                    },
                    validator: (u) => u == null ? "Wajib Diisi " : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.image),
                      Flexible(
                          child: _imagePath != ''
                              ? GestureDetector(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_imagePath),
                                      fit: BoxFit.fitWidth,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                    ),
                                  ),
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                  })
                              : _imageURL != ''
                                  ? GestureDetector(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          _imageURL,
                                          fit: BoxFit.fitWidth,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                        ),
                                      ),
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                      })
                                  : GestureDetector(
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                      },
                                      child: Container(
                                        height: 100,
                                        // ignore: sort_child_properties_last
                                        child: const Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                            ),
                                            Text(
                                              " Pilih Gambar .",
                                              style: TextStyle(
                                                  // color: Colors.white,
                                                  backgroundColor: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.brown,
                                                    width: 2))),
                                      ),
                                    ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: description,
                    validator: (u) => u == "" ? "Wajib isi" : null,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      // icon: Icon(Icons.title),
                      hintText: "Description",
                      labelText: "Description",
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: name_location,
                    validator: (u) => u == "" ? "Wajib isi" : null,
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.title),
                        hintText: "Lokasi wisata",
                        labelText: "Lokasi wisata"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: latitude,
                    validator: (u) => u == "" ? "Wajib isi" : null,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.title),
                        hintText: "Latitude",
                        labelText: "Latitude"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    controller: longitude,
                    validator: (u) => u == "" ? "Wajib isi" : null,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.title),
                        hintText: "Longitude",
                        labelText: "Longitude"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: _getCurrentLocation,
                                child: const Text("Dapatkan Posisi Saat Ini"),
                              ),
                              // Visibility(
                              //   visible:
                              //       !_isupdate, // Hide the button when _isupdate is true
                              //   child: ElevatedButton(
                              //     onPressed: _getCurrentLocation,
                              //     child: const Text("Dapatkan Posisi Saat Ini"),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'Map Pointer',
                                style: TextStyle(
                                    color: Constants.fontColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _editLocation();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Constants.primaryColor),
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(50, 30),
                              ),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                double.tryParse(latitude.text) ??
                                    -8.143445607987452,
                                double.tryParse(longitude.text) ??
                                    115.09561433043577),
                            zoom: _isupdate ? 14 : 11,
                          ),
                          onMapCreated: (controller) {
                            setState(() {
                              mapController = controller;
                            });
                          },
                          mapType: MapType.normal,
                          markers: {
                            Marker(
                              markerId: const MarkerId('selected_location'),
                              position: LatLng(
                                  double.tryParse(latitude.text) ?? 0.0,
                                  double.tryParse(longitude.text) ?? 0.0),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        child: const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource media) async {
    var img = await _picker.pickImage(source: media);
    //final pickedImageFile = File(img!.path);
    setState(() {
      _imagePath = img!.path;
      // ignore: avoid_print
      print(_imagePath);
    });
  }
}
