import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const TextToSpeechApp());
}

class TextToSpeechApp extends StatelessWidget {
  const TextToSpeechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Text-to-Speech Example",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TextToSpeechScreen(),
    );
  }
}

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({super.key});

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  late FlutterTts flutterTts;
  String textToRead =
      "Hello, welcome to the Flutter text-to-speech example. You can adjust the playback speed using the buttons below.";
  double playbackSpeed = 0.5;
  bool isPlaying = false;
  final List<double> speeds = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
  int tappedWordIndex = 0;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(playbackSpeed);
  }

  Future<void> _togglePlayPause(int startWordIndex) async {
    if (isPlaying) {
      await flutterTts.stop();
    } else {
      final words = textToRead.split(' ');
      final substring = words.sublist(startWordIndex).join(' ');
      await flutterTts.speak(substring);
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _adjustSpeed(double newSpeed) async {
    setState(() {
      playbackSpeed = newSpeed;
    });
    await flutterTts.setSpeechRate(newSpeed);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text-to-Speech Example"),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: _showPlaybackSpeedOptions,
                      icon: const Icon(Icons.speed),
                    ),
                    IconButton(
                      onPressed: () {
                        // Start reading from the tapped word
                        _togglePlayPause(tappedWordIndex);
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Text to Read:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  // Wrap the text with GestureDetector
                  onTapDown: (details) {
                    // Calculate the tapped word index
                    final tapPosition = (details.localPosition.dx / context.size!.width * textToRead.split(' ').length).toInt();
                    setState(() {
                      tappedWordIndex = tapPosition;
                    });
                    // Start reading from the tapped word
                    _togglePlayPause(tappedWordIndex);
                  },
                  child: Text(
                    textToRead,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlaybackSpeedOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Playback Speed"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: speeds.length,
                    itemBuilder: (context, index) {
                      final speed = speeds[index];
                      return ListTile(
                        title: Text(speed.toString()),
                        onTap: () {
                          _adjustSpeed(speed / 2.0);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
