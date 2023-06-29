// ignore_for_file: file_names, unused_import

import 'package:app_wisata/UI/constanta.dart';
import 'package:app_wisata/UI/detail/detailPost.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/models/post.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
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
        title: const Text('Tempat favorit'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: double.infinity,
                height: 660,
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
                                    ),
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
