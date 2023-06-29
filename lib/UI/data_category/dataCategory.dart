// ignore_for_file: file_names

import 'package:app_wisata/UI/data_category/inputCategory.dart';
import 'package:app_wisata/models/category.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import, implementation_imports
import 'package:flutter/src/widgets/framework.dart';

class DataCategory extends StatefulWidget {
  const DataCategory({super.key});

  @override
  State<DataCategory> createState() => _DataPostsState();
}

class _DataPostsState extends State<DataCategory> {
  late ErrorMSG response;
  List<Category> _category = [];
  bool _isLoading = false;
  void deleteCategory(id) async {
    response = await ApiStatic.deleteCategory(id);
    final snackBar = SnackBar(
      content: Text(response.message),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => const DataCategory()),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Category> category = await ApiStatic.getCategory();
      setState(() {
        _category = category;
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
    await fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data category'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InputCategory(
                        category: Category(id: 0, categoryName: ''))));
          }),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                itemCount: _category.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _category.length) {
                    if (_isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                  Category category = _category[index];
                  return ListTile(
                    title: Text(category.categoryName),
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
                                        InputCategory(category: category)));
                          },
                        ),
                        // IconButton(
                        //   icon: const Icon(Icons.delete),
                        //   onPressed: () {
                        //     deleteCategory(category.id);
                        //   },
                        // ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Konfirmasi Hapus"),
                                  content: const Text(
                                      "Apakah Anda yakin ingin menghapus category ini?"),
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
                                        deleteCategory(category
                                            .id); // Jalankan fungsi hapus
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
                  );
                },
              ),
            ),
    );
  }
}
