// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sharp/home.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sharp/mic2.dart';
import 'package:sharp/room1.dart';
import 'package:sharp/room2.dart';
import 'package:sharp/room3.dart';
import 'mic.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Start extends StatefulWidget {
  Start({
    Key? key,
    required this.title,
    required this.client,
    // required this.user_data
  }) : super(key: key);
  final MqttServerClient client;

  // ignore: non_constant_identifier_names
  // final String user_data;

  final String title;
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _start createState() => _start();
}

class _start extends State<Start> {
  int _selectedIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white);

  void room1(
    BuildContext contex,
  ) {
    Navigator.push(
      contex,
      MaterialPageRoute(
        builder: (context) => Room1(client: widget.client),
      ),
    );
  }

  void room2(
    BuildContext contex,
  ) {
    Navigator.push(
      contex,
      MaterialPageRoute(
        builder: (context) => Room2(client: widget.client),
      ),
    );
  }

  void room3(
    BuildContext contex,
  ) {
    Navigator.push(
      contex,
      MaterialPageRoute(
        builder: (context) => Room3(client: widget.client),
      ),
    );
  }

  void mic(
    BuildContext contex,
  ) {
    Navigator.push(
      contex,
      MaterialPageRoute(
        builder: (context) => Mic2(client: widget.client),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ////////////////////////////////////////
      /////////////   HOME CODE ////////////
      ////////////////////////////////////////
      Center(
        child: Container(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: Image.asset("images/room2.png"),
                      ),
                    ),
                    Center(
                      child: Text("کمرہ منتخب کریں۔",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),

                      // elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          TextButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 12),
                              child: ListTile(
                                leading: Image.asset(
                                  'images/room.png',
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                                title: Text('پہلا کمرہ'),
                                // subtitle: Text('Control Room 1'),
                              ),
                            ),
                            onPressed: () {
                              room1(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          TextButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              child: ListTile(
                                leading: Image.asset(
                                  'images/room.png',
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                                title: Text('دوسرا کمرہ'),
                                // subtitle: Text('Control Room 1'),
                              ),
                            ),
                            onPressed: () {
                              room2(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: <Widget>[
                          TextButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              child: ListTile(
                                leading: Image.asset(
                                  'images/room.png',
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                                title: Text('تیسرا کمرہ'),
                                // subtitle: Text('Control Room 1'),
                              ),
                            ),
                            onPressed: () {
                              room3(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
            )),
      ),
      ////////////////////////////////////////
      /////////////   MIC CODE ////////////
      ////////////////////////////////////////
      Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: 60,
            icon: Icon(Icons.mic),
            onPressed: () {
              mic(context);
            },
            color: Colors.white,
          ),
        ),
      ),

      ////////////////////////////////////////
      /////////////   About Us ////////////
      ////////////////////////////////////////
      Container(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
                margin:
                    EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(186, 158, 158, 158),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 25, right: 20, left: 20),
                    child: Column(children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAbZI-ySfPc5nNjvyU1GQS_UXGmcb_1nwwxQ&usqp=CAU"),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 200,
                                child: Column(
                                  children: [
                                    Text(
                                      "Dawood Zahir",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Full Stack Web Developer",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "IOT Engineer",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "p180032@nu.edu.pk",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "P180032",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Roll Number",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ]),
                  ),
                )),
            Container(
                margin:
                    EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(186, 158, 158, 158),
                        spreadRadius: 10,
                        blurRadius: 3,
                        // changes position of shadow
                      ),
                    ]),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 25, right: 20, left: 20),
                    child: Column(children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://cdn-icons-png.flaticon.com/512/180/180679.png"),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 200,
                                child: Column(
                                  children: [
                                    Text(
                                      "Ummay Hani Javed",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Application Developer",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "p190044@nu.edu.pk",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Container(
                                width: 0.5,
                                height: 40,
                                color: Color.fromARGB(177, 0, 0, 0),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "P190044",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Roll Number",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ]),
                  ),
                )),
          ]),
        ),
      ),
      ////////////////////////////////////////
      /////////////   PROFILE PAGE ////////////
      ////////////////////////////////////////
      // Stack(children: [
      //   Container(
      //     margin: EdgeInsets.only(top: 48),
      //     height: 300,
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(16.0),
      //     ),
      //   ),
      //   Align(
      //       alignment: Alignment.bottomCenter,
      //       child: SizedBox(
      //         // ignore: prefer_const_literals_to_create_immutables
      //         child: Column(children: <Widget>[
      //           CircleAvatar(
      //             radius: 40.0,
      //             backgroundColor: Colors.white,
      //             child: CircleAvatar(
      //               // ignore: sort_child_properties_last
      //               child: Align(
      //                 alignment: Alignment.bottomRight,
      //                 child: CircleAvatar(
      //                   backgroundColor: Colors.white,
      //                   radius: 12.0,
      //                   child: Icon(
      //                     Icons.camera_alt,
      //                     size: 15.0,
      //                     color: Color(0xFF404040),
      //                   ),
      //                 ),
      //               ),
      //               radius: 38.0,
      //               backgroundImage: AssetImage('images/bulb.png'),
      //             ),
      //           ),
      //           const SizedBox(
      //             height: 20,
      //           ),
      //           Text("data", style: TextStyle(color: Colors.black)),
      //         ]),
      //       )),
      // ]),
      Container(
          // child: AlanSpeech(),
          child: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () async {
          await auth.signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => Home(
                      title: "Login",
                      client: widget.client,
                    )),
          );
        },
      ))
    ];
    return WillPopScope(
      onWillPop: () async {
        /* Do something here if you want */
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 205, 204, 204),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'آرام دہ طرز زندگی',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Color.fromARGB(255, 31, 31, 31).withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                // rippleColor: Color.fromARGB(255, 180, 46, 146)!,
                hoverColor: Color.fromARGB(255, 46, 199, 191),
                gap: 8,
                activeColor: Color.fromARGB(255, 251, 249, 249),
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Color.fromARGB(255, 50, 225, 234),
                color: Color.fromARGB(255, 73, 131, 115),
                // ignore: prefer_const_literals_to_create_immutables
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'ہوم',
                  ),
                  GButton(
                    icon: LineIcons.microphone,
                    text: 'مائیک',
                  ),
                  GButton(
                    icon: LineIcons.addressCard,
                    text: 'تعارف',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'لاگ آوٹ',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
