import 'package:app_wisata/UI/about/aboutPage.dart';
import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/UI/favorit/favoritPage.dart';
import 'package:app_wisata/UI/home/homePage.dart';
import 'package:app_wisata/UI/maps/mapsPage.dart';
import 'package:app_wisata/UI/profil/profilPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Navbar2 extends StatefulWidget {
  const Navbar2({super.key});

  @override
  State<Navbar2> createState() => _Navbar2State();
}

class _Navbar2State extends State<Navbar2> {
  int index = 0;

  final screens = [
    const HomePage(),
    const FavoritPage(),
    const MapsPage(),
    AboutPage(),
    const ProfilPage()
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.home,
        size: index == 0 ? 40 : 30,
      ),
      Icon(
        Icons.favorite,
        size: index == 1 ? 40 : 30,
      ),
      Icon(
        Icons.my_location_sharp,
        size: index == 2 ? 40 : 30,
      ),
      Icon(
        Icons.photo_album_outlined,
        size: index == 3 ? 40 : 30,
      ),
      Icon(
        Icons.person,
        size: index == 4 ? 40 : 30,
      ),
    ];
    return Scaffold(
      extendBody: true,
      body: screens[index],
      backgroundColor: Colors.blue,
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Constants.primaryColor,
          height: 60,
          index: index,
          items: items,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );
  }
}
