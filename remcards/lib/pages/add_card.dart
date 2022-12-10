
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remcards/components/notifications.dart';
import 'package:remcards/const.dart';
import 'package:remcards/pages/components/request_header.dart';
import 'package:remcards/pages/components/rounded_text_field.dart';
import 'components/app_bar.dart';
import 'package:get/get.dart';

import 'components/utils.dart';

const Map<String,int> levelStringToInt = {
  'Normal':0, 'Needs Action':1, 'Urgent':2
};

class AddCardForm extends StatefulWidget {
  final Function refresh;

  const AddCardForm({Key key, this.refresh}) : super(key: key);
  @override
  _AddCardForm createState() => _AddCardForm();
}

class _AddCardForm extends State<AddCardForm> {
  bool _isLoading = false;
  var errorMsg;
  DateTime date;

  @override
  void initState() {
    date = new DateTime.now();
  }

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if (picked != null && picked != date) {
      setState(() {
        taskDate.text = picked.month.toString() +
            "/" +
            picked.day.toString() +
            "/" +
            picked.year.toString();
        date = picked;
      });
    }
    return null;
  }

  final TextEditingController subjectCode = new TextEditingController();
  final TextEditingController taskDesc = new TextEditingController();
  final TextEditingController taskDate = new TextEditingController();
  final TextEditingController taskLevel = new TextEditingController();
  final TextEditingController taskStat = new TextEditingController();
  String dropdownvalue = "Normal";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(text:"Add Card", context: context),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Text("   Task Description",
                      style: TextStyle(
                          color: Colors.deepPurple[900], fontSize: 10)),
                  SizedBox(height: 5.0),
                  RoundedOutlineTextField("Task Description", Colors.deepPurple[900],
                      Colors.deepPurple[500], taskDesc, false, 24),
                  SizedBox(height: 15.0),
                  Text("   Subject Code",
                      style: TextStyle(
                          color: Colors.deepPurple[900], fontSize: 10)),
                  SizedBox(height: 5.0),
                  RoundedTextField("Subject Code", Colors.deepPurple[900],
                      Colors.deepPurple[100], subjectCode, false, 12),
                  SizedBox(height: 15.0),
                  Text("   Task Date",
                      style: TextStyle(
                          color: Colors.deepPurple[900], fontSize: 10)),
                  SizedBox(height: 5.0),
                  RoundedTextFieldTap("Task Date", Colors.deepPurple[900],
                      Colors.deepPurple[100], taskDate, false, 12, _selectDate),
                  SizedBox(height: 20.0),
                  DropdownButton<String>(
                    value: dropdownvalue,
                    isExpanded: true,
                    iconSize: 12,
                    elevation: 16,
                    style:
                        const TextStyle(color: Colors.deepPurple, fontSize: 10),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurple,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownvalue = newValue;
                      });
                    },
                    items: <String>['Normal', 'Needs Action', 'Urgent']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await addCard(subjectCode.text, taskDesc.text, taskDate.text,
                            dropdownvalue);
                        await widget.refresh();
                        Get.back();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightGreen[200]),
                          elevation: MaterialStateProperty.all(0)),
                      child: Text("Add Card",
                          style: TextStyle(color: Colors.lightGreen[900]))),
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

  addCard(String subjcode, String tskdesc, String tskdate, String tsklvl) async {
    //Data Validation
    if(subjcode==''||tskdesc==''||tskdate==''||tsklvl==''){
      showToast(message: 'Provide subject code, task description, task date, task level.');
      setState(() {
        _isLoading = false;
      });
      throw Exception('Validation error');
    }
    //Send POST request
    Map data = {
      'subjcode': subjcode,
      'tskdesc': tskdesc,
      'tskdate': tskdate,
      'tsklvl': levelStringToInt[tsklvl]??0,
      'tskstat': 0
    };
    var response = await http.post(Uri.parse(cardsURI),
        headers: await getRequestHeaders(), body: jsonEncode(data));
    if (response.statusCode == 201) {
      print("Successful");
      var date = tskdate.split("/");
      print(date);
      createReminderNotification(subjcode, tskdesc, int.parse(date[0]),
          int.parse(date[1]), int.parse(date[2]));
    } else {
      print("Error");
    }
    setState(() {
      _isLoading = false;
    });
  }
}
