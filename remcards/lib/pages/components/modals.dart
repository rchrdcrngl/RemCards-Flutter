import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:remcards/pages/components/rounded_text_field.dart';

Future<void> showEditProfileModal({BuildContext context, String username, String email, Function edit}){
  return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        TextEditingController usernameController = new TextEditingController(text: username);
        TextEditingController emailController = new TextEditingController(text: email);
        return SimpleDialog(
            children: [Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                Text('   Username', style: TextStyle(fontSize: 12),),
                SizedBox(height: 5,),
                RoundedTextField('username', Colors.blueGrey[50], Colors.blueGrey[700], usernameController, false, 12),
                SizedBox(height: 8,),
                Text('   Email', style: TextStyle(fontSize: 12),),
                SizedBox(height: 5,),
                RoundedTextField('email@email.com', Colors.blueGrey[50], Colors.blueGrey[700], emailController, false, 12),
                SizedBox(height: 5,),
                ElevatedButton(onPressed: ()async=>{await edit(usernameController.text, emailController.text), Navigator.pop(context)}, child: Text('Edit Profile'))
              ],
            ),
          ),]
        );
      }
  );
}

Future<void> showChangePasswordModal({BuildContext context, Function edit}){
  return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        TextEditingController passwordController = new TextEditingController();
        TextEditingController passwordConfirmController = new TextEditingController();
        return SimpleDialog(
          children: [Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Change Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 15,),
                RoundedTextField('Enter new password', Colors.blueGrey[50], Colors.blueGrey[700], passwordController, true, 12),
                SizedBox(height: 5,),
                RoundedTextField('Confirm new password', Colors.blueGrey[50], Colors.blueGrey[700], passwordConfirmController, true, 12),
                SizedBox(height: 5,),
                ElevatedButton(onPressed: ()async=>{await edit(passwordController.text, passwordConfirmController.text), Navigator.pop(context)}, child: Text('Change Password'))
              ],
            ),
          ),]
        );
      }
  );
}