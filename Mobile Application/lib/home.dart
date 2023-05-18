// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sharp/signup.dart';
import 'package:sharp/start.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.title,
    required this.client,
  }) : super(key: key);
  final MqttServerClient client;

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  home createState() => home();
}

class home extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  late String user_array;

  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  void login({username, password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username.text.toLowerCase(), password: password.text);
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 18.0);

      Person p1 = Person(username.text.toLowerCase(), password.text);

      Map<String, dynamic> map = {
        'Email': p1.username,
      };
      user_array = jsonEncode(map);

      start(context, user_array);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // _showDialog(context, "NO user Found", password.text, "Try again");
        Fluttertoast.showToast(
            msg: "User Not Found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 18.0);

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong Password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 18.0);
        print('Wrong password provided for that user.');
      }
    }
  }

  void start(
    BuildContext contex,
    String user_array,
  ) async {
    Navigator.push(
      contex,
      MaterialPageRoute(
        builder: (context) => Start(
          title: 'Login',
          client: widget.client,
          // user_data: user_array,
        ),
      ),
    );
  }

  void signupstart(
    BuildContext contex,
  ) async {
    Navigator.push(
      contex,
      MaterialPageRoute(
        builder: (context) => SignUp(
          title: 'Login',
          client: widget.client,
          // user_data: user_array,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, title, text, button) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.indigo[600],
          title: Text(
            title + "!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          content: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                button,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
          backgroundColor: Colors.grey[900],
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
          child: SingleChildScrollView(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20, // <-- SEE HERE
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80), // Image border
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(98), // Image radius
                      child:
                          Image.asset('images/login5.png', fit: BoxFit.cover),
                    ),
                  ),
                  // ignore: sized_box_for_whitespace
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Smart Home System",
                    style: TextStyle(
                        color: Color.fromARGB(255, 153, 133, 217),
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ////////////////////////////////////////
                  /////////////   Card ////////////
                  ////////////////////////////////////////
                  Center(
                    child: Container(
                      width: 400,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: const Color.fromARGB(99, 105, 28, 248),
                        elevation: 10,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Image.asset('images/form.png',
                                  fit: BoxFit.cover),
                              title: const Text('Login ',
                                  style: TextStyle(color: Colors.white)),
                              subtitle: const Text(
                                  'Please Enter Credentials to Login',
                                  style: TextStyle(color: Colors.white)),
                            ),

                            ////////////////////////////////////////
                            /////////////   FORM FIELDS ////////////
                            ////////////////////////////////////////
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 18),
                              // width: 400,
                              child: TextField(
                                controller: username,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Color.fromARGB(174, 82, 24, 198),
                                  filled: true,
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              // width: 400,
                              child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Color.fromARGB(174, 82, 24, 198),
                                  filled: true,
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ButtonTheme(
                              buttonColor: Color.fromARGB(255, 158, 127,
                                  205), // Set the button color to blue
                              textTheme: ButtonTextTheme.accent,
                              child: Center(
                                child: ElevatedButton(

                                    // minWidth: 200,
                                    // color: Colors.indigo,
                                    child: const Text('Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () {
                                      login(
                                          username: username,
                                          password: password);
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ButtonTheme(
                              buttonColor: Color.fromARGB(255, 158, 127,
                                  205), // Set the button color to blue
                              textTheme: ButtonTextTheme.accent,

                              child: Center(
                                child: ElevatedButton(

                                    // minWidth: 200,
                                    // color: Colors.indigo,
                                    child: const Text('SignUp',
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                    onPressed: () {
                                      signupstart(context);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }
}

class Person {
  Person(this.username, this.fullname);
  final String username;
  final String fullname;
}
