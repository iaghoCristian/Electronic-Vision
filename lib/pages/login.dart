import 'package:ElectronicVision/auth/auth.dart';
import 'package:ElectronicVision/pages/home.dart';
import 'package:ElectronicVision/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void authLogin() async {
      await Auth().signIn(email.text.trim(), senha.text);
      FirebaseUser user = await Auth().getCurrentUser();
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(title: "Electronic Vision", user: user)));
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            height: 500,
            child: Column(
              children: <Widget>[
                Image.asset("img/logo.png", height: 200, width: 200),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Text("Email",
                          style: TextStyle(
                              color: Color(0xff212178),
                              fontWeight: FontWeight.bold)),
                      Container(
                        child: TextField(
                          controller: email,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Entre com seu email"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Senha",
                        style: TextStyle(
                            color: Color(0xff212178),
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: Center(
                          child: TextField(
                            controller: senha,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Entre com sua senha"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: RaisedButton(
                          color: Color(0xff212178),
                          onPressed: () {
                            authLogin();
                          },
                          child: Text("Entrar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: InkWell(
                          child: Text("Criar um novo cadastro",
                              style: TextStyle(
                                  color: Color(0xff212178),
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
