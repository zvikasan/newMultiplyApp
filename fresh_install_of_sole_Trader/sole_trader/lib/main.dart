import 'package:flutter/material.dart';
import 'package:sole_trader/screens/clients_list_screen.dart';
import 'package:sole_trader/screens/introduction_screen.dart';
import 'theme/theme_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sole_trader/models/data_provider.dart';
import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: LightTheme.cDarkBlue, // navigation bar color
    statusBarColor: LightTheme.cDarkYellow, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        title: 'soleTrader',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          unselectedWidgetColor: LightTheme.cBrownishGrey,
          backgroundColor: LightTheme.cLightYellow,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: Theme.of(context).textTheme.apply(
              bodyColor: LightTheme.cDarkBlue,
              displayColor: LightTheme.cDarkBlue,
              fontFamily: 'Poppins'),
        ),
        //home: ClientsListScreen(),
        home: Splash(),
        // home: IntroScreen(),
      ),
    );
  }
}

// the following implements showing intro screen only the first time user launches the app
class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            // return ClientsListScreen();
            return ClientsListScreen();
          },
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn, parent: animation);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return IntroScreen();
          },
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn, parent: animation);
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: LightTheme.cLightYellow,
    );
  }
}

//TODO lock orientation where needed
//TODO find out what todo with debugShowCheckedModeBanner when done developing
