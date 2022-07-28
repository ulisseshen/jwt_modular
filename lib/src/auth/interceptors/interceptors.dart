import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_modular/src/auth/states/auth_state.dart';
import 'package:jwt_modular/src/auth/stores/auth_store.dart';
import 'package:uno/uno.dart';

FutureOr<Request> addToken(Request request) {
  final store = Modular.get<AuthStore>();
  final state = store.state;
  final isRequestRefreshToken =
      request.headers.containsKey("refresh-token") == true;
  if (state is Logged && !isRequestRefreshToken) {
    final accessToken = state.tokenization.accessToken;
    request.headers['Authorization'] = 'Bearer $accessToken';
  }
  return request;
}

FutureOr tryRefreshToken(UnoError error) async {
  if (error.response?.status != 403) {
    return error;
  }

  final store = Modular.get<AuthStore>();
  final state = store.state;
  final isRequestRefreshToken =
      error.response?.headers.containsKey("refresh-token") == true;
  if (state is Logged && !isRequestRefreshToken) {
    try {
      await store.refreshToken();
      final uno = Modular.get<Uno>();
      final response = uno.request(error.request!);
      return response;
    } on UnoError catch (e) {
      if (e.response?.status == 403) {
        store.logout();
      }
      return error;
    }
  }
}
