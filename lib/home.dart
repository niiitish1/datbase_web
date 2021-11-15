// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:database_app/add_user.dart';
import 'package:database_app/user_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var arr = [];
  bool isEnable = false;

  @override
  void initState() {
    super.initState();
    apiCall(val: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, indexNo) {
                var userData = arr[indexNo];
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: _showUserData(userData),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isEnable = true;
                            });
                            apiDelete(userData);
                            apiCall(val: false);
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                );
              },
              itemCount: arr.length,
            ),
            if (isEnable) ...[
              Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          UserDataModel userDataModel =
              UserDataModel("nitish", "nitish6@gmail.com", "male", "inactive");
          var res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(model: userDataModel),
            ),
          );
          if (res == true) {
            apiCall(val: true);
          }
        },
        child: Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Widget _showUserData(var userData) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        UserDataModel model = UserDataModel(userData["name"], userData["email"],
            userData["gender"], userData["status"]);
        return AddUser(model: model);
      })),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextSpan("ID: ", userData["id"].toString()),
          _buildTextSpan("Name: ", userData["name"]),
          GestureDetector(
              onTap: () async {
                Fluttertoast.showToast(msg: "Opening Gmail");
                final Uri params =
                    Uri(scheme: "mailto", path: "${userData["email"]}");
                var url = params.toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Fluttertoast.showToast(msg: "Error while opening gmail");
                }
              },
              child: _buildTextSpan("Email: ", userData["email"])),
          Row(
            children: [
              _buildTextSpan("Gender: ", userData["gender"]),
              userData["gender"] == "male"
                  ? Icon(
                      Icons.male_outlined,
                      color: Colors.black,
                    )
                  : Icon(
                      Icons.female,
                      color: Colors.blue,
                    )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextSpan("Status: ", userData["status"]),
              SizedBox(width: 10),
              userData["status"] == "active"
                  ? Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    )
                  : Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }

  RichText _buildTextSpan(String text, var userData) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: userData,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  apiCall({bool? val}) async {
    var link = "https://gorest.co.in/public/v1/users";
    if (val == true) {
      link = "https://gorest.co.in/public/v1/users?email=nitish";
    }
    var recp = await http.get(
      Uri.parse(link),
    );
    var jsonResp = jsonDecode(recp.body);
    setState(() {
      arr = jsonResp['data'];
    });
  }

  apiDelete(var userData) async {
    var link = "https://gorest.co.in/public/v1/users";
    print(link + "/${userData["id"]}");
    var resp = await http.delete(
      Uri.parse(link + "/${userData["id"]}"),
      headers: {
        "Authorization":
            "Bearer a39bd94de4d16524d53767585cca09968dee649f244d473750c25e3518e280fe"
      },
    );
    if (resp.statusCode == 204) {
      Fluttertoast.showToast(msg: "Deleted");
    }
    setState(() {
      isEnable = false;
    });
  }
}
