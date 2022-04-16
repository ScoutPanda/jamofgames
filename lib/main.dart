import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'fogofwar.dart';
import 'orchestrator.dart';
import 'player.dart';
import 'world.dart';

class MyGame extends FlameGame with HasDraggables, HasCollisionDetection, TapDetector {
  late final Player player;
  final world = World();
  int score = 0;
  bool dead = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    final joystick = await _createJoystick();

    player = Player(joystick);
    await add(world);
    await add(player);
    await add(FogOfWar(world));
    await add(joystick);
    await add(Orchestrator());

    camera.followComponent(player, worldBounds: Rect.fromLTRB(0, 0, world.size.x, world.size.y));
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    player.shoot();
  }

  Future<JoystickComponent> _createJoystick() async {
    final knobSprite = await Sprite.load('knob.png');
    final backgroundSprite = await Sprite.load("knobbg.png");

    return JoystickComponent(
      priority: 9999,
      knob: SpriteComponent(
        sprite: knobSprite,
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: backgroundSprite,
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    var textPaint = TextPaint();
    if (dead) {
      priority = 100000;
      canvas.drawRect(Rect.fromLTRB(0, 0, world.size.x, world.size.y), Paint()..color = Colors.black);
      textPaint.render(canvas, "Final score: " + score.toString(), size / 2);
      pauseEngine();
    } else {
      textPaint.render(canvas, "Score: " + score.toString(), Vector2(10, 10));
      textPaint.render(canvas, "Hp left " + player.hp.toString(), Vector2(10, 30));
      if (player.powerup != null) {
        textPaint.render(canvas, "Powerups left " + player.powerup!.usagesLeft.toString(), Vector2(10, 50));
      }
    }
  }
}

main() {
  final myGame = MyGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}