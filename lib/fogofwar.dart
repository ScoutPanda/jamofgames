import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'world.dart';

class FogOfWar extends RectangleComponent with HasGameRef<MyGame> {
  final World _world;
  final double _coneWidth = 0.6;

  FogOfWar(this._world): super(priority: 1000) {
    size = _world.size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    var r = Rect.fromLTRB(0, 0, _world.size.x, _world.size.y);
    var angle = gameRef.player.angle - (pi / 2) - (_coneWidth / 2);
    canvas.drawPath(
        Path.combine(
            PathOperation.difference,
            Path()..addRect(r),
            Path()
              ..addOval(Rect.fromCircle(center: Offset(gameRef.player.x, gameRef.player.y), radius: 150))
              ..addPolygon([Offset(gameRef.player.x, gameRef.player.y),
                Offset(cos(angle) * 1000 + gameRef.player.x, sin(angle) * 1000 + gameRef.player.y),
                Offset(cos(angle + _coneWidth) * 1000 + gameRef.player.x, sin(angle + _coneWidth) * 1000 + gameRef.player.y)], true)
              ..close()
        ),
        Paint()..color = Colors.black);
  }
}