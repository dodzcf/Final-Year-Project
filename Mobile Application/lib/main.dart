import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sharp/mic.dart';
import 'package:sharp/start.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:dcdg/dcdg.dart';

Future<void> main() async {
  final client = await connect();
  // client.subscribe('my/topic', MqttQos.atLeastOnce);
  client.subscribe('my/switch_state3', MqttQos.atLeastOnce);
  client.subscribe('my/switch_state2', MqttQos.atLeastOnce);
  client.subscribe('my/switch_state', MqttQos.atLeastOnce);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: Home(
    title: "Login",
    client: client,
  )));
}

Future<MqttServerClient> connect() async {
  MqttServerClient client =
      MqttServerClient.withPort('broker.emqx.io', 'flutter_client2232', 1883);
  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
      .authenticateAs('dodz_fyp23', '123456')
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMessage;
  try {
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  final updates = client.updates;
  if (updates != null) {
    updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttMessage message = c[0].payload;
      if (message is MqttPublishMessage) {
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print('Received message:$payload from topic: ${c[0].topic}>');
        final json1 = json.decode(payload);
      }
    });
  }

  return client;
}

void onConnected() {
  print('Connected to MQTT broker.');
}

void onDisconnected() {
  print('Disconnected from MQTT broker.');
}

void onSubscribed(String topic) {
  print('Subscribed to topic: $topic');
}

void onSubscribeFail(String topic) {
  print('Failed to subscribe to topic: $topic');
}

void onUnsubscribed(String topic) {
  print('Unsubscribed from topic: $topic');
}

void pong() {
  print('Ping response received.');
}
