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
          FilterSelectionValue(
            values: ['action'],
          ),
        ),
      ],
    ),
  );

  final bytes = request.writeToBuffer();

  stdout.writeln(
    'HEX=${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
  );
  stdout.writeln('LENGTH=${bytes.length}');

  File(r'C:\src\miru-dev\dart-search-request.bin')
      .writeAsBytesSync(bytes);

  final unfiltered = SearchRequest(
    pkg: 'uakino',
    kw: 'test',
    page: 1,
  );

  final unfilteredBytes = unfiltered.writeToBuffer();

  stdout.writeln(
    'UNFILTERED_HEX=${unfilteredBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
  );

  File(r'C:\src\miru-dev\dart-search-request-unfiltered.bin')
      .writeAsBytesSync(unfilteredBytes);

  final createFilter = CreateFilterRequest(
    pkg: 'uakino',
    filter: FilterSelection(
      selections: [
        MapEntry(
          'genre',
          FilterSelectionValue(
            values: ['action'],
          ),
        ),
      ],
    ),
  );

  final createBytes = createFilter.writeToBuffer();

  stdout.writeln(
    'CREATE_FILTER_HEX=${createBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
  );

  File(r'C:\src\miru-dev\dart-create-filter.bin')
      .writeAsBytesSync(createBytes);
}