import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum BulletType {
  bullet,
  bigBullet
}

abstract class BaseBullet extends SpriteComponent {
  late final int damage;
  late final Vector2 velocity;

  BaseBullet(Vector2 position): super(position: position, anchor: Anchor.center, priority: 1001);

  @override
  void update(double dt) {
    position.add(velocity * dt);
  }
}

class Bullet extends BaseBullet {
  final double _speed = 500;

  Bullet(Vector2 position, double _angle): super(position) {
    damage = 1;
    angle = _angle - (pi / 2);
    velocity = Vector2(cos(angle) * _speed, sin(angle) * _speed);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bullet.png');
    size = sprite!.originalSize;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}

class BigBullet extends BaseBullet {
  final double _speed = 100;

  BigBullet(Vector2 position, double _angle): super(position) {
    damage = 25;
    angle = _angle - (pi / 2);
    velocity = Vector2(cos(angle) * _speed, sin(angle) * _speed);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bullet.png');
    size = sprite!.originalSize * 3;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}