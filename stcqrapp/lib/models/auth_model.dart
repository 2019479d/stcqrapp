import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:stcqrapp/configs/url_location.dart';
import 'package:stcqrapp/entities/user.dart';

class AuthModel extends ChangeNotifier {
  String? _token;
  late User _user;

  String? get token => _token;
  User? get user => _user;

  Future<String> loginUser(String username, String password) async {
    final url = Uri.parse('${UrlLocation.authUrl}/login/');

    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
        },
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        _token = responseBody['access'] ?? '';

        // Decode access token to get user details
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);

        // Extract user details from decoded token
        final String username = decodedToken['username'];
        final int regionId = decodedToken['region_id'];
        final String depotId = decodedToken['depot_id'];
        final int userLevelId = decodedToken['user_level'];

        // Create a user with decoded user details
        _user = User(
          username: username,
          regionId: regionId,
          depotId: depotId,
          userLevel: userLevelId,
        );
        notifyListeners();
        return 'Login successful';
      } else if (response.statusCode == 401) {
        return responseBody['detail'];
      } else {
        return 'Login failed';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }
}
