import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BlaireGame());
}

class BlaireGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blaire - Game for the Blind',
      theme: ThemeData.dark(),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  int playerPosition = 0; // Example player position
  bool isGameOver = false;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playSound(String assetPath) async {
    await audioPlayer.play(AssetSource(assetPath));
  }

  void movePlayer(String direction) {
    if (isGameOver) return;

    setState(() {
      if (direction == 'left') {
        playerPosition -= 1;
        playSound('audio/move.mp3'); // Add this file in assets/audio
      } else if (direction == 'right') {
        playerPosition += 1;
        playSound('audio/move.mp3');
      } else if (direction == 'jump') {
        playSound('audio/jump.mp3');
      }
    });

    checkCollision();
  }

  void checkCollision() {
    // Dummy collision detection
    if (playerPosition < 0 || playerPosition > 5) {
      isGameOver = true;
      playSound('audio/gameover.mp3');
      HapticFeedback.heavyImpact(); // Vibrate device
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blaire - Audio Adventure'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Player Position: $playerPosition',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30),
            if (!isGameOver) ...[
              ElevatedButton(
                  onPressed: () => movePlayer('left'), child: Text('Left')),
              ElevatedButton(
                  onPressed: () => movePlayer('jump'), child: Text('Jump')),
              ElevatedButton(
                  onPressed: () => movePlayer('right'), child: Text('Right')),
            ] else
              Text(
                'Game Over!',
                style: TextStyle(fontSize: 32, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
