import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:jamofgames/hostage.dart';
import 'enemy.dart';
import 'weapon.dart';
import 'main.dart';

class World extends SpriteComponent with HasGameRef<MyGame>, CollisionCallbacks {
  World(): super(priority: 1);

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('worldmap.png');
    size = sprite!.originalSize;
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BaseBullet) {
      other.removeFromParent();
    } else if (other is EnemyBullet) {
      other.removeFromParent();
    } else if (other is Hostage) {
      var pos = other.position;
      if (pos.x < 1 || pos.x > gameRef.world.size.x) {
        other.velocity.x *= -1;
      }
      if (pos.y < 1 || pos.y > gameRef.world.size.y) {
        other.velocity.y *= -1;
      }
    }
  }
}