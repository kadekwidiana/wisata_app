// ignore_for_file: file_names

import 'package:app_wisata/UI/detail/detailPost.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/models/post.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/material.dart';

import 'inputPost.dart';

class DataPosts extends StatefulWidget {
  const DataPosts({super.key});

  @override
  State<DataPosts> createState() => _DataPostsState();
}

class _DataPostsState extends State<DataPosts> {
  late ErrorMSG response;
  List<Post> _posts = [];
  bool _isLoading = false;
  void deletePost(id) async {
    response = await ApiStatic.deletePost(id);
    final snackBar = SnackBar(
      content: Text(response.message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const DataPosts()),
    );
  }

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
        builder: (context) => DetailPost(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data posts'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InputPost(
                        post: Post(
                            id: 0,
                            idUser: 0,
                            idCategory: 0,
                            title: '',
                            image: '',
                            latitude: '',
                            longitude: '',
                            name_location: '',
                            description: ''))));
          }),
      body: _isLoading
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
                  return GestureDetector(
                    onTap: () {
                      _showPostDetail(post);
                    },
                    child: ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.name_location),
                      leading: Image.network(
                          // ignore: prefer_interpolation_to_compose_strings
                          ApiStatic.host + "/storage/" + post.image),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InputPost(post: post)));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Konfirmasi Hapus"),
                                    content: const Text(
                                        "Apakah Anda yakin ingin menghapus post ini?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Batal"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Hapus"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Tutup dialog
                                          deletePost(
                                              post.id); // Jalankan fungsi hapus
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
                  );
                },
              ),
            ),
    );
  }
}
