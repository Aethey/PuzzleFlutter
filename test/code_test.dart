// Import the test package and Counter class
import 'package:photopuzzle/utils/game/game_engine.dart';
import 'package:test/test.dart';

void main() {
  test('let us test', () {

    var result = GameEngine.readyReversePairs([7,5,6,4]);
    print('result$result');
    expect(result,5);

  });
}
