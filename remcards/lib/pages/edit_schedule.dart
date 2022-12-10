import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:remcards/const.dart';
import 'package:remcards/pages/components/request_header.dart';
import 'package:remcards/pages/components/rounded_text_field.dart';
import 'components/app_bar.dart';
import 'components/utils.dart';

class editSchedForm extends StatefulWidget {
  final String id;
  final int day;
  final String title;
  final int hourStart;
  final int minStart;
  final int hourFinish;
  final int minFinish;
  final Function refresh;

  editSchedForm(this.day, this.id, this.title, this.hourStart, this.minStart,
      this.hourFinish, this.minFinish, this.refresh);
  @override
  _editSchedForm createState() => _editSchedForm();
}

class _editSchedForm extends State<editSchedForm> {
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  @override
  void initState() {
    super.initState();
    _startTime = TimeOfDay(hour: widget.hourStart, minute: widget.minStart);
    _endTime = TimeOfDay(hour: widget.hourFinish, minute: widget.minFinish);
    subject = new TextEditingController(text: widget.title);
    timestart = new TextEditingController(
        text: appendZero(widget.hourStart) + ":" + appendZero(widget.minStart));
    timefinished = new TextEditingController(
        text: appendZero(widget.hourFinish) + ":" + appendZero(widget.minFinish));
  }

  Future<Null> _selectStartTime() async {
    print("sst");
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (_startTime != null) {
      setState(() {
        _startTime = newTime;
        timestart.text =
            appendZero(_startTime.hour) + ":" + appendZero(_startTime.minute);
      });
    }
    return null;
  }

  Future<Null> _selectFinishTime() async {
    print("sft");
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (_endTime != null) {
      setState(() {
        _endTime = newTime;
        timefinished.text =
            appendZero(_endTime.hour) + ":" + appendZero(_endTime.minute);
      });
    }
    return null;
  }

  bool _isLoading = false;
  var errorMsg;
  TextEditingController subject;
  TextEditingController timestart;
  TextEditingController timefinished;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(text: "Edit Schedule", context: context),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Text("   Subject Name",
                      style: TextStyle(color: Colors.brown[900], fontSize: 10)),
                  SizedBox(height: 5.0),
                  RoundedTextField("Subject Name", Colors.brown[900],
                      Colors.brown[100], subject, false, 12),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(children: [
                          Text("Start Time",
                              style: TextStyle(color: Colors.brown[900], fontSize: 10)),
                          SizedBox(height: 5.0),
                          TextFormField(
                              controller: timestart,
                              readOnly: true,
                              onTap: _selectStartTime,
                              style: TextStyle(color: Colors.brown[900], fontSize: 12),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintText: "Start Time",
                                  hintStyle: TextStyle(
                                      color: Colors.brown[900].withOpacity(0.5)),
                                  fillColor: Colors.brown[100]))],),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(children: [
                          Text("Finish Time",
                              style: TextStyle(color: Colors.brown[900], fontSize: 10)),
                          SizedBox(height: 5.0),
                          TextFormField(
                              controller: timefinished,
                              readOnly: true,
                              onTap: _selectFinishTime,
                              style: TextStyle(color: Colors.brown[900], fontSize: 12),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightBlueAccent, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  hintText: "Finish Time",
                                  hintStyle: TextStyle(
                                      color: Colors.brown[900].withOpacity(0.5)),
                                  fillColor: Colors.brown[100])),
                        ],),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await editSched(widget.day, widget.id, subject.text,
                            timestart.text, timefinished.text);
                        setState(() {
                          _isLoading = false;
                        });
                        widget.refresh();
                        Get.back();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal[100]),
                          elevation: MaterialStateProperty.all(0)),
                      child: Text("Edit Schedule",
                          style: TextStyle(color: Colors.teal[700]))),
                  SizedBox(height: 5.0),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await deleteSched(widget.id, widget.day);
                        setState(() {
                          _isLoading = false;
                        });
                        widget.refresh();
                        Get.back();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red[900]),
                          elevation: MaterialStateProperty.all(0)),
                      child: Text("Delete Schedule",
                          style: TextStyle(color: Colors.white))),
                  errorMsg == null
                      ? Container()
                      : Text(
                          "${errorMsg}",
                        ),
                ],
              ),
      ),
    );
  }
}

editSched(
    int day, String id, String title, String start, String finish) async {
  //Data Validation
  if(title==''||start==''||finish==''){
    Get.snackbar('Incomplete fields', 'Provide title, day/s, and time period.');
    return;
  }
  //Send POST request
  Map data = {"subject": title, "time": (start + "-" + finish)};
  var response = await http.post(Uri.parse('${schedURI}/${day}/${id}'),
      headers: await getRequestHeaders(), body: jsonEncode(data));
  if (response.statusCode == 204) {
    print("Successful");
  } else {
    print("Error");
  }
  Get.back();
}

deleteSched(String id, int day) async {
  var response = await http.delete(Uri.parse('${schedURI}/${day}/${id}'),
      headers: await getRequestHeaders());
  if (response.statusCode == 204) {
    print("Successful");
  } else {
    print("Error");
  }
}
