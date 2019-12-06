import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quake_report/Services/Report.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  List<Report> reports = [];
  DateTime startDate, endDate;
  double mag;
  bool isRunning = false;
  bool newInst;

  void getData() async {
    isRunning = true;
    print("Is running $isRunning");
    dynamic result = await getReport(startDate, endDate, mag);
    print("result $result Isrng$isRunning");

    reports = result;

    isRunning = false;
    setState(() {
      //isRunning = false;
      newInst = false;
      homeBody();
    });
    print("isrng $isRunning");
  }

  savData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("start", startDate.millisecondsSinceEpoch);
    pref.setInt("end", endDate.millisecondsSinceEpoch);
    pref.setDouble("mag", mag);
  }

  homeBody() {
    if (isRunning) {
      return LoadingHome();
    } else {
      if (reports.isNotEmpty) {
        return ReportList(reports: reports);
      } else {
        return Oops();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("Init State");
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      data = data.isEmpty ? ModalRoute.of(context).settings.arguments : data;
      //reports = data["reports"];
      startDate = data["startDate"];
      endDate = data["endDate"];
      mag = data["mag"];
      newInst = newInst == null ? data["newInst"] : newInst;
      print("isrng $isRunning len ${reports.length}");
      print("Startd $startDate endD $endDate Mag $mag newInst $newInst");
      if (newInst) {
        getData();
        savData();
      }
    }

    //print(data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Quake Report"),
        centerTitle: true,
      ),
      body: homeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic response =
              await Navigator.pushNamed(context, "/settings", arguments: {
            "startDate": startDate,
            "endDate": endDate,
            "mag": mag,
            "newInst": true,
          });
          setState(() {
            data = response;
            newInst = null;
          });
        },
        child: Icon(
          Icons.settings,
        ),
        backgroundColor: Colors.blue[900],
        focusColor: Colors.blue[600],
        focusElevation: 16.0,
        tooltip: "Settings",
      ),
    );
  }
}

class LoadingHome extends StatefulWidget {
  @override
  _LoadingHomeState createState() => _LoadingHomeState();
}

class _LoadingHomeState extends State<LoadingHome> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Colors.blue[900],
      ),
    );
  }
}

class Oops extends StatefulWidget {
  @override
  _OopsState createState() => _OopsState();
}

class _OopsState extends State<Oops> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("OOps"),
      ),
    );
  }
}

class ReportList extends StatefulWidget {
  final List<Report> reports;
  ReportList({@required this.reports});

  @override
  _ReportListState createState() => _ReportListState(reports: reports);
}

class _ReportListState extends State<ReportList> {
  List<Report> reports;
  _ReportListState({@required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(reports[index].place),
          subtitle: Text(reports[index].near),
          leading: CircleAvatar(
            backgroundColor: reports[index].bgColor,
            child: Text(
              reports[index].mag,
              style: TextStyle(color: Colors.black),
            ),
          ),
          trailing: Text(reports[index].time),
          onTap: () {
            launchUrl(reports[index].url);
          },
        );
      },
    );
  }
}
