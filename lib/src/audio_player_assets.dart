import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerAssets extends StatefulWidget {
  const AudioPlayerAssets({super.key});

  @override
  State<AudioPlayerAssets> createState() => _AudioPlayerAssetsState();
}

class _AudioPlayerAssetsState extends State<AudioPlayerAssets> {
  final player = AudioPlayer();
  PlayerState playerState = PlayerState.stopped;
  String caminhoMusica = 'lib/assets/music/';
  String nomeMusica = 'enya_epona.mp3';

  @override
  void initState() {
    super.initState();

    player.audioCache.prefix = caminhoMusica;
    player.setSource(AssetSource(nomeMusica));

    player.onPlayerStateChanged.listen((event) {
      setState(() {
        playerState = event;
      });
    });

    // player.onPlayerComplete.listen((event) {
    //   setState(() {
    //     playerState = PlayerState.stopped;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    player.audioCache.clearAll();
    player.release();
    player.dispose();
  }

  _showIcon() {
    switch (playerState) {
      case PlayerState.playing:
        return Icons.pause_circle_rounded;
      case PlayerState.paused:
        return Icons.play_arrow_rounded;
      case PlayerState.completed:
        return Icons.play_arrow_rounded;
      case PlayerState.stopped:
        return Icons.play_arrow_rounded;
    }
  }

  _playMusic() async {
    await player.resume();
  }

  _pauseMusic() async {
    await player.pause();
  }

  _acaoPlayer() {
    switch (playerState) {
      case PlayerState.playing:
        _pauseMusic();
        break;
      case PlayerState.paused:
        _playMusic();
        break;
      case PlayerState.completed:
        _playMusic();
        break;
      case PlayerState.stopped:
        _playMusic();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tocando música assets'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 100,
              onPressed: () {
                _acaoPlayer();
              },
              icon: Icon(_showIcon()),
            )
          ],
        ),
      ),
    );
  }
}
