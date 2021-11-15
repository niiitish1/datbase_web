// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:database_app/add_user.dart';
import 'package:database_app/user_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    apiCall();
  }

  var arr = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, indexNo) {
            var userData = arr[indexNo];
            return Container(
              padding: EdgeInsets.all(8),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextSpan("ID: ", userData["id"].toString()),
                      _buildTextSpan("Name: ", userData["name"]),
                      GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(msg: "Opening Gmail");
                          },
                          child: _buildTextSpan("Email: ", userData["email"])),
                      Row(
                        children: [
                          _buildTextSpan("Gender: ", userData["gender"]),
                          userData["gender"] == "male"
                              ? Icon(
                                  Icons.male,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.female,
                                  color: Colors.green,
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
                ),
                Expanded(
                  child: Icon(Icons.delete),
                ),
                SizedBox(
                  height: 5,
                )
              ]),
            );
          },
          itemCount: arr.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // var res = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => AddUser(),
          //   ),
          // );
          // if (res == true) {
          //   apiCall();
          // }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTextSpan(String text, var userData) {
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

  apiCall() async {
    var recp = await http.get(
      Uri.parse('https://gorest.co.in/public/v1/users'),
    );
    var jsonResp = jsonDecode(recp.body);
    setState(() {
      arr = jsonResp['data'];
    });
  }

  Widget _showData(var userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Id: ${userData['id'].toString()}',
          style: TextStyle(
            fontSize: 16,
            // color: Colors.w,
          ),
        ),
        Text(
          'Name: ${userData['name']}',
          style: TextStyle(
            fontSize: 16,
            // color: Colors.white,
          ),
        ),
        Text(
          'Email: ${userData['email']}',
          style: TextStyle(
            fontSize: 16,
            // color: Colors.white,
          ),
        ),
        Row(
          children: [
            Text(
              "gender: ${userData["gender"]}",
              style: TextStyle(fontSize: 16),
            ),
            userData["gender"] == "male" ? Icon(Icons.male) : Icon(Icons.female)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status: ${userData['status']}',
              style: TextStyle(
                fontSize: 16,
                // color: Colors.white,
              ),
            ),
            //teermaeri
            userData["status"] == "active"
                ? Container(
                    width: 10,
                    height: 25,
                    color: Colors.green,
                  )
                : Container(
                    width: 10,
                    height: 25,
                    color: Colors.red,
                  )
          ],
        ),
      ],
    );
  }

  Widget _dectectClick(var userData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          UserDataModel data = UserDataModel(userData["name"],
              userData["email"], userData["gender"], userData["status"]);
          return AddUser(model: data);
        }));
      },
    );
  }
}
