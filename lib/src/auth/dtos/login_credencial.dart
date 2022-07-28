import 'package:string_validator/string_validator.dart' as validator;

class LoginCredencial {
  Email _email = Email('');
  setEmail(String email) => _email = Email(email);
  String get email => _email.value;

  Password _password = Password('');
  setPassword(String password) => _password = Password(password);
  String get password => _password.value;

  String? validateEmail() => _email.validate();
  String? validatePassword() => _password.validate();
}

class Email {
  final String value;
  Email(this.value);
  String? validate() {
    if (value.isEmpty) {
      return 'Email não pode ser vazio';
    }
    if (!validator.isEmail(value)) {
      return "Email inválido";
    }
    return null;
  }
}

class Password {
  final String value;
  Password(this.value);
  String? validate() {
    if (value.isEmpty) {
      return 'Senha não pode ser vazio';
    }
    if (value.length < 3) {
      return "Senha deve ter no mínimo 3 caracteres";
    }
    return null;
  }
}
