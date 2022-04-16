import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'collectible.dart';
import 'hostage.dart';
import 'world.dart';
import 'enemy.dart';
import 'main.dart';
import 'weapon.dart';

class Player extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  final JoystickComponent joystick;
  double maxSpeed = 4.0;
  PowerUp? powerup;
  int hp = 100;

  Player(this.joystick) : super(size: Vector2.all(40.0), priority: 3) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    position = gameRef.size / 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick.direction != JoystickDirection.idle) {
      position.add(joystick.delta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
    if (hp < 1) {
      removeFromParent();
      gameRef.dead = true;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is World) {
      if (position.x < 0) {
        position.x = 0;
      }
      if (position.y < 0) {
        position.y = 0;
      }
      if (position.x > gameRef.world.size.x) {
        position.x = gameRef.world.size.x;
      }
      if (position.y > gameRef.world.size.y) {
        position.y = gameRef.world.size.y;
      }
    } else if (other is PowerUp) {
      other.removeFromParent();
      if (powerup != null) {
        powerup!.usagesLeft += powerup!.baseUsage;
      } else {
        powerup = PowerUp();
      }
    } else if (other is HpUp) {
      hp += other.healAmount;
      other.removeFromParent();
    } else if (other is EnemyBullet) {
      hp -= other.damage;
      other.removeFromParent();
    } else if (other is Hostage) {
      gameRef.score += other.scoreForRescue;
      other.removeFromParent();
    }
  }

  void shoot() {
    var type = powerup?.bulletType ?? BulletType.bullet;
    if (type != BulletType.bullet) {
      powerup!.usagesLeft--;
      if (powerup!.usagesLeft < 1) {
        powerup = null;
      }
      if (type == BulletType.bigBullet) {
        parent?.add(BigBullet(position, angle));
        return;
      }
    }
    parent?.add(Bullet(position, angle));
  }
}