import 'dart:io';
import 'package:ElectronicVision/auth/auth.dart';
import 'package:ElectronicVision/models/game.dart';
import 'package:ElectronicVision/pages/login.dart';
import 'package:ElectronicVision/pages/cart.dart';
import 'package:ElectronicVision/pages/setting.dart';
import 'package:ElectronicVision/resources/colors.dart';
import 'package:ElectronicVision/resources/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final FirebaseUser user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser user;
  List<Game> games = [];
  String gameToPutInCart;
  double sizeTitle;
  double sizeParagraph;
  Color color;

  _onAlertSucess(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Sucesso",
      desc: "Jogo adicionado ao carrinho com sucesso",
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

  _onAlertHave(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Não adicionado",
      desc: "Jogo já está no seu carrinho",
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

  void putInCart(context) async {
    final result = await Firestore.instance
        .collection('GamesUser')
        .where("game", isEqualTo: gameToPutInCart)
        .where("user", isEqualTo: user.uid)
        .limit(1)
        .getDocuments();

    if (result.documents.length == 0) {
      await Firestore.instance.collection('GamesUser').add({
        'game': gameToPutInCart,
        'user': user.uid,
      });
      _onAlertSucess(context);
    } else {
      _onAlertHave(context);
    }
    ;
  }

  void getPreferences() async {
    double fonteT = await Config.instance().getTFont();
    double fonteP = await Config.instance().getPFont();
    Color cor = await Config.instance().getColorToUse();

    setState(() {
      sizeTitle = fonteT;
      sizeParagraph = fonteP;
      color = cor;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    user = widget.user;

    Firestore.instance.collection('Games').getDocuments().then((gamesSnapshot) {
      List<Game> secondList = [];
      List<DocumentSnapshot> documentSnapshots = gamesSnapshot.documents;
      documentSnapshots.forEach((documentGameSnapshot) {
        Map<String, dynamic> document = documentGameSnapshot.data;
        Game game = Game(
            id: documentGameSnapshot.documentID,
            name: document["name"],
            genre: document["genre"],
            releaseYear: document["releaseYear"]);
        secondList.add(game);
      });
      getPreferences();

      setState(() {
        games = secondList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: "Configurações",
            icon: FaIcon(FontAwesomeIcons.wrench),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(
                            title: "Configurações",
                            user: user,
                          )));
            },
          ),
          IconButton(
            tooltip: "Deslogar da sua conta",
            icon: FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              Auth().signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
          IconButton(
            tooltip: "Sair do app",
            icon: FaIcon(FontAwesomeIcons.powerOff),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: games
                .map((game) => Card(
                      elevation: 5,
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        height: 100,
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[
                              Container(
                                width: screenSize * 0.8,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 20),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Nome do Jogo: ",
                                          style: TextStyle(
                                              fontSize: sizeParagraph,
                                              color: color,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        game.name,
                                        style: TextStyle(
                                          fontSize: sizeParagraph,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  icon: FaIcon(FontAwesomeIcons.cartPlus,
                                      size: 20, color: color),
                                  onPressed: () {
                                    setState(() {
                                      gameToPutInCart = game.id;
                                    });
                                    putInCart(context);
                                  },
                                ),
                              ),
                            ]),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 18, left: 10),
                                  child: Text(
                                    "Ano De Lançamento: ",
                                    style: TextStyle(
                                        fontSize: sizeParagraph,
                                        color: color,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 30, top: 18),
                                    child: Text(
                                      game.releaseYear.toString(),
                                      style: TextStyle(
                                        fontSize: sizeParagraph,
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Text("Gênero: ",
                                        style: TextStyle(
                                            fontSize: sizeParagraph,
                                            color: color,
                                            fontWeight: FontWeight.bold))),
                                Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Text(game.genre)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Cart(title: "Seu carrinho", user: user),
              ));
        },
        tooltip: 'Ver seu carinho',
        child: FaIcon(FontAwesomeIcons.shoppingCart),
      ),
    );
  }
}
