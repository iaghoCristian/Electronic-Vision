import 'package:ElectronicVision/auth/auth.dart';
import 'package:ElectronicVision/pages/home.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:ElectronicVision/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final senha2 = TextEditingController();

  _onAlertSucess(context, user) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Sucesso",
      desc: "Cadastro criado com sucesso",
      buttons: [
        DialogButton(
          color: Color(0xff212178),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: "Electronic Vision", user: user))),
          width: 120,
        )
      ],
    ).show();
  }

  _onAlertError(context, String texto) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Erro",
      desc: texto,
      buttons: [
        DialogButton(
          color: Color(0xff212178),
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void register(context) async {
    if (nome.text.trim().length < 5) {
      _onAlertError(context, "Nome deve ter ao menos 5 caracteres");
    }

    if (!EmailValidator.validate(email.text.trim())) {
      _onAlertError(context, "Deve ser um email válido");
    }

    if (senha.text != senha2.text) {
      _onAlertError(context, "As senhas devem ser iguais");
    }

    if (senha.text == senha2.text &&
        EmailValidator.validate(email.text.trim()) &&
        nome.text.trim().length >= 5) {
      String idUser = await Auth().signUp(email.text.trim(), senha.text);

      await Firestore.instance.collection('User').document(idUser).setData({
        'name': nome.text.toString(),
      });

      FirebaseUser user = await Auth().getCurrentUser();

      _onAlertSucess(context, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 50),
            height: 700,
            child: Column(
              children: <Widget>[
                Text("Criar novo Usuário",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff212178),
                      fontWeight: FontWeight.bold,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Text("Nome",
                      style: TextStyle(
                          color: Color(0xff212178),
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    child: TextField(
                  controller: nome,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Entre com seu nome"),
                  textAlign: TextAlign.center,
                )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Email",
                      style: TextStyle(
                          color: Color(0xff212178),
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Entre com seu email"),
                  textAlign: TextAlign.center,
                )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Senha",
                      style: TextStyle(
                          color: Color(0xff212178),
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    child: TextField(
                  obscureText: true,
                  controller: senha,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Entre com sua senha"),
                  textAlign: TextAlign.center,
                )),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("Repita a senha",
                      style: TextStyle(
                          color: Color(0xff212178),
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    child: TextField(
                  obscureText: true,
                  controller: senha2,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Entre com sua senha novamente"),
                  textAlign: TextAlign.center,
                )),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  width: 200,
                  child: RaisedButton(
                    color: Color(0xff212178),
                    onPressed: () {
                      register(context);
                    },
                    child: Text("Criar",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
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
