import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:quake_report/Services/Report.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void loadData() async {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    String endDate = formatter.format(DateTime.now());
    String startDate = formatter.format(DateTime.now().subtract(Duration(days: 30)));
    List<Report> _reports =  await getReport(startDate, endDate, '4.0');
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      "startDate" : startDate,
      "endDate" : endDate,
      "reports" : _reports,
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
        body: SafeArea(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          Text(
            "Quake Report",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          SpinKitSpinningCircle(
            size: 16.0,
            color: Colors.white,
          )
      ],
    ),
        ));
  }
}
