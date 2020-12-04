import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "About",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.green,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Doctor Green is an ML/AI driven application that serves to detect diseases in the leaves of several plants. With the application, presently competent to detect diseases in over 35+ samples of plant species, Green.io takes a step further into the realm of AI to come up with smart solutions for everyday life. Feel free to delve into our services and we hope that Doctor Green lives up to your expectations.",
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        'assets/img/plant-logo.png',
                      ),
                    ),
                  ),
                  Text(
                    "Created By",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Green.io",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
