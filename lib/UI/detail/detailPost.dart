// ignore_for_file: file_names, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, sort_child_properties_last

import 'package:app_wisata/UI/detail/mapLocationDetail.dart';
import 'package:app_wisata/models/post.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPost extends StatefulWidget {
  final Post post;

  const DetailPost({required this.post, Key? key}) : super(key: key);

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stack Foto dan container
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: height * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          ApiStatic.host + "/storage/" + widget.post.image,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.post.title,
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    height: height * .07,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 8,
              //     right: 20,
              //     top: 10,
              //     bottom: 8,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               const Icon(
              //                 Icons.person,
              //                 color: Colors.grey,
              //               ),
              //               const SizedBox(width: 5),
              //               Text(
              //                 widget.post.idUser.toString(),
              //                 style: GoogleFonts.montserrat(fontSize: 12),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           const Icon(
              //             Icons.category,
              //             color: Colors.grey,
              //           ),
              //           const SizedBox(width: 5),
              //           Text(
              //             widget.post.idCategory.toString(),
              //             style: GoogleFonts.montserrat(
              //               fontSize: 14,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapLocationDetail(
                        post: widget.post,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.post.name_location,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Deskripsi
              TitleDetail(
                  title: "Deskripsi :", detail: widget.post.description),
            ],
          ),
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String image;
  final String username;
  final String coment;

  const Comment({
    Key? key,
    required this.image,
    required this.username,
    required this.coment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                image,
                width: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username),
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            coment,
            style: GoogleFonts.montserrat(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class TitleDetail extends StatelessWidget {
  final String title;
  final String detail;

  const TitleDetail({
    Key? key,
    required this.title,
    required this.detail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            detail,
            style: GoogleFonts.montserrat(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
