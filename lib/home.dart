import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output = [];
  final picker = ImagePicker();
  final textToSpeech = FlutterTts();

  @override
  void initState() {
    super.initState();
    speak("Welcome");

    loadModel().then((value) {
      setState(() {});
    });
  }

  classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 131,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        _output = output;
        _loading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
    // speak("Predictions is, ${_output[0]['label']}" ?? "Unknown");
  }

  Future pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
    // _output == null
    //     ? speak("Unknown data")
    //     : speak("Predictions is, ${await _output[0]['label']}" ?? "Unknown");
  }

  speak(String text) async {
    print("Callled...");
    await textToSpeech.setLanguage("en-US");
    await textToSpeech.setPitch(1);
    await textToSpeech.speak(text);
  }

  var text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton(),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                'Fruits Identifier',
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              Text(
                'Roland Udonna Uzoma (U1822223)',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/fruit.png',
                                      width: 100,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 300,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(_image),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _output != null && _output.isNotEmpty
                                        ? Builder(builder: (context) {
                                            return Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: _output[0]['label'] ==
                                                          null ||
                                                      _output[0]['label'] == 0
                                                  ? Text(
                                                      "Cannot Understand the output try with a valid scanner")
                                                  : Text(
                                                      "Predictions is, ${_output[0]['label']}" ??
                                                          "",
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontSize: 20),
                                                    ),
                                            );
                                          })
                                        : Text(
                                            "Cannot Understand the output try with a valid scanner",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  floatingActionButton() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(color: Colors.white, size: 25),
      visible: true,
      curve: Curves.bounceInOut,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Toggle',
      heroTag: 'toggele-hero-tag',
      backgroundColor: Colors.green,
      foregroundColor: Colors.black45,
      overlayOpacity: 0.7,
      elevation: 10.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(
              Icons.camera,
              size: 24,
            ),
            backgroundColor: Colors.redAccent,
            label: 'Camera',
            labelStyle: TextStyle(
              fontSize: 18.0,
            ),
            onTap: () {
              pickImage();
            }),
        SpeedDialChild(
          child: Icon(
            Icons.image,
            size: 24,
          ),
          backgroundColor: Colors.blueAccent,
          label: 'Gallery',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () async {
            pickGalleryImage();
          },
        )
      ],
    );
  }
}
