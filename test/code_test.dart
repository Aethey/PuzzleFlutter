// Import the test package and Counter class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:photopuzzle/api/photo_responsibility.dart';
import 'package:photopuzzle/model/photo_entity.dart';
import 'package:photopuzzle/utils/puzzle/puzzle_engine.dart';
import 'package:test/test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'photo/fake_photo_responsibility.dart';
import 'package:photopuzzle/api/firebase/cloud_manager.dart';

// import 'package:flutter_test/flutter_test.dart';
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  MockBuildContext _mockContext = MockBuildContext();
  setUp(() async {
    _mockContext = MockBuildContext();
  });

  group('photoList', () {
    test('photoList.len', () async {
      FakePhotoRepository fakePhotoRepository = FakePhotoRepository();
      List<PhotoEntity> photoMockList =
          await fakePhotoRepository.fetchPhotos(page: 1);
      List<PhotoEntity> photoList =
          await PhotoResponsibility().fetchPhotos(page: 1);
      expect(photoMockList.length, photoList.length);
    });
  });

  group('puzzle create', () {
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
  });
}
