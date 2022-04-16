import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'weapon.dart';

class PowerUp extends SpriteAnimationComponent {
  late final SpriteAnimation a;
  final int baseUsage = 2;
  int usagesLeft = 0;
  final BulletType bulletType = BulletType.bigBullet;

  PowerUp(): super(priority: 2) {
    usagesLeft += baseUsage;
  }

  @override
  Future<void> onLoad() async {
    final s1 = await Sprite.load('powerup1.png');
    final s2 = await Sprite.load('powerup2.png');
    a = SpriteAnimation.spriteList([s1, s2], stepTime: 1);
    size = a.getSprite().originalSize;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    a.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    a.getSprite().render(canvas);
  }
}

class HpUp extends SpriteComponent {
  final int healAmount = 10;

  HpUp(): super(priority: 2);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('hpup.png');
    size = sprite!.originalSize;
    add(RectangleHitbox());
  }
}