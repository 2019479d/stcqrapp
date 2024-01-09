import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stcqrapp/configs/url_location.dart';
import 'package:stcqrapp/entities/log.dart';

class LogsModel extends ChangeNotifier {
  List<Log> logs = [];
  String qrCode = '';
  List<String> qrCodes = [];
  String qrIdListString = '';
  int currentLotNumber = 0;

  // --- list getters ---
  List<Log> get logsList {
    return logs;
  }

  String generateRandomString() {
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(10, (index) => charset[random.nextInt(charset.length)])
        .join();
  }

  // --- Core functions ---

  Future<String> addQr(
    String visibleMaterialNo,
    String username,
    String depotId,
    int regionId,
    String token,
  ) async {
    final url = Uri.parse(
        '${UrlLocation.baseUrl}/$username/addQR/$visibleMaterialNo/$regionId/$depotId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include your JWT token
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "qr_id": qrCode,
        }),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      notifyListeners();
      if (response.statusCode == 200) {
        return 'QR added successfully';
      } else if (response.statusCode == 401) {
        return responseBody['error'];
      } else if (response.statusCode == 404) {
        return responseBody['error'];
      } else if (response.statusCode == 409) {
        return responseBody['error'];
      } else if (response.statusCode == 500) {
        return responseBody['error'];
      } else {
        return 'Unknown error occurred!';
      }
    } catch (error) {
      return 'Network error: $error';
    }
  }

  Future<String> modifyQr(
    String visibleMaterialNo,
    String username,
    String depotId,
    int regionId,
    String token,
    String reason,
  ) async {
    final url = Uri.parse(
        '${UrlLocation.baseUrl}/$username/modifyQR/$visibleMaterialNo/$regionId/$depotId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include your JWT token
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "qr_id": qrCode,
          "reason": reason,
        }),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      notifyListeners();
      if (response.statusCode == 200) {
        return 'QR updated successfully';
      } else if (response.statusCode == 401) {
        return responseBody['error'];
      } else if (response.statusCode == 404) {
        return responseBody['error'];
      } else if (response.statusCode == 409) {
        return responseBody['error'];
      } else if (response.statusCode == 500) {
        return responseBody['error'];
      } else {
        return 'Unknown error occurred!';
      }
    } catch (error) {
      return 'Network error: $error';
    }
  }

  Future<String> getLogsFromVisibleMaterialNo(
    String visibleMaterialNos,
    String username,
    String depotId,
    int regionId,
    String token,
  ) async {
    // removing the last comma
    String cleanedVisMatNoListString =
        visibleMaterialNos.replaceAll(RegExp(r',$'), '');

    final url = Uri.parse(
        '${UrlLocation.baseUrl}/$username/workingSheet/$cleanedVisMatNoListString/$regionId/$depotId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include your JWT token
          'Content-Type': 'application/json',
        },
      );
      // Parse the response body and return a list of Log objects
      final List<dynamic> data = json.decode(response.body);

      notifyListeners();
      if (response.statusCode == 200) {
        // Clear existing logs and add new logs in one operation
        logs
          ..clear()
          ..addAll(data
              .map((item) => Log(
                    materialNo: item['material_no'],
                    qrId: item['qr_id'],
                    visibleMaterialNo: item['visible_material_no'],
                    timberClass: item['timber_class'],
                    species: item['specis'],
                    length: item['length'],
                    girth: item['girth'],
                    volume: item['volume'],
                    category: item['category'],
                    salePrice: item['sale_price'],
                    valueGrade: item['value_grade'],
                    reducedVolume: item['reduced_volume'],
                    valuePrice: item['value_price'],
                    transCost: item['transCost'],
                    userId: item['user']['id'],
                    username: item['user']['username'],
                    regionId: item['region']['region_id'],
                    regionText: item['region']['region_txt'],
                    depotId: item['depot']['depot_id'],
                    depotText: item['depot']['depot_txt'],
                    time: item['time'],
                    active: item['active'],
                    lotNo: item['lot_no'],
                  ))
              .toList());
        return 'New lot added';
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        return 'One of entered Visible Material Numbers are incorrect';
      } else {
        return 'Unknown error occurred!';
      }
    } catch (error) {
      return 'Error: Check entered Visible Material Numbers again!';
    }
  }

  Future<String> getLogsFromQrId(
    String username,
    String depotId,
    int regionId,
    String token,
  ) async {
    // removing the last comma
    String cleanedQrIdListString = qrIdListString.replaceAll(RegExp(r',$'), '');

    final url = Uri.parse(
        '${UrlLocation.baseUrl}/$username/workingSheet/$cleanedQrIdListString');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include your JWT token
          'Content-Type': 'application/json',
        },
      );

      // Parse the response body and return a list of Log objects
      final List<dynamic> data = json.decode(response.body);

      notifyListeners();
      if (response.statusCode == 200) {
        // Clear existing logs and add new logs in one operation
        logs
          ..clear()
          ..addAll(data
              .map((item) => Log(
                    materialNo: item['material_no'],
                    qrId: item['qr_id'],
                    visibleMaterialNo: item['visible_material_no'],
                    timberClass: item['timber_class'],
                    species: item['specis'],
                    length: item['length'],
                    girth: item['girth'],
                    volume: item['volume'],
                    category: item['category'],
                    salePrice: item['sale_price'],
                    valueGrade: item['value_grade'],
                    reducedVolume: item['reduced_volume'],
                    valuePrice: item['value_price'],
                    transCost: item['transCost'],
                    userId: item['user']['id'],
                    username: item['user']['username'],
                    regionId: item['region']['region_id'],
                    regionText: item['region']['region_txt'],
                    depotId: item['depot']['depot_id'],
                    depotText: item['depot']['depot_txt'],
                    time: item['time'],
                    active: item['active'],
                    lotNo: item['lot_no'],
                  ))
              .toList());
        return 'New Lot added';
      } else if (response.statusCode == 404) {
        return 'One of scanned QR IDs are incorrect';
      } else {
        return 'Unknown error occurred!';
      }
    } catch (error) {
      return 'Error: $error';
    }
  }
}
