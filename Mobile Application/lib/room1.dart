import 'dart:convert';
import 'dart:ffi';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_server_client.dart';

class Room1 extends StatefulWidget {
  const Room1({
    Key? key,
    required this.client,
  }) : super(key: key);
  @override
  final MqttServerClient client;

  _Room1 createState() => _Room1();
}

class _Room1 extends State<Room1> {
  @override
  void initState() {
    super.initState();
    getvalues('my/switch_state', widget.client);
  }

////////////////////////////////////
/////////////PUBLISHER//////////////
////////////////////////////////////
  void publishMessage(
      String pubTopic, String message, MqttServerClient client) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (builder.payload != null) {
      client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
    }
  }
////////////////////////////////////
/////////////VALUE GETTER//////////////
////////////////////////////////////

  void getvalues(String pubTopic, MqttServerClient client) {
    final builder = MqttClientPayloadBuilder();
    final message = {'Name': 'Get Data', 'value': "OFF"};
    final jsonStr = json.encode(message);
    builder.addString(jsonStr);
    client.publishMessage('my/topic', MqttQos.atLeastOnce, builder.payload!);

    // Listen to incoming messages
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      messages.forEach((MqttReceivedMessage<MqttMessage> message) {
        final MqttPublishMessage receivedMessage =
            message.payload as MqttPublishMessage;
        final String payload = MqttPublishPayload.bytesToStringAsString(
            receivedMessage.payload.message);

        // Parse the JSON string into a Map
        final Map<String, dynamic> data = json.decode(payload);

        // Extract the values from the Map
        final int light1 = data['Light 1'];
        final int light2 = data['Light 2'];
        final int fan = data['Fan'];

        // Do something with the values
        print('Received Light 1: $light1');
        print('Received Light 2: $light2');
        print('Received Fan: $fan');
        _updateText(light1, light2, fan);
      });
    });
  }

////////////////////////////////////
/////////////VALUE GETTER//////////////
////////////////////////////////////

  int State1 = 0;
  int State2 = 0;
  int State3 = 0;

  String Light1 = "";
  String Light2 = "";
  String Fan = "";

  void _updateText(int light1, int light2, int fan) {
    setState(() {
      if (light1 != State1) {
        State1 = light1;
        if (State1 == 0) {
          Light1 = "OFF";
        } else if (State1 == 1) {
          Light1 = "ON";
        }
      } else if (light1 == State1) {
        if (State1 == 0) {
          Light1 = "OFF";
        } else if (State1 == 1) {
          Light1 = "ON";
        }
      }
      if (State2 != light2) {
        State2 = light2;
        if (State2 == 0) {
          Light2 = "OFF";
        } else if (State2 == 1) {
          Light2 = "ON";
        }
      } else if (light2 == State2) {
        if (State2 == 0) {
          Light2 = "OFF";
        } else if (State2 == 1) {
          Light2 = "ON";
        }
      }
      if (fan != State3) {
        State3 = fan;
        if (State3 == 0) {
          Fan = "OFF";
        } else if (fan == 1) {
          Fan = "ON";
        }
      } else if (fan == State3) {
        if (State3 == 0) {
          Fan = "OFF";
        } else if (State3 == 1) {
          Fan = "ON";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          /* Do something here if you want */
          return true;
        },
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 223, 223, 223),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Smart Home System',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Color.fromARGB(255, 255, 254, 254),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Center(
                          // ignore: avoid_unnecessary_containers
                          child: Container(
                            child: Image.asset("images/sun.png"),
                          ),
                        ),
                        Center(
                          child: Text("Room 1",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 13, 13, 13),
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
                                        'images/bulb.png',
                                        fit: BoxFit.cover,
                                        width: 77,
                                        height: 90,
                                      ),
                                      title: Text(Light1),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (State1 == 0) {
                                      const pubTopic = 'my/topic';
                                      Map<String, dynamic> Light1_local = {
                                        "Name": 'Light 1',
                                        "value": "ON",
                                      };
                                      String jsonStr =
                                          json.encode(Light1_local);
                                      publishMessage(
                                          pubTopic, jsonStr, widget.client);
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      getvalues(pubTopic, widget.client);
                                    } else if (State1 == 1) {
                                      const pubTopic = 'my/topic';
                                      Map<String, dynamic> Light1_local = {
                                        "Name": 'Light 1',
                                        "value": "OFF",
                                      };
                                      String jsonStr =
                                          json.encode(Light1_local);
                                      publishMessage(
                                          pubTopic, jsonStr, widget.client);
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      getvalues(pubTopic, widget.client);
                                    }
                                    ;
                                  }),
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
                                        'images/bulb.png',
                                        fit: BoxFit.cover,
                                        width: 77,
                                        height: 90,
                                      ),

                                      // title: Text(Light2),
                                      title: Text(Light2)
                                      // subtitle: Text('Control Room 1'),
                                      ),
                                ),
                                onPressed: () async {
                                  if (State2 == 0) {
                                    const pubTopic = 'my/topic';
                                    Map<String, dynamic> Light1_local = {
                                      "Name": 'Light 2',
                                      "value": "ON",
                                    };
                                    String jsonStr = json.encode(Light1_local);
                                    publishMessage(
                                        pubTopic, jsonStr, widget.client);
                                    await Future.delayed(Duration(seconds: 1));
                                    getvalues(pubTopic, widget.client);
                                  } else if (State2 == 1) {
                                    const pubTopic = 'my/topic';
                                    Map<String, dynamic> Light2_local = {
                                      "Name": 'Light 2',
                                      "value": "OFF",
                                    };
                                    String jsonStr = json.encode(Light2_local);
                                    publishMessage(
                                        pubTopic, jsonStr, widget.client);
                                    await Future.delayed(Duration(seconds: 1));
                                    getvalues(pubTopic, widget.client);
                                  }
                                  ;
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
                                      'images/fan.png',
                                      fit: BoxFit.cover,
                                      width: 75,
                                      height: 90,
                                    ),
                                    title: Text(Fan),
                                    // subtitle: Text('Control Room 1'),
                                  ),
                                ),
                                onPressed: () async {
                                  if (State3 == 0) {
                                    const pubTopic = 'my/topic';
                                    Map<String, dynamic> Fan1 = {
                                      "Name": 'Fan',
                                      "value": "ON",
                                    };
                                    String jsonStr = json.encode(Fan1);
                                    publishMessage(
                                        pubTopic, jsonStr, widget.client);
                                    await Future.delayed(Duration(seconds: 1));
                                    getvalues(pubTopic, widget.client);
                                  } else if (State3 == 1) {
                                    const pubTopic = 'my/topic';
                                    Map<String, dynamic> Fan1 = {
                                      "Name": 'Fan',
                                      "value": "OFF",
                                    };
                                    String jsonStr = json.encode(Fan1);
                                    publishMessage(
                                        pubTopic, jsonStr, widget.client);
                                    await Future.delayed(Duration(seconds: 1));
                                    getvalues(pubTopic, widget.client);
                                  }
                                  ;
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                )),
          ),
        ));
  }
}
