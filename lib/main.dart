import 'package:flutter/material.dart';
import 'package:flutter_teste/models/QuestionModel.dart';
import 'package:flutter_teste/pages/Home/home_page.dart';
import 'package:flutter_teste/pages/Login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz IoT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.blue,
        backgroundColor: Colors.blue[400],
      ),
      home: ChangeNotifierProvider(
        create: (cntx) => QuestionModel(),
        child: MyHomePage(title: 'Educa IoT'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoged = false;

  @override
  void initState() {
    super.initState();
    _prefs.then((prefs) {
      setState(() => isLoged = prefs.getBool('EducaIoT:isLoged') ?? false);
    });
  }

  _exitFn() async {
    final prefs = await _prefs;
    prefs.clear();
    setState(() => isLoged = false);
  }

  _loginFn(String email, String password) async {
    final prefs = await _prefs;
    final storagedEmail = prefs.getString('EducaIot:email');
    final storagedPassword = prefs.getString('EducaIot:password');
    print('email: $email ($storagedEmail) pass: $password ($storagedPassword)');
    if (storagedPassword != null && storagedEmail != null) {
      if (storagedEmail == email && storagedPassword == password) {
        setState(() => isLoged = true);
        prefs.setBool('EducaIot:isLoged', true);
      }
    } else {
      prefs.setString('EducaIot:email', email);
      prefs.setString('EducaIot:password', password);
      _loginFn(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoged ? Home(exitFn: _exitFn) : Login(loginFn: _loginFn),
    );
  }
}
