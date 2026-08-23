// Copyright 2024 The Miru Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';
import 'package:miru_alpha/miru_core/proto/proto.dart' as proto;

void main() {
  group('FilterSelection protobuf tests', () {
    test('unfiltered SearchRequest has no filter set', () {
      final request = proto.SearchRequest(
        pkg: 'test_pkg',
        kw: 'test',
        page: 1,
      );

      expect(request.hasFilter(), isFalse);
      expect(request.filter, isNull);
    });

    test('SearchRequest with one filter selection', () {
      final filter = proto.FilterSelection();
      filter.selections['genre'] = proto.FilterSelectionValue(values: ['action']);

      final request = proto.SearchRequest(
        pkg: 'test_pkg',
        kw: 'test',
        page: 1,
        filter: filter,
      );

      expect(request.hasFilter(), isTrue);
      expect(request.filter.selections.containsKey('genre'), isTrue);
      expect(request.filter.selections['genre']!.values, ['action']);
    });

    test('SearchRequest with multiple filter selections', () {
      final filter = proto.FilterSelection();
      filter.selections['genre'] = proto.FilterSelectionValue(values: ['action', 'shounen']);
      filter.selections['year'] = proto.FilterSelectionValue(values: ['2024']);

      final request = proto.SearchRequest(
        pkg: 'test_pkg',
        kw: 'test',
        page: 1,
        filter: filter,
      );

      expect(request.hasFilter(), isTrue);
      expect(request.filter.selections.length, 2);
      expect(request.filter.selections['genre']!.values, ['action', 'shounen']);
      expect(request.filter.selections['year']!.values, ['2024']);
    });

    test('CreateFilterRequest with empty filter', () {
      final request = proto.CreateFilterRequest(
        pkg: 'test_pkg',
        filter: proto.FilterSelection(),
      );

      expect(request.hasFilter(), isTrue);
      expect(request.filter.selections.isEmpty, isTrue);
    });

    test('CreateFilterRequest with filter selection', () {
      final filter = proto.FilterSelection();
      filter.selections['genre'] = proto.FilterSelectionValue(values: ['action']);

      final request = proto.CreateFilterRequest(
        pkg: 'test_pkg',
        filter: filter,
      );

      expect(request.hasFilter(), isTrue);
      expect(request.filter.selections.containsKey('genre'), isTrue);
      expect(request.filter.selections['genre']!.values, ['action']);
    });

    test('protobuf round-trip for FilterSelection', () {
      final original = proto.FilterSelection();
      original.selections['genre'] = proto.FilterSelectionValue(values: ['action', 'shounen']);
      original.selections['year'] = proto.FilterSelectionValue(values: ['2024']);
      original.selections['status'] = proto.FilterSelectionValue(values: ['ongoing']);

      // Serialize to bytes
      final bytes = original.writeToBuffer();

      // Deserialize from bytes
      final decoded = proto.FilterSelection.fromBuffer(bytes);

      expect(decoded.selections.length, 3);
      expect(decoded.selections['genre']!.values, ['action', 'shounen']);
      expect(decoded.selections['year']!.values, ['2024']);
      expect(decoded.selections['status']!.values, ['ongoing']);
    });

    test('protobuf round-trip for SearchRequest with FilterSelection', () {
      final filter = proto.FilterSelection();
      filter.selections['genre'] = proto.FilterSelectionValue(values: ['action']);

      final original = proto.SearchRequest(
        pkg: 'test_pkg',
        kw: 'test keyword',
        page: 2,
        filter: filter,
      );

      // Serialize to bytes
      final bytes = original.writeToBuffer();

      // Deserialize from bytes
      final decoded = proto.SearchRequest.fromBuffer(bytes);

      expect(decoded.pkg, 'test_pkg');
      expect(decoded.kw, 'test keyword');
      expect(decoded.page, 2);
      expect(decoded.hasFilter(), isTrue);
      expect(decoded.filter.selections['genre']!.values, ['action']);
    });

    test('protobuf round-trip for CreateFilterRequest with FilterSelection', () {
      final filter = proto.FilterSelection();
      filter.selections['genre'] = proto.FilterSelectionValue(values: ['action', 'shounen']);

      final original = proto.CreateFilterRequest(
        pkg: 'test_pkg',
        filter: filter,
      );

      // Serialize to bytes
      final bytes = original.writeToBuffer();

      // Deserialize from bytes
      final decoded = proto.CreateFilterRequest.fromBuffer(bytes);

      expect(decoded.pkg, 'test_pkg');
      expect(decoded.hasFilter(), isTrue);
      expect(decoded.filter.selections['genre']!.values, ['action', 'shounen']);
    });

    test('FilterSelectionValue with empty values list', () {
      final value = proto.FilterSelectionValue(values: []);
      expect(value.values.isEmpty, isTrue);
    });

    test('FilterSelectionValue round-trip', () {
      final original = proto.FilterSelectionValue(values: ['action', 'adventure']);

      final bytes = original.writeToBuffer();
      final decoded = proto.FilterSelectionValue.fromBuffer(bytes);

      expect(decoded.values, ['action', 'adventure']);
    });

    test('empty FilterSelection round-trip', () {
      final original = proto.FilterSelection();

      final bytes = original.writeToBuffer();
      final decoded = proto.FilterSelection.fromBuffer(bytes);

      expect(decoded.selections.isEmpty, isTrue);
    });
  });
}