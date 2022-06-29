import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      // game: MyGame(),
      game: MyGameAudio(),
    ),
  );
}

final style = TextStyle(color: BasicPalette.white.color);
final regular = TextPaint(style: style);

class MyGame extends FlameGame with HasTappables {
  final double characterSize = 200;
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  SpriteComponent myButton = SpriteComponent();
  bool turnAway = false;
  int dialogLevel = 0;
  TextPaint dialogTextPaint = TextPaint(
    style: const TextStyle(fontSize: 36, color: Colors.white),
  );
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(50, 50);
  int sceneLevel = 1;
  bool buttonNextShowing = false;
  int testing = 0;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    final double screenWidth = size[0];
    final double screenHeight = size[1];
    const double textBoxHeight = 100;
    background
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(screenWidth, screenHeight - 100);
    add(background);

    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..anchor = Anchor.topCenter;
    add(girl);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize
      ..anchor = Anchor.topCenter
      ..flipHorizontally();
    add(boy);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position = Vector2(
        size[0] - buttonSize[0] - 10,
        size[1] - buttonSize[1] - 10,
      );

    myButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position = Vector2(
        size[0] - buttonSize[0] - 80,
        size[1] - buttonSize[1] - 80,
      );

    background2
      ..sprite = await loadSprite('castle.jpg')
      ..size = Vector2(screenWidth, screenHeight - 100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2 - 100) {
      girl.x += 30 * dt;
      if (girl.x > 50 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 150 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    } else if (turnAway == false && sceneLevel == 1) {
      boy.flipHorizontally();
      turnAway = true;
      if (dialogLevel == 2) {
        dialogLevel = 3;
      }
    }
    if (boy.x > size[0] / 2 - 50 && sceneLevel == 1) {
      boy.x -= 30 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    switch (dialogLevel) {
      case 1:
        dialogTextPaint.render(
          canvas,
          'Keiko: Ken. don\'t go... You\'ll die',
          Vector2(10, size[1] - 100),
        );
        break;
      case 2:
        dialogTextPaint.render(
          canvas,
          'Ken: I must fight for our village.',
          Vector2(10, size[1] - 100),
        );
        break;
      case 3:
        dialogTextPaint.render(
          canvas,
          'Keiko: What about the baby?.',
          Vector2(10, size[1] - 100),
        );
        if (!dialogButton.isLoaded) add(dialogButton);
        break;
    }

    switch (dialogButton.scene2Level) {
      case 1:
        sceneLevel = 2;
        canvas.drawRect(
          Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
          Paint()..color = Colors.black,
        );
        dialogTextPaint.render(
          canvas,
          'Ken: Child? I did not know!',
          Vector2(10, size[1] - 100),
        );

        if (turnAway) {
          boy.flipHorizontally();
          boy.x = boy.x + 150;
          turnAway = false;
          remove(background);
          remove(boy);
          remove(girl);
        }
        if (!background.isMounted && !background2.isMounted) add(background2);
        if (!girl.isMounted) add(girl);
        if (!boy.isMounted) add(boy);
        break;
      case 2:
        canvas.drawRect(
          Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
          Paint()..color = Colors.black,
        );
        dialogTextPaint.render(
          canvas,
          'Keiko: Our child. Our future.',
          Vector2(10, size[1] - 100),
        );
        break;
      case 3:
        canvas.drawRect(
          Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
          Paint()..color = Colors.black,
        );
        dialogTextPaint.render(
          canvas,
          'Ken: My future will live through you.',
          Vector2(10, size[1] - 100),
        );
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print("Print Tap Down 11: ${info.eventPosition.game}");
      scene2Level++;
      return true;
    } catch (ex) {
      return false;
    }
  }
}

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
