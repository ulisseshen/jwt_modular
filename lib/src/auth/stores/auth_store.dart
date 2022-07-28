import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:jwt_modular/src/auth/dtos/login_credencial.dart';
import 'package:jwt_modular/src/auth/errors/errors.dart';
import 'package:jwt_modular/src/auth/models/tokenization.dart';
import 'package:jwt_modular/src/auth/states/auth_state.dart';
import 'package:uno/uno.dart';

abstract class Auth {
  Future<void> login(LoginCredencial credencial);
  void logout();
  Future<void> refreshToken();
}

class AuthStore extends StreamStore<AuthException, AuthState> implements Auth {
  final Uno uno;
  AuthStore(this.uno) : super(Initialized());

  @override
  Future<void> login(LoginCredencial credencial) async {
    setLoading(true);
    var basic = '${credencial.email}:${credencial.password}'.toBase64();

    try {
      final response = await uno.get('/auth/login', headers: {
        'Authorization': 'Basic $basic',
      });

      final tokenization = Tokenization.fromMap(response.data);

      update(Logged(tokenization));
    } on UnoError catch (e, s) {
      setError(AuthException(e.response?.data["error"], s));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> refreshToken() async {
    final state = this.state;
    if (state is Logged) {
      final refreshToken = state.tokenization.refreshToken;

      final response = await uno.get('/auth/refresh_token', headers: {
        'refresh-token': '',
        'Authorization': 'Bearer $refreshToken',
      });

      final tokenization = Tokenization.fromMap(response.data);
      update(Logged(tokenization));
    }
  }

  @override
  void logout() {
    update(UnLogged());
  }
}

extension Encode on String {
  toBase64() => base64Encode(codeUnits);
}
