import 'package:flutter/material.dart';

void main() {
  runApp(EyeSightApp());
}

class EyeSightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EyeSightPage(),
    );
  }
}

class EyeSightPage extends StatefulWidget {
  @override
  _EyeSightPageState createState() => _EyeSightPageState();
}

class _EyeSightPageState extends State<EyeSightPage> {
  double leftEyeSight = 0.0;
  double rightEyeSight = 0.0;
  double baseTextSize = 16.0;
  double adjustedTextSize = 16.0; // Initialize with the base size

  void updateTextSize() {
    // Adjust text size based on eyesight values
    double averageEyeSight = (leftEyeSight + rightEyeSight) / 2;
    double textSizeFactor = baseTextSize / averageEyeSight;

    setState(() {
      // Update text size using the calculated factor
      adjustedTextSize = baseTextSize / textSizeFactor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EyeSight Text Adjuster'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  leftEyeSight = double.tryParse(value) ?? 0.0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Left Eye Sight'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  rightEyeSight = double.tryParse(value) ?? 0.0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Right Eye Sight'),
            ),
            ElevatedButton(
              onPressed: updateTextSize,
              child: Text('Update Text Size'),
            ),
            SizedBox(height: 20),
            Text(
              'Sample Text with Adjusted Size',
              style: TextStyle(fontSize: adjustedTextSize), // Apply adjusted text size here
            ),
          ],
        ),
      ),
    );
  }
}
