import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remcards/pages/components/rounded_text_field.dart';
import 'package:remcards/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../const.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  var errorMsg;
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        padding: EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/icon/icon.png", height: 50, fit: BoxFit.contain,),
                        SizedBox(height: 8,),
                        Text("Welcome Back to RemCards!",
                            style: TextStyle(
                                color: Colors.teal[600],
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 24)),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  RoundedTextField("Username", Colors.blueGrey[900],
                      Colors.blueGrey[200], usernameController, false, 12),
                  SizedBox(height: 20.0),
                  RoundedTextField("Password", Colors.blueGrey[900],
                      Colors.blueGrey[200], passwordController, true, 12),
                  errorMsg == null
                      ? SizedBox(
                    height: 5,
                  )
                      : Container(
                    height: 25,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${errorMsg}",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Login pressed");
                      setState(() {
                        _isLoading = true;
                      });
                      signIn(usernameController.text, passwordController.text);
                      //test();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal[600]),
                        elevation: MaterialStateProperty.all(0)),
                    child: Text("Login",
                        style: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.white)),
                  ),
                  SizedBox(height: 5.0),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => RegisterPage());
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple),
                        elevation: MaterialStateProperty.all(0)),
                    child: Text("Don't have an account? Register",
                        style: TextStyle(
                            fontFamily: 'Montserrat', color: Colors.white)),
                  ),
                ],
              ),
      )),
    );
  }

  signIn(String username, String password) async {
    //Input Validation
    if(username == "") {
      setState(()=> {errorMsg = "Username is required!",_isLoading = false});
      return;
    }
    if(password == "") {
      setState(()=>{errorMsg = "Password is required!",_isLoading = false});
      return;
    }
    //Send request
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': username, 'password': password};
    var jsonResponse;
    Map<String, String> headers = {
      'Accept': '*/*',
      "Access-Control_Allow_Origin": "*",
      "Content-Type": "application/json"
    };
    var response = await http.post(Uri.parse(loginURI),
        headers: headers, body: jsonEncode(data));
    print("DEBUG: login-post");
    print(response);
    jsonResponse = json.decode(response.body);
    //Decode response
    if (response.statusCode == 200) {
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['accessToken']);
        sharedPreferences.setString("uname", username);
        sharedPreferences.setBool("isProcessed", false);
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = jsonResponse['message'] ?? 'Error logging in';
      print("The error message is: ${response.body}");
    }
  }
}
