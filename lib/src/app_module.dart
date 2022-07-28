import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_modular/src/auth/interceptors/interceptors.dart';
import 'package:jwt_modular/src/auth/login_page.dart';
import 'package:jwt_modular/src/auth/stores/auth_store.dart';
import 'package:jwt_modular/src/home/home_page.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';
import 'package:uno/uno.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton((i) {
          final uno = Uno(baseURL: 'http://146.190.226.218:4466');
          uno.interceptors.request.use(addToken);
          uno.interceptors.response
              .use((response) => response, onError: tryRefreshToken);
          return uno;
        }),
        TripleBind.singleton((i) => AuthStore(i()))
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/auth/login', child: (_, __) => const LoginPage()),
        ChildRoute('/home', child: (_, __) => const HomePage()),
      ];
}
