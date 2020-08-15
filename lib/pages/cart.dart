import 'dart:io';
import 'package:ElectronicVision/auth/auth.dart';
import 'package:ElectronicVision/models/game.dart';
import 'package:ElectronicVision/pages/login.dart';
import 'package:ElectronicVision/resources/colors.dart';
import 'package:ElectronicVision/resources/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final FirebaseUser user;

  @override
  _Cart createState() => _Cart();
}

class _Cart extends State<Cart> {
  FirebaseUser user;
  List<Game> games = [];
  String gameToDelete;
  double sizeTitle;
  double sizeParagraph;
  Color color;

  Future<Game> getGame(id) async {
    final documentGameSnapshot =
        await Firestore.instance.collection("Games").document(id).get();
    final documentGame = documentGameSnapshot.data;

    Game game = Game(
      genre: documentGame['genre'],
      name: documentGame['name'],
      releaseYear: documentGame['releaseYear'],
      id: documentGameSnapshot.documentID,
    );

    return game;
  }

  void deleteGameUser() async {
    String idGame;
    Firestore.instance
        .collection('GamesUser')
        .getDocuments()
        .then((gamesUserSnapshot) async {
      List<DocumentSnapshot> documentGamesUserSnapshot =
          gamesUserSnapshot.documents;
      documentGamesUserSnapshot.forEach((element) {
        Map<String, dynamic> document = element.data;
        if (document['user'] == user.uid && document['game'] == gameToDelete) {
          idGame = element.documentID;
        }
      });

      Firestore.instance.collection('GamesUser').document(idGame).delete();

      getGameUsers();
    });
  }

  void getGameUsers() async {
    Firestore.instance
        .collection('GamesUser')
        .getDocuments()
        .then((gamesUserSnapshot) async {
      List<Game> secondList = [];
      List<DocumentSnapshot> documentGameUserSnapshots =
          gamesUserSnapshot.documents;
      for (final documentSnapshot in documentGameUserSnapshots) {
        if (documentSnapshot['user'] == user.uid) {
          Game game = await getGame(documentSnapshot['game']);
          secondList.add(game);
        }
      }
      setState(() {
        games = secondList;
      });
    });
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
    getPreferences();
    getGameUsers();
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                                          margin: EdgeInsets.only(
                                              left: 10, top: 20),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Nome do Jogo: ",
                                            style: TextStyle(
                                                color: color,
                                                fontSize: sizeParagraph,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(game.name,
                                            style: TextStyle(
                                                fontSize: sizeParagraph)),
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  icon: FaIcon(FontAwesomeIcons.trash,
                                      size: 20, color: color),
                                  onPressed: () {
                                    gameToDelete = game.id;
                                    deleteGameUser();
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
                                        color: color,
                                        fontSize: sizeParagraph,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 30, top: 18),
                                    child: Text(game.releaseYear.toString(),
                                        style: TextStyle(
                                            fontSize: sizeParagraph))),
                                Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Text("Gênero: ",
                                        style: TextStyle(
                                            color: color,
                                            fontSize: sizeParagraph,
                                            fontWeight: FontWeight.bold))),
                                Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Text(
                                      game.genre,
                                      style: TextStyle(fontSize: sizeParagraph),
                                    )),
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
    );
  }
}
