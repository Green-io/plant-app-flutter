import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_detection/screens/about_body.dart';
import 'package:plant_disease_detection/screens/home_body.dart';
import 'package:plant_disease_detection/screens/result_screen.dart';
import 'package:tflite/tflite.dart';

File imageFile;
bool isImageLoaded = false;
String diseaseName = "";
List result;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.info,
  ];

  final pageList = <Widget>[
    HomeBody(),
    AboutPage(),
  ];

  _loadTfModel() async {
    var resultant = await Tflite.loadModel(
      model: "assets/tflite/model_unquant.tflite",
      labels: "assets/tflite/labels.txt",
    );
    print("Result: $resultant");
  }

  _applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 38,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      isImageLoaded = false;
      result = res;
      print(result);
      diseaseName = result[0]["label"].toString().substring(3);
    });
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add Plant Disease Picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            var pickedFile =
                await ImagePicker().getImage(source: ImageSource.gallery);
            setState(() {
              isImageLoaded = true;
              imageFile = File(pickedFile.path);
              _applyModelOnImage(File(pickedFile.path));
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ResultScreen()));
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            var pickedFile =
                await ImagePicker().getImage(source: ImageSource.camera);
            setState(() {
              isImageLoaded = true;
              imageFile = File(pickedFile.path);
              _applyModelOnImage(File(pickedFile.path));
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ResultScreen()));
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  @override
  void initState() {
    super.initState();
    isImageLoaded = true;
    _loadTfModel().then((value) {
      setState(() {
        isImageLoaded = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black.withOpacity(0.9),
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 28,
        ),
        onPressed: _onCameraClick,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        iconSize: 28,
        splashColor: Colors.green,
        activeColor: Colors.green.shade400,
        inactiveColor: Colors.green.shade100,
        backgroundColor: Colors.black.withOpacity(0.9),
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (int index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
