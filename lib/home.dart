// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:database_app/add_user.dart';
import 'package:database_app/user_data_model.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, indexNo) {
          var userData = arr[indexNo];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                UserDataModel data = UserDataModel(userData["name"],
                    userData["email"], userData["gender"], userData["status"]);
                return AddUser(model: data);
              }));
            },
            child: Column(
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
                    userData["gender"] == "male"
                        ? Icon(Icons.male)
                        : Icon(Icons.female)
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
            ),
          );
        },
        itemCount: arr.length,
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

  apiCall() async {
    var recp = await http.get(
      Uri.parse('https://gorest.co.in/public/v1/users'),
    );
    var jsonResp = jsonDecode(recp.body);
    setState(() {
      arr = jsonResp['data'];
    });
  }
}
