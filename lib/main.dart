import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Home.dart';
import 'Details.dart';
import 'Cart.dart';
import 'Forms.dart';
import 'ScopeManage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  static final AppModel appModel = AppModel();

  final routes = <String, WidgetBuilder>{
    Home.route: (BuildContext context) => Home(),
    Details.route: (BuildContext context) => Details(),
    Cart.route: (BuildContext context) => Cart(),
    Forms.route: (BuildContext context) => Forms()
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<AppModel>(
      model: appModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(title: 'Malioboro Mall Supermarket'),
        routes: routes,
        theme: ThemeData(primaryColor: Colors.white, fontFamily: 'OpenSans'),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(
                  appModel: Main.appModel,
                )));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(color: Colors.white),
      child: new Container(
        margin: new EdgeInsets.all(30.0),
        width: 350.0,
        height: 350.0,
        child: new Image.asset(
          'assets/logo.png',
        ),
      ),
    );
  }
}
