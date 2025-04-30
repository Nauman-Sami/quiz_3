import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: WaterTrackerBasicApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class WaterTrackerBasicApp extends StatefulWidget {
  @override
  _WaterTrackerBasicAppState createState() => _WaterTrackerBasicAppState();
}

class _WaterTrackerBasicAppState extends State<WaterTrackerBasicApp>
    with SingleTickerProviderStateMixin {
  int waterCount = 0;
  final int goal = 8;
  double progress = 0.0;
  int messageIndex = 0;
  bool showReminder = false;
  bool goalReached = false;

  late AnimationController _controller;
  late Animation<double> _floatUp;

  List<String> messages = [
    "Stay hydrated!",
    "Great job!",
    "Keep it up!",
    "You're doing great!",
    "Almost there!",
    "Goal achieved! 🎉",
  ];

  @override
  void initState() {
    super.initState();

    // Balloon animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _floatUp = Tween<double>(begin: 0.0, end: -200.0).animate(_controller);

    // Hydration reminder every 10s
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (!goalReached && mounted) {
        setState(() {
          showReminder = !showReminder;
        });
      }
    });
  }

  void addWater() {
    if (waterCount < goal) {
      setState(() {
        waterCount++;
        progress = waterCount / goal;

        if (waterCount == goal) {
          goalReached = true;
          _controller.forward();
        }

        if (waterCount % 2 == 0 && messageIndex < messages.length - 1) {
          messageIndex++;
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HEALTHY LIFE WATER TRACK"),
        backgroundColor: Colors.blueAccent, //  Nav Bar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.orange.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: MediaQuery.of(context).size.width * progress,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 30),
                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 500),
                    firstChild: Text(
                      "Let's drink water!",
                      style: TextStyle(fontSize: 20),
                    ),
                    secondChild: Text(
                      messages[messageIndex],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    crossFadeState: CrossFadeState.showSecond,
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: showReminder ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Text(
                      "💧 Reminder: Take a sip!",
                      style: TextStyle(color: Colors.teal, fontSize: 16),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: addWater,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Grey button
                    ),
                    child: Text("Add Water"),
                  ),
                  SizedBox(height: 10),
                  Text("Water: $waterCount / $goal"),
                ],
              ),
            ),
            // Balloon Animation
            if (goalReached)
              AnimatedBuilder(
                animation: _floatUp,
                builder: (context, child) {
                  return Positioned(
                    bottom: 50 + _floatUp.value,
                    left: MediaQuery.of(context).size.width / 2 - 25,
                    child: Icon(Icons.air, size: 50, color: Colors.pink),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
