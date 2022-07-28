import 'package:jwt_modular/src/auth/models/tokenization.dart';

abstract class AuthState {}

class Initialized extends AuthState {}

class Logged extends AuthState {
  final Tokenization tokenization;

  Logged(this.tokenization);
}

class UnLogged extends AuthState {}
