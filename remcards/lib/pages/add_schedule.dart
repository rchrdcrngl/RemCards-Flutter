import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:remcards/const.dart';
import 'package:remcards/pages/components/day_picker.dart';
import 'components/app_bar.dart';
import 'components/request_header.dart';
import 'components/rounded_text_field.dart';
import 'components/utils.dart';

class addSchedForm extends StatefulWidget {
  final Function refresh;

  const addSchedForm({Key key, this.refresh}) : super(key: key);
  @override
  _addSchedForm createState() => _addSchedForm();
}

class _addSchedForm extends State<addSchedForm> {
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  List<int> daySelected;
  @override
  void initState() {
    super.initState();
    _startTime =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    _endTime =
        TimeOfDay(hour: (DateTime.now().hour + 1), minute: DateTime.now().hour);
    subjectController = new TextEditingController();
    timestartController = new TextEditingController();
    timefinishedController = new TextEditingController();
    daySelected = [];
    print(daySelected);
  }

  Future<Null> _selectStartTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (_startTime != null) {
      setState(() {
        _startTime = newTime;
        timestartController.text =
            timeToString(_startTime.hour, _startTime.minute);
      });
    }
    return null;
  }

  Future<Null> _selectFinishTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (_endTime != null) {
      setState(() {
        _endTime = newTime;
        timefinishedController.text =
            timeToString(_endTime.hour, _endTime.minute);
      });
    }
    return null;
  }

  bool _isLoading = false;
  var errorMsg;
  TextEditingController subjectController;
  TextEditingController timestartController;
  TextEditingController timefinishedController;
  TextEditingController dayfrmController = new TextEditingController();
  List<bool> _isSelected = [false, false, false, false, false, false, false];

  selectDay(int index) {
    var dayVal = index == 7? 0 : index;
    _isSelected[index] ? daySelected.add(dayVal) : daySelected.remove(dayVal);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(text:"Add Schedule", context: context),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: dayPicker(
                          isSelected: _isSelected,
                          setState: setState,
                          selectDay: selectDay
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Text("   Subject Name",
                        style: TextStyle(color: Colors.brown[900], fontSize: 10)),
                    SizedBox(height: 5.0),
                    RoundedOutlineTextField("Subject Name", Colors.brown[900],
                        Colors.brown[300], subjectController, false, 12),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(children: [
                            Text("Start Time",
                                style: TextStyle(color: Colors.brown[900], fontSize: 10)),
                            SizedBox(height: 5.0),
                            TextFormField(
                                readOnly: true,
                                controller: timestartController,
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
                                    fillColor: Colors.brown[50]))],),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(children: [
                            Text("Finish Time",
                                style: TextStyle(color: Colors.brown[900], fontSize: 10)),
                            SizedBox(height: 5.0),
                            TextFormField(
                                controller: timefinishedController,
                                onTap: _selectFinishTime,
                                readOnly: true,
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
                                    fillColor:  Colors.brown[50])),
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
                          await addSched(daySelected, subjectController.text, _startTime,
                              _endTime);
                          widget.refresh();
                          Get.back();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.amberAccent[100]),
                            elevation: MaterialStateProperty.all(0)),
                        child: Text("Add Schedule",
                            style: TextStyle(color: Colors.brown[600]))),
                    errorMsg == null
                        ? Container()
                        : Text(
                            "${errorMsg}",
                          ),
                  ],
                ),
            ),
      ),
    );
  }

  addSched(List<int> day, String subject, TimeOfDay start, TimeOfDay finish) async {
    //Data Validation
    if(subject==''||start==null||finish==null||day.isEmpty){
      setState(() {
        _isLoading = false;
      });
      showToast(message: 'Provide title, day/s, and time period.');
      throw Exception('Validation error');
    }
    if(!(start<finish)){
      setState(() {
        _isLoading = false;
      });
      showToast(message: 'Start time should be earlier than finish time');
      throw Exception('Validation error');
    }
    if(start.hour<6||finish.hour>22){
      setState(() {
        _isLoading = false;
      });
      showToast(message: 'Please select time from 6 AM to 10 PM');
      throw Exception('Validation error');
    }
    //Send POST request
    Map<String, String> headers = await getRequestHeaders();
    day.forEach((element) async {
      Map data = {"subject": subject, "startTime": get24HourFromTimeOfDay(start), "endTime": get24HourFromTimeOfDay(finish)};
      var response = await http.post(Uri.parse('${schedURI}/${element}'),
          headers: headers, body: jsonEncode(data));
      if (response.statusCode == 201) {
        print("Successful");
      } else {
        print("Error");
      }
    });
  }
}

extension TimeOfDayExtension on TimeOfDay {
  operator < (TimeOfDay other){
    if(hour>other.hour) return false;
    if(hour==other.hour && minute>=other.minute) return false;
    return true;
  }
}