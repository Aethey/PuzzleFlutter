// Import the test package and Counter class
import 'package:photopuzzle/utils/puzzle/puzzle_engine.dart';
import 'package:test/test.dart';

void main() {
  test('test for create puzzle1 ', () {
    var result = PuzzleEngine.readyReversePairs([6, 4, 8, 5, 3, 7, 1, 2, 9]);
    print('result$result');
    expect(result.isEven, true);
  });

  test('test for create puzzle2 ', () {
    var result = PuzzleEngine.readyReversePairs([7, 6, 4, 2, 5, 8, 3, 1, 9]);
    print('result$result');
    expect(result.isEven, true);
  });

  test('test for create puzzle3 ', () {
    var result = PuzzleEngine.readyReversePairs([2, 4, 3, 1, 5, 6, 7, 8, 9]);
    print('result$result');
    expect(result.isEven, true);
  });

  test('test for create puzzle4 ', () {
    var result = PuzzleEngine.readyReversePairs([8, 3, 6, 7, 4, 5, 2, 1, 9]);
    print('result$result');
    expect(result.isEven, true);
  });

  test('test for create puzzle5 ', () {
    var result = PuzzleEngine.readyReversePairs([5, 4, 6, 1, 3, 7, 2, 8, 9]);
    print('result$result');
    expect(result.isEven, true);
  });

  test('test for create puzzle6 ', () {
    var result = PuzzleEngine.readyReversePairs([4, 7, 5, 6, 3, 2, 8, 1]);
    print('result$result');
    expect(result.isEven, true);
  });
}
