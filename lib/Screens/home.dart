import 'package:flutter/material.dart';
import 'package:quake_report/Services/Report.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};
  List<Report> reports = [];

  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? ModalRoute.of(context).settings.arguments : data;
    reports = data["reports"];
    //print(data);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Quake Report"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index){
          return ListTile( 
            title: Text(reports[index].place),
            subtitle: Text(reports[index].near),
            leading: CircleAvatar(
              backgroundColor: reports[index].bgColor,
              child: Text(reports[index].mag),
            ),
            trailing: Text(reports[index].time),
            onTap: (){
              launchUrl(reports[index].url);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          dynamic response = await Navigator.pushNamed(context, "/settings");            
          setState(() {
            data = response;
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
