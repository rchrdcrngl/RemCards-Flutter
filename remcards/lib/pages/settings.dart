import 'dart:convert';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:remcards/components/notifications.dart';
import 'package:remcards/pages/components/request_header.dart';
import 'package:remcards/pages/components/user_functions.dart';
import 'package:remcards/pages/components/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:remcards/pages/components/app_bar.dart';
import '../const.dart';
import 'components/modals.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  @override
  _Settings createState() => _Settings();
}

logout() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  sharedPreferences.commit();
  APICacheManager().deleteCache("API-Cards");
  APICacheManager().deleteCache("API-Schedule");
  cancelScheduledNotifications();
}

class _Settings extends State<Settings> {
  String username = "username";
  String email = "user@remcards.com";
  Future<List<String>> data;

  Future<List<String>> fetchProfileData() async {
    var headers = await getRequestHeaders();
    final response = await http.get(Uri.parse(profileURI), headers: headers);
    if (response.statusCode == 200) {
      Map jsonResponse = json.decode(response.body);
      return [jsonResponse['username'],jsonResponse['email']];
    }
    return [];
  }

  void _refresh() {
    setState(() {
      data = fetchProfileData();
    });
  }

  @override
  void initState() {
    super.initState();
    data = fetchProfileData();
  }

  showSnack(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  editProfile(String uname, String e)async{
    if(uname.trim()==''||e.trim()=='') {
      showToast(message: 'Please enter valid username and email');
      throw Exception('Validation error');
    }
    if(uname==username&&e==email) return;

    var headers = await getRequestHeaders();
    Map body = {
      'username':uname,
      'email':e,
    };
    var response = await http.post(Uri.parse(profileURI),
        headers: headers, body: jsonEncode(body));
    if (response.statusCode == 201) {
      showToast(message: 'Successfully edited profile');
    } else {
      showToast(message: 'Error updating profile');
    }
    _refresh();
  }

  changePassword(String pword, String conf)async{
    //Validation
    if(pword.trim()==''||conf.trim()=='') {
      showToast(message: 'Password field is empty');
      throw Exception('Validation error');
    }
    if(pword!=conf) {
      showToast(message: 'Please make sure password and confirmed password is equal.');
      throw Exception('Validation error');
    }
    if(pword.length<8) {
      showToast(message: 'Password length should be at least 8.');
      throw Exception('Validation error');
    }
    //POST Request
    var headers = await getRequestHeaders();
    Map body = {
      'password':pword
    };
    var response = await http.post(Uri.parse('$profileURI/password'),
        headers: headers, body: jsonEncode(body));
    if (response.statusCode == 201) {
      showToast(message: 'Successfully changed password');
    } else {
      showToast(message: 'Error changing password');
    }
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: rcAppBar(text:"Settings",context: context),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: [
                FutureBuilder<List<String>>(
                  future: data,
                  builder: (context, snapshot) {
                      if ((snapshot.hasData) && !((snapshot.data).isEmpty)) {
                        username = snapshot.data[0];
                        email = snapshot.data[1];
                        return Card(child: ListTile(leading: Icon(Icons.person), title: Text(snapshot.data[0]), subtitle: Text(snapshot.data[1]),),);
                      }
                      return Card(child: ListTile(leading: Icon(Icons.person), title: Text(username), subtitle: Text(email),),);
                      },
                ),
                SizedBox(height: 50,),
                ElevatedButton(onPressed: ()=>showEditProfileModal(context: context, username: username, email: email, edit: editProfile), child: Text('Edit Profile')),
                ElevatedButton(onPressed: ()=>showChangePasswordModal(context: context, edit: changePassword), child: Text('Change Password')),
                ElevatedButton(
                    onPressed: () {
                      logout();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text("Logout")),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      clearRemCards();
                      showSnack('RemCards data has been cleared.');
                    },
                    child: Text("Clear All RemCards")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      clearSchedule();
                      showSnack('Schedule data has been cleared.');
                    },
                    child: Text("Clear Schedule"))
              ],
            )));
  }
}
