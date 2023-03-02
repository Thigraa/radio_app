import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/src/providers/radio_provider.dart';
import 'package:radio_app/src/screens/home_screen.dart';
import 'package:radio_player/radio_player.dart';

import 'src/screens/radio_player_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RadioProvider(),
          lazy: false,
        )
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPlaying = false;
  List<String>? metadata;
  late RadioProvider provider;
  final RadioPlayer _radioPlayer = RadioPlayer();

  @override
  void initState() {
    provider = Provider.of<RadioProvider>(context, listen: false);
    super.initState();
    initRadioPlayer();
    provider.radioPlayer = _radioPlayer;
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: provider.selectedStation.radioName,
      url: provider.selectedStation.radioUrl,
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
        provider.isPlaying = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RadioApp',
      initialRoute: 'home',
      routes: {
        'home': (context) => HomeScreen(),
        'player': (context) => RadioPlayerScreen(),
      },
    );
  }
}
