import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gerenciador de Contas',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: new LoginPage(),

    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is logging in or creating an account
enum FormType {
  login,
  register
}

String _belowButtons = "";
String _currentState = "Fazer Login";

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();


  FormType _form = FormType.login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  // Swap in between our two forms, registering and logging in
  void _formChange () async {
    setState(() {
      _belowButtons = "";
      if (_form == FormType.register) {
        _form = FormType.login;
        _currentState = "Fazer Login";
      } else {
        _form = FormType.register;
        _currentState = "Registrar um usuário";
      }
    });
  }

  void _refreshText() async {

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Gerenciador de Contas"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new RichText(
              text: TextSpan(
                  text: '$_currentState'
              ),
            )
          ),
          new Container(
            child: new TextField(
              controller: _usernameFilter,
              decoration: new InputDecoration(
                  labelText: 'Usuário'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  labelText: 'Senha'
              ),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        margin: const EdgeInsets.only(top: 18.0), //margem de 18 pixels em cima
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
              //style: ButtonStyle(
              //  backgroundColor: Colors.tealAccent,
              //),
            ),
            new ElevatedButton(
              child: new Text('Clique aqui para se registrar.'),
              onPressed: _formChange,
              //style: ButtonStyle(
              //  backgroundColor: Colors.tealAccent,
              //),
            ),
            RichText(
              text: TextSpan(
                  text: '$_belowButtons'
              ),
            )
          ],
        ),
      );
    } else {
      return new Container(
        margin: const EdgeInsets.only(top: 18.0), //margem de 18 pixels em cima
        child: new Column(
          children: <Widget>[
            new ElevatedButton(
              child: new Text('Criar uma conta'),
              onPressed: _createAccountPressed,
            ),
            new ElevatedButton(
              child: new Text('Já tem uma conta? Clique aqui para fazer login.'),
              onPressed: _formChange,
            ),
            RichText(
              text: TextSpan(
                text: '$_belowButtons'
              ),
            )
          ],
        ),
      );
    }
  }


  void _loginPressed () async {
    final prefs = await SharedPreferences.getInstance();

    String username = "";
    String password = "";
    if (!_usernameFilter.text.isEmpty) {
      username = _usernameFilter.text;
    }
    if (!_passwordFilter.text.isEmpty) {
      password = _passwordFilter.text;
    }

    String trueUsername = prefs.getString("username");
    String truePassword = prefs.getString("password");

    if (trueUsername == username && truePassword == password){
      print("RIGHT");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home(),
        ),
      );
    }else
      setState(() {
        _belowButtons = ("Usuário ou senha errados.");
        print("ERRADO");
      });


    print ("registered user: " + trueUsername);
    print ("registered pass: " + trueUsername);



  }

  void _createAccountPressed () async {
    final prefs = await SharedPreferences.getInstance();

    String username = "";
    String password = "";
    if (!_usernameFilter.text.isEmpty) {
      username = _usernameFilter.text;
    }
    if (!_passwordFilter.text.isEmpty) {
      password = _passwordFilter.text;
    }

    _usernameFilter.clear();
    _passwordFilter.clear();

    prefs.setString("username", username);
    prefs.setString("password", password);

    setState(() {
      _belowButtons = ("Conta criada com sucesso!");
    });

    print("conta registrada");

  }

}