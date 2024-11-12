import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_task1/model/Profile_model.dart';
import 'package:flutter_application_task1/pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import '../model/login_model.dart';
import 'package:image_picker/image_picker.dart';

class Circle {
  final String id;
  final String circleName;
  final String circleImage;
  final String description;

  Circle({
    required this.id,
    required this.circleName,
    required this.circleImage,
    required this.description,
  });

  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      id: json['_id'],
      circleName: json['circleName'],
      circleImage: json['circleImage'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'circleName': circleName,
      'circleImage': circleImage,
      'description': description,
    };
  }
}

class APIService {
  String baseUrl = "https://cricle-app.azurewebsites.net";
  List<Circle> circles = List.empty();
  Profile? profile = null;
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        String jwtToken = responseBody['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', jwtToken);

        await fetchCircles(jwtToken);
        await fetchProfile(jwtToken);
        print('Token: $jwtToken');

        int length = circles.length;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );

        print('Dashboard Data: $length');
      } else {
        print('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchCircles(String token) async {
    final url =
        Uri.parse('https://cricle-app.azurewebsites.net/api/circle/all');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['circles'];

        circles = data.map((item) => Circle.fromJson(item)).toList();
      } else {
        print('Failed to load circles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Profile?> fetchProfile(String token) async {
    final url =
        Uri.parse('https://cricle-app.azurewebsites.net/api/auth/profile');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final resp = jsonDecode(response.body);
        final data = resp["data"];

        profile = Profile.fromJson(data);

        print('PData $profile');
      } else {
        print('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

Future<void> updateProfilePicture(BuildContext context, File imageFile) async {
  String baseUrl = "https://cricle-app.azurewebsites.net";
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken == null) {
      print("User is not authenticated.");
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/api/auth/update-profile-picture"),
    );
    request.headers['Authorization'] = 'Bearer $jwtToken';
    request.files.add(await http.MultipartFile.fromPath(
      'profile_picture',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      print("Profile picture updated successfully.");
    } else {
      print("Failed to update profile picture: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
  }
}

Future<void> pickImageAndUpload(BuildContext context) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && image.path.isNotEmpty) {
      await updateProfilePicture(context, File(image.path));
    } else {
      print("No image selected or invalid path.");
    }
  } catch (e) {
    print("Error picking or uploading image: $e");
  }
}
