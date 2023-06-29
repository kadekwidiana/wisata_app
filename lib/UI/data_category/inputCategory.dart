// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:app_wisata/UI/data_category/dataCategory.dart';
import 'package:app_wisata/models/category.dart';
import 'package:app_wisata/models/errMsg.dart';
import 'package:app_wisata/services/apiStatic.dart';
import 'package:flutter/material.dart';

class InputCategory extends StatefulWidget {
  final Category category;
  InputCategory({required this.category});

  // const InputCategory({super.key, required Post post});

  @override
  State<InputCategory> createState() => _InputPostState();
}

class _InputPostState extends State<InputCategory> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController categoryName;
  late int id = 0;
  // ignore: prefer_final_fields
  bool _isupdate = false;
  // ignore: unused_field
  bool _validate = false;
  bool _success = false;
  late ErrorMSG response;

  @override
  void initState() {
    categoryName = TextEditingController();
    // selectedCategory = widget.post.category;
    if (widget.category.id != 0) {
      categoryName = TextEditingController(text: widget.category.categoryName);
    }

    super.initState();
  }

  // func submit
  void submit() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      // ignore: unused_local_variable
      var params = {
        'category_name': categoryName.text.toString(),
      };
      response = await ApiStatic.saveCategory(id, params);
      _success = response.success;
      final snackBar = SnackBar(
        content: Text(response.message),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (_success) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const DataCategory()));
      } else {}
    } else {
      _validate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isupdate
            // ignore: prefer_interpolation_to_compose_strings
            ? Text('Update ' + widget.category.categoryName)
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
                  child: TextFormField(
                    controller: categoryName,
                    validator: (u) => u == "" ? "Wajib isi" : null,
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.title),
                        hintText: "Category",
                        labelText: "Category"),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        child: const Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
