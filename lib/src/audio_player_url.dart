import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerURL extends StatefulWidget {
  const AudioPlayerURL({super.key});

  @override
  State<AudioPlayerURL> createState() => _AudioPlayerURLState();
}

class _AudioPlayerURLState extends State<AudioPlayerURL> {
  AudioPlayer player = AudioPlayer();
  PlayerState playerState = PlayerState.paused;
  //https://www.soundhelix.com/audio-examples
  String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3';

  @override
  void initState() {
    super.initState();
    AudioPlayer.global
        .setGlobalAudioContext(AudioContextConfig(/*...*/).build());
    player.onPlayerStateChanged.listen((PlayerState s) {
      //print('Estado: $s');
      setState(() {
        playerState = s;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    player.dispose();
  }

  playMusic() async {
    await player.play(DeviceFileSource(url));
  }

  pauseMusic() async {
    await player.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              playerState == PlayerState.playing ? pauseMusic() : playMusic();
            },
            icon: Icon(playerState == PlayerState.playing
                ? Icons.stop_rounded
                : Icons.play_arrow_rounded),
          )
        ],
      ),
    );
  }
}
