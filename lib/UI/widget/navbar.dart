import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/UI/favorit/favoritPage.dart';
import 'package:app_wisata/UI/home/homePage.dart';
import 'package:app_wisata/UI/maps/mapsPage.dart';
import 'package:app_wisata/UI/profil/profilPage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomePage(),
    const FavoritPage(),
    const MapsPage(),
    const AboutDialog(),
    const ProfilPage(),
    // Add your additional screens here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Constants.primaryColor,
        color: Constants.secondaryColor,
        activeColor: Constants.primaryBackground,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.favorite, title: 'Favorit'),
          TabItem(icon: Icons.map_sharp, title: 'Maps'),
          TabItem(icon: Icons.album_outlined, title: 'About'),
          TabItem(icon: Icons.person, title: 'Profil'),
          // Add your additional tabs here
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
