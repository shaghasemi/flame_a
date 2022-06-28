import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  final double characterSize = 200;
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  bool turnAway = false;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    final double screenWidth = size[0];
    final double screenHeight = size[1];
    const double textBoxHeight = 100;

    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..anchor = Anchor.topCenter;

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize
      ..anchor = Anchor.topCenter
      ..flipHorizontally();

    background
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(screenWidth, screenHeight);

    add(background);
    add(girl);
    add(boy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2 - 50) {
      girl.x += 30 * dt;
    } else if (turnAway==false){
      boy.flipHorizontally();
      turnAway = true;
    }
    if (boy.x > size[0] / 2 + 50) {
      boy.x -= 30 * dt;
    }
  }
}
