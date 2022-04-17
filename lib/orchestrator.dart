import 'dart:math';
import 'package:flame/components.dart';
import 'enemy.dart';
import 'hostage.dart';
import 'main.dart';

class Orchestrator extends Component with HasGameRef<MyGame> {
  late final Timer smallInterval;
  late final Timer bigInterval;
  late final Timer hostageInterval;
  final int maxBasic = 10;
  final int maxBig = 6;
  final int maxHostage = 15;

  Random random = Random();

  Orchestrator() {
    smallInterval = Timer(
      5,
      onTick: () => spawnBasic(),
      repeat: true,
    );
    bigInterval = Timer(
      10,
      onTick: () => spawnBig(),
      repeat: true,
    );
    hostageInterval = Timer(
      10,
      onTick: () => spawnHostage(),
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    smallInterval.update(dt);
    bigInterval.update(dt);
    hostageInterval.update(dt);
  }

  void spawnBasic() {
    if (random.nextBool() && parent!.children.whereType<BasicEnemy>().length <= maxBasic) {
      parent!.add(BasicEnemy(Vector2.random()..multiply(gameRef.world.size))..changePriorityWithoutResorting(3));
    }
  }

  void spawnBig() {
    if (random.nextBool() && parent!.children.whereType<BigEnemy>().length <= maxBig) {
      parent!.add(BigEnemy(Vector2.random()..multiply(gameRef.world.size))..changePriorityWithoutResorting(3));
    }
  }

  void spawnHostage() {
    if (parent!.children.whereType<Hostage>().length <= maxHostage) {
      parent!.add(Hostage()..position = (Vector2.random()..multiply(gameRef.world.size))..changePriorityWithoutResorting(3));
    }
  }
}