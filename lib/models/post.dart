// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  int id;
  int idUser;
  int idCategory;
  String title;
  String image;
  String latitude;
  String longitude;
  String name_location;
  String description;
  // DateTime createdAt;
  // DateTime updatedAt;

  Post({
    required this.id,
    required this.idUser,
    required this.idCategory,
    required this.title,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.name_location,
    required this.description,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        idUser: json["id_user"],
        idCategory: json["id_category"],
        title: json["title"],
        image: json["image"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        name_location: json["name_location"],
        description: json["description"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "id_category": idCategory,
        "title": title,
        "image": image,
        "latitude": latitude,
        "longitude": longitude,
        "name_location": name_location,
        "description": description,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
      };
}
