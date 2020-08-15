import 'package:ElectronicVision/pages/home.dart';
import 'package:ElectronicVision/resources/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final FirebaseUser user;

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  FirebaseUser user;
  String dropdownValueFont = "Normal";
  String dropdownValueColor = "Azul";
  double sizeTitle;
  double sizeParagraph;
  Color color;

  @override
  void initState() {
    super.initState();
    user = widget.user;

    getSettings();
    getPreferences();
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

  void getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    dropdownValueFont = prefs.getString('font');
    dropdownValueColor = prefs.getString('color');
  }

  void changeSettings() async {
    (await SharedPreferences.getInstance())
        .setString('font', dropdownValueFont);
    (await SharedPreferences.getInstance())
        .setString('color', dropdownValueColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Essas são as suas configurações",
                style:
                    TextStyle(fontSize: sizeTitle, fontWeight: FontWeight.bold),
              )),
          Container(
            margin: EdgeInsets.only(top: 50, left: 20),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Tamanho da fonte",
                    style: TextStyle(
                        fontSize: sizeParagraph,
                        color: color,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 100),
                  child: DropdownButton(
                    value: dropdownValueFont,
                    hint: Text('$dropdownValueFont'),
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    items: <String>['Normal', 'Aumentada']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValueFont = newValue;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30, left: 20),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text(
                    "Cor",
                    style: TextStyle(
                        fontSize: sizeParagraph,
                        color: color,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 205),
                  child: DropdownButton(
                    value: dropdownValueColor,
                    hint: Text('$dropdownValueColor'),
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    items: <String>['Azul', 'Vermelho']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValueColor = newValue;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, left: 60),
                child: RaisedButton(
                  color: color,
                  child: Text(
                    "Voltar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(
                              title: "Electronic Vision", user: user),
                        ));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 80),
                child: RaisedButton(
                  color: color,
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    changeSettings();
                    getPreferences();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
