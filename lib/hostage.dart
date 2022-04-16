import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Hostage extends SpriteAnimationComponent {
  late final SpriteAnimation a;
  final double maxSpeed = 200;
  final double maxRotation = 0.3;
  late final double speed;
  late final double rotation;
  late Vector2 velocity;
  final int scoreForRescue = 150;

  Hostage(): super(priority: 3, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    var r = Random();
    if (r.nextBool()) {
      final s1 = await Sprite.load('man_a1.png');
      final s2 = await Sprite.load('man_a2.png');
      final s3 = await Sprite.load('man_a3.png');
      a = SpriteAnimation.spriteList([s1, s2, s1, s3], stepTime: 1);
    } else {
      final s1 = await Sprite.load('man_b1.png');
      final s2 = await Sprite.load('man_b2.png');
      final s3 = await Sprite.load('man_b3.png');
      a = SpriteAnimation.spriteList([s1, s2, s1, s3], stepTime: 1);
    }

    size = a.getSprite().originalSize;
    angle = r.nextDouble() * pi * 2;
    speed = r.nextDouble() * maxSpeed;
    rotation = r.nextDouble() * maxRotation * (r.nextBool() ? -1 : 1);
    velocity = Vector2(cos(angle) * speed, sin(angle) * speed);
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    a.update(dt);
    angle += rotation;
    position.add(velocity * dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    a.getSprite().render(canvas);
  }
}