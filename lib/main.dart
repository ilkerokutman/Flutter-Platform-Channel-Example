import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppController appController = Get.put(AppController());
  String methodResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AppController>(builder: (app) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(app.eventText),
            ElevatedButton(
              onPressed: startTracking,
              child: Text("Start"),
            ),
            ElevatedButton(
              onPressed: stopTracking,
              child: Text("Stop"),
            ),
            Divider(),
            ElevatedButton(
              onPressed: triggerMethod,
              child: Text("Trigger Method"),
            ),
            Text("MethodResult: \n$methodResult")
          ],
        );
      }),
    );
  }

  void startTracking() async {
    appController.startListening();
  }

  void stopTracking() async {
    appController.stopListening();
  }

  void triggerMethod() async {
    var response = await appController.triggerMethod();
    setState(() {
      methodResult = response;
    });
  }
}

class AppController extends GetxController {
  static const MethodChannel method1 = MethodChannel("abc");
  static const EventChannel event1 = EventChannel("xyz");
  late StreamSubscription event1Stream;

  void startListening() async {
    event1Stream = event1
        .receiveBroadcastStream()
        .listen(myEventHandler, onError: onError);
    log("event stream started listening");
  }

  void stopListening() async {
    try {
      event1Stream.cancel();
      log("event stream canceled");
    } catch (_) {
      log("no need to cancel");
    }
  }

  myEventHandler(Object? event) async {
    //
    log("event: $event");
    String e = event.toString();
    _eventText.value = e;
    update();
  }

  onError(Object? error) async {
    //
    log("error: $error");
  }

  Future<String> triggerMethod() async {
    String result = "not started";
    try {
      final receivedResult =
          await method1.invokeMethod("ozge", "{\"a\":\"b\"}");
      result = receivedResult;
    } on PlatformException {
      result = "unknown";
    }
    return result;
  }

  final RxString _eventText = "Event not started yet".obs;
  String get eventText => _eventText.value;
}
