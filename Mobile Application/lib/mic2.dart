import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class Mic2 extends StatefulWidget {
  const Mic2({
    Key? key,
    required this.client,
  }) : super(key: key);

  @override
  final MqttServerClient client;

  State<Mic2> createState() => _HomeState();
}

class _HomeState extends State<Mic2> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
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

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    bool isRecorderReady = false;
  }

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    uploadAudioFile(audioFile);

    print('Recorded audio: $audioFile');
    // final storageRef = FirebaseStorage.instance.ref().child('latest');

    // final uploadTask = storageRef.putFile(audioFile);
    // final snapshot = await uploadTask
    //     .whenComplete(() => print('Audio uploaded successfully.'));

    // final downloadUrl = await snapshot.ref.getDownloadURL();
    // print('Download URL: $downloadUrl');
  }

  Future<void> createAlbum(String url) async {
    final response = await http.post(
      Uri.parse('192.168.81.197:6000/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': url,
      }),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to create album.');
    }
  }

  String responseDataString = '';

  Future<void> uploadAudioFile(File audioFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.81.197:6000/upload-audio'),
    );
    var audioStream = http.ByteStream(Stream.castFrom(audioFile.openRead()));
    var audioLength = await audioFile.length();
    var audioMime = MediaType('audio', 'mpeg');
    var audioFilePart = http.MultipartFile(
      'audio',
      audioStream,
      audioLength,
      filename: audioFile.path,
      contentType: audioMime,
    );
    request.files.add(audioFilePart);
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    try {
      var responseData = jsonDecode(responseString);
      print(responseData);
      var room = responseData["Room"];
      var Name = responseData["Name"];
      var value = responseData["value"];
      var Text = responseData["Text"];
      Map<String, dynamic> Light2_local = {
        "Name": responseData["Switch"],
        "value": responseData["Value"],
      };
      String jsonStr = json.encode(Light2_local);
      // print(room);

      if (room == "") {
        setState(() {
          responseDataString = "براہ کرم اپنا کمرہ بتائیں";
          return;
        });
      }
      if (Name == "") {
        setState(() {
          responseDataString = "براہ کرم سوئچ بیان کریں۔";
          return;
        });
      }
      if (value == "") {
        setState(() {
          responseDataString = "براہ کرم یا تو آن یا آف بتائیں";
          return;
        });
      }
      if (room == "room1") {
        publishMessage('my/topic', jsonStr, widget.client);
        setState(() {
          responseDataString = Text;
        });
      }
      if (room == "room2") {
        publishMessage('my/topic2', jsonStr, widget.client);
        setState(() {
          responseDataString = Text;
        });
      }
      if (room == "room3") {
        publishMessage('my/topic3', jsonStr, widget.client);
        setState(() {
          responseDataString = Text;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("آواز سے کنٹرول")),
          backgroundColor: Colors.grey[900],
        ),
        backgroundColor: Color.fromARGB(255, 209, 209, 209),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              // ignore: prefer_const_constructors
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 53, 168, 114)),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(
                        141, 243, 241, 241)), // Set the desired icon color
                // Add more styles here if needed
              ),
              child: Icon(
                recorder.isRecording ? Icons.stop : Icons.mic,
                size: 80,
              ),
              onPressed: () async {
                if (recorder.isRecording) {
                  await stop();
                } else {
                  await record();
                }
                setState(() {});
              }),
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 53, 168, 114),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: Text(
              responseDataString.isNotEmpty
                  ? responseDataString
                  : 'بولنے کے لیے مائیک کا بٹن دبائیں۔',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ])));
  }
}

class Album {
  final String url;

  const Album({required this.url});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      url: json['url'],
    );
  }
}
