import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:jwt_modular/src/auth/states/auth_state.dart';

import 'auth/stores/auth_store.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    final store = context.read<AuthStore>();
    store.observer(onState: (state) {
      if (state is Logged) {
        Modular.to.pushReplacementNamed('/home');
      } else if (state is UnLogged) {
        Modular.to.pushReplacementNamed('/auth/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<AuthStore>();
    final state = store.state;

    if (state is Logged) {
      Modular.setInitialRoute('/home');
    } else {
      Modular.setInitialRoute('/auth/login');
    }
    return MaterialApp.router(
      title: 'Flutter Modular Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
