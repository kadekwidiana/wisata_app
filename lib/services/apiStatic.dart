// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'dart:convert';
import 'package:app_wisata/models/category.dart';
import 'package:app_wisata/models/post.dart';
import 'package:app_wisata/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: unused_import
import '../models/errMsg.dart';

class ApiStatic {
  static const host = 'http://192.168.43.59';
  // static const host = 'http://10.10.24.228';
  static var _token = "1|VQ08R4o2yLhpnyFUqRpHcb5iQ0JwzxOUd7XgHc2X";
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  static Future<void> getPref() async {
    Future<SharedPreferences> preferences = SharedPreferences.getInstance();
    final SharedPreferences prefs = await preferences;
    _token = prefs.getString('token') ?? "";
  }

  static getHost() {
    return host;
  }

  static Future<List<Post>> getPost() async {
    try {
      // final response = await http.get(Uri.parse("$host/api/posts"), headers: {
      //   'Authorization': 'Bearer ' + _token,
      // });
      getPref();
      final response = await http.get(Uri.parse("$host/api/posts"), headers: {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final parsed = json['data'].cast<Map<String, dynamic>>();
        return parsed.map<Post>((json) => Post.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // list user
  static Future<List<User>> getUser() async {
    try {
      getPref();
      final response = await http.get(Uri.parse("$host/api/user"), headers: {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final parsed = json.cast<Map<String, dynamic>>();
        return parsed.map<User>((json) => User.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // create & update
  static Future<ErrorMSG> savePost(id, post, filepath) async {
    try {
      var url = Uri.parse('$host/api/posts');
      if (id != 0) {
        // ignore: prefer_interpolation_to_compose_strings
        url = Uri.parse('$host/api/posts/' + id.toString());
      }
      var request = http.MultipartRequest('POST', url);
      request.fields['id_user'] = post['id_user'].toString();
      request.fields['id_category'] = post['id_category'].toString();
      request.fields['title'] = post['title'];
      request.fields['name_location'] = post['name_location'];
      request.fields['latitude'] = post['latitude'];
      request.fields['longitude'] = post['longitude'];
      request.fields['description'] = post['description'];
      if (filepath != '') {
        request.files.add(await http.MultipartFile.fromPath('image', filepath));
      }

      getPref();
      request.headers.addAll({
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      var response = await request.send();
      //final response = await http.post(Uri.parse('$_host/panen'), body:_panen);
      if (response.statusCode == 200) {
        //return ErrorMSG.fromJson(jsonDecode(response.body));
        final respStr = await response.stream.bytesToString();
        //print(jsonDecode(respStr));
        return ErrorMSG.fromJson(jsonDecode(respStr));
      } else {
        //return ErrorMSG.fromJson(jsonDecode(response.body));
        return ErrorMSG(success: false, message: 'err Request');
      }
    } catch (e) {
      ErrorMSG responseRequest =
          ErrorMSG(success: false, message: 'error caught: $e');
      return responseRequest;
    }
  }

  // delete
  static Future<ErrorMSG> deletePost(id) async {
    try {
      getPref();
      final response = await http
          // ignore: prefer_interpolation_to_compose_strings
          .delete(Uri.parse('$host/api/posts/' + id.toString()), headers: {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      if (response.statusCode == 200) {
        return ErrorMSG.fromJson(jsonDecode(response.body));
      } else {
        return ErrorMSG(
            success: false, message: 'Err, periksan kembali inputan anda');
      }
    } catch (e) {
      ErrorMSG responseRequest =
          ErrorMSG(success: false, message: 'error caught: $e');
      return responseRequest;
    }
  }

  // ignore: no_leading_underscores_for_local_identifiers
  static Future<ErrorMSG> sigIn(_post) async {
    try {
      final response =
          await http.post(Uri.parse('$host/api/login'), body: _post);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        //print(res);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // var idppl=res['data']['id_ppl']==null?'':res['data']['id_ppl'] ;
        // var idp=res['data']['id_penjual']==null?'':res['data']['id_penjual'];
        prefs.setString('token', res['token']);
        prefs.setString('name', res['user']['name']);
        prefs.setString('email', res['user']['email']);
        prefs.setInt('is_admin', 0);
        return ErrorMSG.fromJson(res);
      } else {
        return ErrorMSG.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      ErrorMSG responseRequest =
          ErrorMSG(success: false, message: 'error caught: $e');
      return responseRequest;
    }
  }

  // CATEGORY
  // list category
  static Future<List<Category>> getCategory() async {
    try {
      getPref();
      final response =
          await http.get(Uri.parse("$host/api/category"), headers: {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        final parsed = json.cast<Map<String, dynamic>>();
        return parsed.map<Category>((json) => Category.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // create & update
  static Future<ErrorMSG> saveCategory(id, category) async {
    try {
      var url = Uri.parse('$host/api/category');
      if (id != 0) {
        // ignore: prefer_interpolation_to_compose_strings
        url = Uri.parse('$host/api/category/' + id.toString());
      }
      var request = http.MultipartRequest('POST', url);
      request.fields['category_name'] = category['category_name'];

      getPref();
      request.headers.addAll({
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      var response = await request.send();
      //final response = await http.post(Uri.parse('$_host/panen'), body:_panen);
      if (response.statusCode == 200) {
        //return ErrorMSG.fromJson(jsonDecode(response.body));
        final respStr = await response.stream.bytesToString();
        //print(jsonDecode(respStr));
        return ErrorMSG.fromJson(jsonDecode(respStr));
      } else {
        //return ErrorMSG.fromJson(jsonDecode(response.body));
        return ErrorMSG(success: false, message: 'err Request');
      }
    } catch (e) {
      ErrorMSG responseRequest =
          ErrorMSG(success: false, message: 'error caught: $e');
      return responseRequest;
    }
  }

  // delete
  static Future<ErrorMSG> deleteCategory(id) async {
    try {
      getPref();
      final response = await http
          // ignore: prefer_interpolation_to_compose_strings
          .delete(Uri.parse('$host/api/category/' + id.toString()), headers: {
        // ignore: prefer_interpolation_to_compose_strings
        'Authorization': 'Bearer ' + _token,
      });
      if (response.statusCode == 200) {
        return ErrorMSG.fromJson(jsonDecode(response.body));
      } else {
        return ErrorMSG(
            success: false, message: 'Err, periksan kembali inputan anda');
      }
    } catch (e) {
      ErrorMSG responseRequest = ErrorMSG(
          success: false,
          message: '"Category ini memiliki beberapa" post error caught: $e');
      return responseRequest;
    }
  }
}
