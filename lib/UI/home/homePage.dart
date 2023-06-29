// ignore_for_file: file_names

import 'package:app_wisata/UI/auth/loginPage.dart';
import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/UI/data_category/dataCategory.dart';
import 'package:app_wisata/UI/data_post/dataPost.dart';
import 'package:app_wisata/UI/detail/detailPost.dart';
import 'package:app_wisata/UI/notifikasi/notifikasiPage.dart';
import 'package:app_wisata/UI/profil/profilPage.dart';
import 'package:app_wisata/UI/settingg/settingPage.dart';
import 'package:app_wisata/UI/widget/category.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/models/post.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ErrorMSG response;
  // ignore: unused_field
  List<Post> _posts = [];
  // ignore: unused_field
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Post> posts = await ApiStatic.getPost();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      // ignore: avoid_print
      print('Failed to fetch posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    await fetchPosts();
  }

  void _showPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => PostDetailPage(post: post),
        builder: (context) => DetailPost(
          post: post,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        titleTextStyle: const TextStyle(fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white, size: 25),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.notification_add,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Constants.primaryColor),
              accountName: Text('Kadek Widiana'),
              accountEmail: Text('kdkonos10@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/widi.png'),
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilPage()));
              },
            ),
            ListTile(
              title: const Text('Data Post'),
              leading: const Icon(Icons.post_add),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DataPosts()));
              },
            ),
            ListTile(
              title: const Text('Data Category'),
              leading: const Icon(Icons.post_add),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataCategory()));
              },
            ),
            ListTile(
              title: const Text('Notifikasi'),
              leading: const Icon(Icons.notifications),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()));
              },
            ),
            ListTile(
              title: const Text('Setting'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
              },
            ),
            const Expanded(
                child:
                    SizedBox()), // Expanded widget to push LogOut to the bottom
            ListTile(
              title: const Text('Log Out'),
              leading: const Icon(Icons.logout_outlined),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Konfirmasi Log-out"),
                      content: const Text("Apakah Anda yakin ingin Log-out?"),
                      actions: [
                        TextButton(
                          child: const Text("Batal"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                          },
                        ),
                        TextButton(
                          child: const Text("Log-out"),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                // ignore: unnecessary_new
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen())); // Jalankan fungsi hapus
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 70,
                  width: double.infinity,
                  color: Constants.primaryColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F7),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextField(
                          cursorHeight: 20,
                          autofocus: false,
                          decoration: InputDecoration(
                              hintText: "Cari Tempat Favoritmu !",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Category(imagePath: "assets/beach.png", title: "Pantai"),
                    Category(imagePath: "assets/creek.png", title: "Gunung"),
                    Category(
                        imagePath: "assets/waterfall.png", title: "Air terjun"),
                    Category(imagePath: "assets/tent.png", title: "Camp"),
                    Category(
                        imagePath: "assets/tracking.png", title: "Tracking"),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Tempat wisata",
                style: GoogleFonts.montserrat(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                width: double.infinity,
                height: 360,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshPosts,
                        child: ListView.builder(
                            itemCount: _posts.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == _posts.length) {
                                if (_isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                              Post post = _posts[index];

                              return SizedBox(
                                width: double.infinity,
                                height: 240,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          bottom: 5,
                                          top: 5),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.grey,
                                              width: 1), // Garis tepi (outline)
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 10,
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              // ignore: avoid_unnecessary_containers
                                              child: Container(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  height: 150,
                                                  child: Image.network(
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    ApiStatic.host +
                                                        "/storage/" +
                                                        post.image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                _showPostDetail(post);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 10,
                                      child: SizedBox(
                                        height: 70,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(post.title,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.red),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(post.name_location,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 12)),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  // const Icon(
                                                  //   Icons.category_outlined,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  // const SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  // Text(
                                                  //   "Category",
                                                  //   style:
                                                  //       GoogleFonts.montserrat(
                                                  //     fontSize: 12,
                                                  //   ),
                                                  // )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }))),
          ],
        )),
      ),
    );
  }
}
