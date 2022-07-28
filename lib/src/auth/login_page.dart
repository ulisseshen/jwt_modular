import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_modular/src/auth/dtos/login_credencial.dart';
import 'package:jwt_modular/src/auth/stores/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final credencial = LoginCredencial();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final store = context.read<AuthStore>();
    store.observer(onError: ((error) {
      final snack = SnackBar(
        content: Text(error.message),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final passwordIcon = _obscureText ? Icons.visibility : Icons.visibility_off;

    final store = context.watch<AuthStore>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl:
                        "https://ies.solutions/wordpress/wp-content/uploads/jwt.png",
                    height: 150,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: credencial.setEmail,
                    validator: (_) => credencial.validateEmail(),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: credencial.setPassword,
                    validator: (_) => credencial.validatePassword(),
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(passwordIcon),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  // não functionou o ScopedBuilder
                  if (store.isLoading) LinearProgressIndicator(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          store.login(credencial);
                        }
                      },
                      child: const Text("Entrar"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
