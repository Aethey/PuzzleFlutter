import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$FirebaseFirestore', () {
    final firestore = MockFirestoreInstance();
    setUp(() async {
      await firestore.collection('puzzles').add({
        'images': {
          'user001': {
            'puzzles': {
              '0123': {
                'imageUrl': 'url',
              },
              '0124': {
                'imageUrl': 'url',
              },
              '0125': {
                'imageUrl': 'url',
              },
              '0126': {
                'imageUrl': 'url',
              }
            }
          },
          'user002': {
            'puzzles': {
              '0123': {
                'imageUrl': 'url',
              },
              '0124': {
                'imageUrl': 'url',
              },
              '0125': {
                'imageUrl': 'url',
              },
              '0126': {
                'imageUrl': 'url',
              }
            }
          }
        }
      });
    });

    test('puzzleList', () async {
      final snapshot = await firestore
          .collection('puzzles')
          .doc('images')
          .collection('puzzles')
          .get();
      int len = snapshot.size;
    });

    testWidgets('puzzle list', (tester) async {});
  });
}
