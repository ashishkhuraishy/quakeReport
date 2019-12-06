import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  DateTime startDate, endDate;
  double mag;

  void loadData() async {
    //DateFormat formatter = DateFormat("yyyy-MM-dd");
    //DateTime endDate = DateTime.now();
    //DateTime startDate = DateTime.now().subtract(Duration(days: 30));
    //double mag = 4.0;
    //List<Report> _reports =  await getReport(startDate, endDate, '8.0');
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "startDate": startDate,
        "endDate": endDate,
        "mag": mag,
        "newInst": true,
        //"reports" : _reports,
      });
    });
  }

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("start")) {
      startDate = DateTime.fromMillisecondsSinceEpoch(pref.getInt("start"));
      endDate = DateTime.fromMillisecondsSinceEpoch(pref.getInt("end"));
      mag = pref.getDouble("mag");
    } else {
      startDate = DateTime.now().subtract(Duration(days: 30));
      endDate = DateTime.now();
      mag = 4.0;
    }
  }

  initialise() async {
    await getData();
    loadData();
  }

  @override
  void initState() {
    super.initState();
    initialise();
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
