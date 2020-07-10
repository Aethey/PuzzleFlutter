import 'package:photopuzzle/database/puzzle_mock_model.dart';

abstract class PuzzleMockDao {
  Future<List<PuzzleMockModel>> findAllPuzzleMockModel();

  Future<PuzzleMockModel> findPuzzleMockModel(String id);

  Future<void> insertPuzzleMockModel(PuzzleMockModel model);
}
