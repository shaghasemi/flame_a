import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

final style = TextStyle(color: BasicPalette.white.color);
final regular = TextPaint(style: style);

class MyGameAudio extends FlameGame with TapDetector, DoubleTapDetector {
  bool isPlayingMusic = false;
  int trackNumber = 1;
  TextComponent instructions = TextComponent();
  final String instructionString = 'Play: Single Tap\n'
      'Stop: Single Tap\n'
      'Next Song: Double Tap\n';

  @override
  Future<void>? onLoad() {
    instructions
      ..text = '$instructionString\n Track Number: $trackNumber'
      ..textRenderer = regular
      ..y = 100
      ..x = 20;

    add(instructions);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (!isPlayingMusic) {
      switch (trackNumber) {
        case 1:
          FlameAudio.bgm.play('track01.mp3');
          isPlayingMusic = true;
          break;
        case 2:
          FlameAudio.bgm.play('track02.mp3');
          isPlayingMusic = true;
          break;
      }
      instructions.text =
          '$instructionString\n Track Number: $trackNumber\n Status: Playing';
    } else {
      FlameAudio.bgm.stop();
      isPlayingMusic = false;
      instructions.text =
          '$instructionString\n Track Number: $trackNumber\n Status: Stopped';
    }
    super.onTapUp(info);
  }

  @override
  void onDoubleTap() {
    trackNumber++;
    if (trackNumber > 2) {
      trackNumber = 1;
    }
    if (isPlayingMusic) {
      instructions.text =
          '$instructionString\n Track Number: $trackNumber\n Status: Playing';
    } else {
      instructions.text =
          '$instructionString\n Track Number: $trackNumber\n Status: Stopped';
    }
    super.onDoubleTap();
  }
}
