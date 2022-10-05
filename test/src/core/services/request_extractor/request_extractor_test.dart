import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final extrator = RequestExtractor();
  test('getAuthorizationBearer', () async {
    final request = Request(
        'GET',
        Uri.parse(
          'http://localhost.com/',
        ),
        headers: {
          'authorization': 'bearer falkjfdasiovnainvaioenfinfi',
        });
    final token = extrator.getAuthorizationBearer(request);
    expect(token, 'falkjfdasiovnainvaioenfinfi');
  });

  test('getAuthorizationBasic', () async {
    var credentialAuth = 'walex@teste.dev:123';
    credentialAuth = base64Encode(credentialAuth.codeUnits);
    final request = Request(
        'GET',
        Uri.parse(
          'http://localhost.com/',
        ),
        headers: {
          'authorization': 'basic $credentialAuth',
        });
    final credential = extrator.getAuthorizationBasic(request);
    expect(credential.email, 'walex@teste.dev');
    expect(credential.password, '123');
  });
}
