import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'collectible.dart';
import 'weapon.dart';
import 'main.dart';

class EnemyBullet extends SpriteComponent {
  final double _speed;
  final int damage;
  late final Vector2 _velocity;
  final double _sizeScale;

  EnemyBullet(Vector2 position, double _angle, this._speed, this.damage, this._sizeScale): super(position: position, anchor: Anchor.center, priority: 1001) {
    angle = _angle - (pi / 2);
    _velocity = Vector2(cos(angle) * _speed, sin(angle) * _speed);
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemybullet.png');
    size = sprite!.originalSize * _sizeScale;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
  @override
  void update(double dt) {
    position.add(_velocity * dt);
  }
}

abstract class BaseEnemy extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  late final double _speed;
  late int _hp;
  late Timer interval;
  late final int _scoreForKill;

  BaseEnemy(Vector2 position): super(position: position, anchor: Anchor.center, priority: 3);

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BaseBullet) {
      other.removeFromParent();
      _hp = _hp - other.damage;
    }
  }

  @override
  void update(double dt) {
    var direction = gameRef.player.position - position;
    position.add(direction.normalized() * dt * _speed);
    angle =  direction.screenAngle();
    interval.update(dt);
  }
}

class BasicEnemy extends BaseEnemy {
  BasicEnemy(Vector2 position): super(position) {
    _hp = 5;
    _speed = 180;
    _scoreForKill = 10;
    interval = Timer(
      1,
      onTick: () => shoot(),
      repeat: true,
    );
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemy.png');
    size = sprite!.originalSize;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_hp < 1) {
      removeFromParent();
      gameRef.add(PowerUp()..position = position);
      gameRef.score += _scoreForKill;
    }
  }

  void shoot() {
    if ((gameRef.player.position - position).length < 1400) {
      parent!.add(EnemyBullet(position, angle, 225, 2, 1));
    }
  }
}

class BigEnemy extends BaseEnemy {
  BigEnemy(Vector2 position): super(position) {
    _hp = 30;
    _speed = 150;
    _scoreForKill = 50;
    interval = Timer(
      5,
      onTick: () => shoot(),
      repeat: true,
    );
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemy.png');
    size = sprite!.originalSize * 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_hp < 1) {
      removeFromParent();
      gameRef.add(HpUp()..position = position);
      gameRef.score += _scoreForKill;
    }
  }

  void shoot() {
    if ((gameRef.player.position - position).length < 1000) {
      parent!.add(EnemyBullet(position, angle, 150, 5, 2));
    }
  }
}