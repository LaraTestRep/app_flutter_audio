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
  String estado = 'parado';
  int timeProgress = 0;
  int audioDuration = 0;

  @override
  void initState() {
    super.initState();
    //AudioPlayer.global
    //    .setGlobalAudioContext(AudioContextConfig(/*...*/).build());

    player.setSourceUrl(url);

    player.onPlayerStateChanged.listen((PlayerState s) {
      //print('Estado: $s');
      _atualizarEstado();
      setState(() {
        playerState = s;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        estado = 'parado';
      });
    });

    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inMilliseconds;
      });
    });

    player.onPositionChanged.listen((Duration p) {
      setState(() {
        timeProgress = p.inMilliseconds;
      });
    });
  }

  Widget slider() {
    return SizedBox(
      width: 300,
      child: Slider.adaptive(
          max: (audioDuration / 1000).floorToDouble(),
          value: (timeProgress / 1000).floorToDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    player.seek(newPosition);
  }

  String getTimeString(int milliseconds) {
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
    player.dispose();
  }

  playMusic() async {
    setState(() {
      estado = 'carregando';
    });

    //await player.play(DeviceFileSource(url));
    await player.resume();
    estado = 'tocando';
  }

  pauseMusic() async {
    estado = 'pausado';
    await player.pause();
  }

  _atualizarEstado() {
    switch (estado) {
      case 'tocando':
        return const Text('Tocando...');
      case 'parado':
        return const Text('Parado...');
      case 'pausado':
        return const Text('Pausado...');
      case 'carregando':
        return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tocando música url'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: _atualizarEstado(),
            ),
            IconButton(
              onPressed: () {
                playerState == PlayerState.playing ? pauseMusic() : playMusic();
              },
              icon: Icon(playerState == PlayerState.playing
                  ? Icons.stop_rounded
                  : Icons.play_arrow_rounded),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getTimeString(timeProgress)),
                const SizedBox(width: 20),
                SizedBox(width: 250, child: slider()),
                const SizedBox(width: 20),
                Text(getTimeString(audioDuration)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
