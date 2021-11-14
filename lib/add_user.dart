// ignore_for_file: prefer_const_constructors

import 'package:database_app/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  UserDataModel model;
  AddUser({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState(model);
}

class _AddUserState extends State<AddUser> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  UserDataModel model;
  _AddUserState(this.model);

  @override
  Widget build(BuildContext context) {
    print(model.name);
    print(model.email);
    print(model.gender);
    print(model.status);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTextField("name", name),
            _buildTextField("Email", email),
            ElevatedButton(
                onPressed: () {
                  postApi();
                },
                child: Text("Submit")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Back"))
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      initialValue: text,
      decoration: InputDecoration(
        hintText: text,
        labelText: text,
      ),
    );
  }

  postApi() async {
    var resp = await http.post(
      Uri.parse("https://gorest.co.in/public/v1/users"),
      body: {
        "name": name.text,
        "email": email.text,
        "gender": "male",
        "status": "active",
      },
      headers: {
        "Authorization":
            "Bearer a39bd94de4d16524d53767585cca09968dee649f244d473750c25e3518e280fe"
      },
    );
    print(resp.body);
    print(resp.statusCode);
    if (resp.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }
}
