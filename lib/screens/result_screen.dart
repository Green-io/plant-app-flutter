import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:plant_disease_detection/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final fireStoreInstance = Firestore.instance;
  bool _loading = false;
  Map data;

  _fetchData() {
    try {
      setState(() {
        _loading = true;
      });

      DocumentReference documentReference =
          fireStoreInstance.collection("diseases").document("$diseaseName");
      documentReference.get().then((value) {
        setState(() {
          data = value.data;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    Future.delayed(Duration(seconds: 4), () {
      _fetchData();
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black.withOpacity(0.9),
                pinned: true,
                expandedHeight: MediaQuery.of(context).size.height * 0.35,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsetsDirectional.only(start: 55, bottom: 16),
                  title: data != null
                      ? Text(
                          '${data['plant']}',
                          style: TextStyle(
                            fontSize: 20.0,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      : Text(""),
                  background: data != null
                      ? Image.file(
                          File(imageFile.path),
                          fit: BoxFit.cover,
                        )
                      : Text(""),
                ),
              ),
              SliverFillRemaining(
                child: data != null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Disease',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                              subtitle: Text(
                                '  Name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text(
                                  "${data['diseaseName']}",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  12.0, 12.0, 12.0, 0),
                              child: Text(
                                '${data['desc']}',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () async {
                                  var url = '${data['readMore']}';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 12.0, top: 10.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.89),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 10.0,
                                      ),
                                      Text(
                                        '  Read More',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 12.0, top: 10.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 16.0,
                                    child: Image.asset(
                                      'assets/img/plant_disease.png',
                                    ),
                                  ),
                                  Text(
                                    ' Symptoms',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 12.0),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.bug_report_outlined,
                                        color: Colors.black,
                                        size: 15.0,
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '${data['symptoms'][0]}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.bug_report_outlined,
                                          color: Colors.black,
                                          size: 15.0,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              '${data['symptoms'][1]}',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.bug_report_outlined,
                                        color: Colors.black,
                                        size: 15.0,
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            '${data['symptoms'][2]}',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            data['pesticides'] != null
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 12.0, top: 10.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 16.0,
                                          child: Image.asset(
                                            'assets/img/pesticides.png',
                                          ),
                                        ),
                                        Text(
                                          ' Pesticides',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(""),
                            data['pesticides'] != null
                                ? Container(
                                    margin: const EdgeInsets.only(left: 12.0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.bug_report_outlined,
                                              color: Colors.black,
                                              size: 15.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: data['pesticides'] !=
                                                        null
                                                    ? Text(
                                                        '${data['pesticides'][0]}',
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : Text(""),
                                              ),
                                            ),
                                            data['buyAt'] != null
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      var url =
                                                          '${data['buyAt'][0]}';
                                                      if (await canLaunch(
                                                          url)) {
                                                        await launch(url);
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.yellow
                                                            .withOpacity(0.9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      child: Text(
                                                        'Buy Now',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Text(""),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.bug_report_outlined,
                                                color: Colors.black,
                                                size: 15.0,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: data['pesticides'] !=
                                                          null
                                                      ? Text(
                                                          '${data['pesticides'][1]}',
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : Text(""),
                                                ),
                                              ),
                                              data['buyAt'] != null
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        var url =
                                                            '${data['buyAt'][1]}';
                                                        if (await canLaunch(
                                                            url)) {
                                                          await launch(url);
                                                        } else {
                                                          throw 'Could not launch $url';
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 12.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.yellow
                                                              .withOpacity(0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        child: Text(
                                                          'Buy Now',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Text(""),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(""),
                          ],
                        ),
                      )
                    : Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
