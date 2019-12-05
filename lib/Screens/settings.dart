import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quake_report/Services/Report.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DateTime selectedDate;
  DateTime monthBefore;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String startDate, endDate;
  double mag;

  Future<Null> _selectDate(BuildContext context, DateTime date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2014),
        lastDate: selectedDate.add(Duration(days: 1)));
    if (picked != null && picked != date) {
      if (date == selectedDate) {
        setState(() {
          selectedDate = picked;
          endDate = formatter.format(selectedDate);
        });
      } else {
        setState(() {
          monthBefore = picked;
          startDate = formatter.format(monthBefore);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now().subtract(Duration(days: 1));
    monthBefore = selectedDate.subtract(Duration(days: 30));
    startDate = formatter.format(monthBefore);
    endDate = formatter.format(selectedDate);
    mag = 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Start Date"),
                    RaisedButton.icon(
                      label: Text('$startDate'),
                      icon: Icon(
                        Icons.calendar_today,
                      ),
                      onPressed: () {
                        _selectDate(context, monthBefore);
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('End Date'),
                    RaisedButton(
                      child: Text('$endDate'),
                      onPressed: () {
                        _selectDate(context, selectedDate);
                      },
                    ),
                  ],
                ),
              ],
            ),
            Text("Magnitude $mag"),
            Slider(
              value: mag, 
              onChanged: (double value) {
                setState(() {
                  mag = value;
                });
              },
              min: 0.0,
              max: 10.0,
              label: '$mag',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save,
        ),backgroundColor: Colors.blue[900],
        onPressed: () async {
          Navigator.pop(context, {
            "startDate": formatter.format(monthBefore),
            "endDate": formatter.format(selectedDate),
            "reports": await getReport(
                startDate, endDate, mag.toString())
          });
        },
      ),
    );
  }
}
