import 'dart:io';
import 'package:miru_alpha/miru_core/proto/generate/proto/extension.pb.dart';

void main() {
  final request = SearchRequest(
    pkg: 'uakino',
    kw: 'test',
    page: 1,
    filter: FilterSelection(
      selections: [
        MapEntry(
          'genre',
          FilterSelectionValue(values: ['action']),
        ),
      ],
    ),
  );

  final bytes = request.writeToBuffer();

  print(
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
  );
}
