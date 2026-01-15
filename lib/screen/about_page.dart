import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: const Column(
          children: [
            Image(
              image: AssetImage('images/logo.png'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Attendance \nwith Qr Code',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Developer: Abed Putra',
              style: TextStyle(fontSize: 13.0, color: Colors.grey),
            ),
            Text(
              'https://abedputra.my.id',
              style: TextStyle(fontSize: 13.0, color: Colors.grey),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Attendance With Qr is a app focused on fast and easy way keep track of attendance of your users and access your data of your users with website base.',
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
