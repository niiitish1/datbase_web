// ignore_for_file: prefer_const_constructors

import 'package:database_app/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  UserDataModel model;
  AddUser({Key? key, required this.model}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _AddUserState createState() => _AddUserState(model);
}

class _AddUserState extends State<AddUser> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController status = TextEditingController();
  UserDataModel model;
  _AddUserState(this.model);
  String text = "";

  @override
  Widget build(BuildContext context) {
    name.text = model.name;
    email.text = model.email;
    gender.text = model.gender;
    status.text = model.status;
    return Scaffold(
      appBar: AppBar(
        title: Text("User Detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(name, "Name"),
                _buildTextField(email, "Email"),
                _buildTextField(gender, "Gender"),
                _buildTextField(status, "Status"),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          postApi();
                        },
                        child: Text("Add User"))),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {}, child: Text("Update"))),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Back"))),
                Text(text,
                    style: TextStyle(
                      fontSize: 20,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hint, labelText: hint, border: OutlineInputBorder()),
      ),
    );
  }

  postApi() async {
    UserDataModel(name.text, email.text, gender.text, status.text);
    print(model.email);
    print(email.text + ":- before");
    var resp = await http.post(
      Uri.parse("https://gorest.co.in/public/v1/users"),
      body: {
        "name": name.text,
        "email": email.text,
        "gender": gender.text,
        "status": status.text,
      },
      headers: {
        "Authorization":
            "Bearer a39bd94de4d16524d53767585cca09968dee649f244d473750c25e3518e280fe"
      },
    );
    if (resp.statusCode == 201) {
      setState(() {
        print(email.text);
        print(model.email);
        text = "User Added   ${email.text}";
        Future.delayed(Duration(milliseconds: 6000), () {
          Navigator.pop(context, true);
        });
      });
    } else {
      setState(() {
        print(email.text);
        print(model.email);
        text = "error ${resp.statusCode}  ${email.text}";
      });
    }
  }
}
