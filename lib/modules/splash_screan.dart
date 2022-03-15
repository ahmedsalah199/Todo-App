import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:todoapp/modules/home_screen.dart';
class SplashScrean extends StatefulWidget {
  const SplashScrean({Key? key}) : super(key: key);

  @override
  State<SplashScrean> createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 3000), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomeScreen()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('TODO' , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange,fontSize: 60),),
        Padding(
          padding: EdgeInsets.all(15.0),
          child:  LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 50,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: 1,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.green,
            alignment: MainAxisAlignment.center,

          ),
        )

          ],
        ),
      ),
    );
  }
}
