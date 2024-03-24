import 'package:appdev/pages/main_menu.dart';
import 'package:appdev/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return ChangeNotifierProvider(
      create: (_) => UserState(), // Create an instance of UserState
      child: MaterialApp(
        title: 'Math and Match',
        home: Menu(),
        debugShowCheckedModeBanner:
            false, // Your Menu widget as the home screen
      ),
    );
  }
}

class UserState extends ChangeNotifier {
  String? _loggedInUser;

  String? get loggedInUser => _loggedInUser;

  void setLoggedInUser(String? user) {
    _loggedInUser = user;
    notifyListeners();
  }
}
