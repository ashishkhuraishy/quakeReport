import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map data;

  DateTime endDate;
  DateTime startDate;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  //String startDate, endDate;
  double mag;
  bool set = false;

  Future<Null> _selectDate(BuildContext context, DateTime date) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2014),
        lastDate: DateTime.now());

    if (picked != null && picked != date) {
      if (date == endDate) {
        setState(() {
          endDate = picked;
          //endDate = formatter.format(_endDate);
        });
      } else {
        setState(() {
          startDate = picked;
          //startDate = formatter.format(_startDate);
        });
      }
    }
  }

  setValues() {
    endDate = data["endDate"];
    startDate = data["startDate"];
    mag = data["mag"];
    set = !set;
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    print(data);
    //_endDate = DateTime.parse(data["endDate"]);
    //_startDate = DateTime.parse(data["starDate"])
    if (!set) {
      setValues();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Start Date",
                      style: Theme.of(context).textTheme.title,
                    ),
                    RaisedButton.icon(
                      color: Colors.blue[900],
                      label: Text(
                        '${formatter.format(startDate)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _selectDate(context, startDate);
                      },
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'End Date',
                      style: Theme.of(context).textTheme.title,
                    ),
                    RaisedButton.icon(
                      color: Colors.blue[900],
                      label: Text(
                        '${formatter.format(endDate)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _selectDate(context, endDate);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "Magnitude",
              style: Theme.of(context).textTheme.title,
            ),
            Slider(
              value: mag,
              activeColor: Colors.blue[900],
              onChanged: (double value) {
                setState(() {
                  mag = value;
                });
              },
              divisions: 20,
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
        ),
        backgroundColor: Colors.blue[900],
        onPressed: () {
          Navigator.pop(context, {
            "startDate": startDate,
            "endDate": endDate,
            "mag": mag,
            "newInst": true,
          });
        },
      ),
    );
  }
}
