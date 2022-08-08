import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uno/uno.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () async {
                final uno = Modular.get<Uno>();
                final response = await uno.get('/user');
                print(response.data);
              },
              child: Column(
                children: [
                  Text("getUsers"),
                  CheckboxListTile(
                    title: const Text('Animate Slowly'),
                    onChanged: (bool? value) {},
                    secondary: const Icon(Icons.hourglass_empty),
                    value: false,
                  )
                ],
              ))
        ]),
      ),
    );
  }
}
