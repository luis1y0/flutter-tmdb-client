import 'package:flutter/material.dart';
import 'package:kueski_app/ui/blocs/pages_bloc.dart';
import 'package:kueski_app/ui/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KueskiApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          Provider<PagesBloc>(create: (_) => PagesBloc()),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
