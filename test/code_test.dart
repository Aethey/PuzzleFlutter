// Import the test package and Counter class
import 'package:photopuzzle/game/game_engine.dart';
import 'package:test/test.dart';

void main() {
  test('let us test', () {

    int result = GameEngine.readyReversePairs([7,5,6,4]);
    print('result$result');
    expect(result,5);

  });
}
