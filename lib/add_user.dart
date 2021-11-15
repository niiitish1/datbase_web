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
  var link = "https://gorest.co.in/public/v1/users";
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
                        onPressed: () {
                          updateApi();
                        },
                        child: Text("Update"))),
                Text(
                  text,
                  style: TextStyle(fontSize: 20),
                )
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
    var resp = await http.post(
      Uri.parse(link),
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
    print(resp.statusCode);
    switch (resp.statusCode) {
      case 201:
        setState(() {
          text = "User Added   ${email.text}";
          Future.delayed(Duration(milliseconds: 3000), () {
            Navigator.pop(context, true);
          });
        });
        break;
      case 422:
        setState(() {
          text = "error ${resp.statusCode} please make some change";
        });
        break;
      default:
        setState(() {
          text = "error ${resp.statusCode}";
        });
    }
  }

  updateApi() async {
    print(link + "/${model.id}");
    var resp = await http.patch(
      Uri.parse(link + "/${model.id}"),
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
    switch (resp.statusCode) {
      case 200:
        setState(() {
          text = "User Updated   ${email.text}";
          Future.delayed(Duration(milliseconds: 3000), () {
            Navigator.pop(context, true);
          });
        });
        break;
      default:
        setState(() {
          text = "error ${resp.statusCode}";
        });
    }
    print(resp.statusCode);
  }
}
