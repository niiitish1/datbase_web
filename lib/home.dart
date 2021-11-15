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
  var link = "https://gorest.co.in/public/v1/users";
  String newUser = "";

  @override
  void initState() {
    super.initState();
    apiCall("");
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
                              arr.remove(indexNo);
                              isEnable = true;
                            });
                            apiDelete(userData);
                          },
                          child: Icon(Icons.delete),
                        ),
                      ),
                      SizedBox(height: 5)
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
          UserDataModel userDataModel = UserDataModel(
              "nitish", "nitish1@gmail.com", "male", "inactive", 0);
          var val = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUser(model: userDataModel),
            ),
          );
          if (val != null) {
            newUser = "?name=$val";
            apiCall(newUser);
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
            userData["gender"], userData["status"], userData["id"]);
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

  apiCall(String extra) async {
    var recp = await http.get(
      Uri.parse("${link + extra}"),
    );
    var jsonResp = jsonDecode(recp.body);
    setState(() {
      arr = jsonResp['data'];
    });
  }

  apiDelete(var userData) async {
    var resp = await http.delete(
      Uri.parse(link + "/${userData["id"]}"),
      headers: {
        "Authorization":
            "Bearer a39bd94de4d16524d53767585cca09968dee649f244d473750c25e3518e280fe"
      },
    );
    resp.statusCode == 204
        ? Fluttertoast.showToast(msg: "Deleted")
        : Fluttertoast.showToast(msg: "failed");

    setState(() {
      isEnable = false;
    });

    print("checking....:${arr.length}");
    if (arr.length <= 1) {
      newUser = "";
    }
    apiCall(newUser);
  }
}
