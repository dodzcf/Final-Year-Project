import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class AlanSpeech extends StatefulWidget {
  const AlanSpeech({Key? key}) : super(key: key);

  @override
  _AlanSpeechState createState() => _AlanSpeechState();
}

class _AlanSpeechState extends State<AlanSpeech> {
  String textt = "TEXT";
  _AlanSpeechState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
        "33b57c88ed3e4a8b35bcaa59be0774e72e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) async {
      if (command.data['command'] == 'open YouTube') {
        // Launches the app when a match occurs

        await LaunchApp.openApp(
            androidPackageName: 'com.google.android.youtube',
            appStoreLink:
                'https://play.google.com/store/apps/details?id=com.google.android.youtube&hl=en&gl=US',
            openStore: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Container(
              child: Text(textt, style: TextStyle(color: Colors.white)))),
    );
  }
}
