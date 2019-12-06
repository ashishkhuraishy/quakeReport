import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class Report {
  String place;
  String near;
  String url;
  String time;
  String mag;
  Color bgColor;

  Report({this.place, this.bgColor, this.near, this.mag, this.time, this.url});
}

Future<List<Report>> getReport(
    DateTime startDate, DateTime endDate, double mag) async {
  List<Report> _quakeReport = [];
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String _startDate = formatter.format(startDate);
  String _endDate = formatter.format(endDate);
  String _mag = mag.toString();
  //print('https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startDate&endtime=$endDate&minMagnitude=4.0');

  try {
    Response response = await get(
        'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$_startDate&endtime=$_endDate&minmagnitude=$_mag&limit=1000');
    Map data = jsonDecode(response.body);
    //prefix0.print("Map $data");

    String near, place;
    Color _bgColor;
    //print(data["features"].length);

    for (int i = 0; i < data["features"].length; i++) {
      String location = data["features"][i]["properties"]["place"];
      String mag = data["features"][i]["properties"]["mag"].toString();
      String time = data["features"][i]["properties"]["time"].toString();
      String url = data["features"][i]["properties"]["url"];

      //var places = place.split("of ");

      if (location.contains("of")) {
        List<String> places = location.split("of ");
        near = places[0];
        place = places[places.length - 1];
      } else {
        near = "Near";
        place = location;
      }

      double _mag = double.parse(mag);

      if (_mag < 2.0) {
        _bgColor = Colors.orange[100];
      } else if (_mag >= 2.0 && _mag < 3.0) {
        _bgColor = Colors.orange[200];
      } else if (_mag >= 3.0 && _mag < 4.0) {
        _bgColor = Colors.orange[400];
      } else if (_mag >= 4.0 && _mag < 5.0) {
        _bgColor = Colors.orange[500];
      } else if (_mag >= 5.0 && _mag < 6.0) {
        _bgColor = Colors.orange[600];
      } else if (_mag >= 6.0 && _mag < 7.0) {
        _bgColor = Colors.orange[700];
      } else if (_mag >= 7.0 && _mag < 8.0) {
        _bgColor = Colors.orange[800];
      } else if (_mag >= 8.0 && _mag < 9.0) {
        _bgColor = Colors.orange[900];
      } else {
        _bgColor = Colors.orange[1000];
      }

      String formattedTime = formatTime(int.parse(time));

      _quakeReport.add(new Report(
          place: place,
          bgColor: _bgColor,
          near: near,
          mag: mag,
          time: formattedTime,
          url: url));
    }
  } catch (e) {
    print("Caught error $e");
  }

  return _quakeReport;
}

launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
