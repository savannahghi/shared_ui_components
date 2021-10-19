import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

class MockHttpClient implements Client {
  @override
  void close() {}

  @override
  Future<Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      Future<Response>.value(Response('body', 200));

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      Future<Response>.value(Response('body', 200));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      Future<Response>.value(Response('body', 200));

  @override
  Future<Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      Future<Response>.value(Response('body', 200));

  @override
  Future<Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      Future<Response>.value(
          Response(json.encode(<String, String>{'otp': '123456'}), 200));

  @override
  Future<Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      Future<Response>.value(Response('body', 200));

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      Future<String>.value('test');

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) =>
      Future<Uint8List>.value(Uint8List.fromList(<int>[1, 2, 3]));

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      // ignore: null_argument_to_non_null_type
      Future<StreamedResponse>.value();
}
