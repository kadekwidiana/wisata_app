// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/logo_wisata.png',
                  height: 170,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                '',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Fitur Utama',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.image_search_sharp),
                  title: Text('Pencarian tempat wisata'),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.menu_book_rounded),
                  title: Text('Category tempat wisata'),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.location_on_outlined),
                  title: Text('Cek lokasi google maps'),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Kontak dan Informasi Tambahan',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Alamat: Jl. Sambangan No. 123, Singaraja\n'
                'Telepon: 083-120-743-647\n'
                'Email: wisata_app@gmail.com\n'
                'Media Sosial: @wisata_apps',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildTeamMember(String image, String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 40.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
