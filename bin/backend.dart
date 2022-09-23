import 'dart:async';

import 'package:backend/backend.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> arguments) async {
  final handler = await startShelfModular();
  final server = await io.serve(handler, '0.0.0.0', 4466);
  print('Online. ${server.address.address}:${server.port}');
}
