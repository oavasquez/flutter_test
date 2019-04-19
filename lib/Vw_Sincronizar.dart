
import 'package:testapp/Database.dart';
import 'package:testapp/ArticuloModel.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Sincronizar extends StatefulWidget {
  final Function(bool estado) notifyParent;

  Sincronizar({Key key, @required this.notifyParent}) : super(key: key);

  @override
  SincronizarState createState() {
    return SincronizarState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class SincronizarState extends State<Sincronizar> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  double CircularPercent = 0;

  bool _saving = false;
  int _parte = 1;

  @override
  void initState() {
    DBProvider.db.initDB();
    super.initState();
  }

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!

  void BorrarDatos() async {
    widget.notifyParent(true);

    await DBProvider.db.deleteAll();
    print("Datos Borrados Exitosamente");
    widget.notifyParent(false);
  }

  Future<List<Articulo>> solicitandoArticulos() async {
    Map data;
    final response =

        //await http.get('https://jsonplaceholder.typicode.com/posts');
        await http.post(
            'http://192.168.0.93:80/inventario.aspx/consultarArticulosJson',
            headers: {"Content-Type": "application/json"});
    print(response.statusCode);

    if (response.statusCode == 200) {
      widget.notifyParent(true);
      // If the call to the server was successful, parse the JSON
      data = jsonDecode(response.body);
      List responseJson = json.decode(data['d']);

      List<Articulo> ListaArticulos =
          responseJson.map((m) => new Articulo.fromJson(m)).toList();

      for (var i = 0; i < ListaArticulos.length; i++) {
        await DBProvider.db.newArticulo(ListaArticulos[i]);

        var num = double.parse((i / ListaArticulos.length).toStringAsFixed(1));

        setState(() {
          CircularPercent =
              double.parse((i / ListaArticulos.length).toStringAsFixed(2));
        });
      }

      widget.notifyParent(false);

      solicitandoCodigoBarra();
      return ListaArticulos;

      //return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }




  Future<List<Articulo>> solicitandoCodigoBarra() async {

    setState(() {
      _parte =2;
    });

    Map data;
    final response =

    //await http.get('https://jsonplaceholder.typicode.com/posts');
    await http.post(
        'http://192.168.0.93:80/inventario.aspx/consultarCodigoBarraJson',
        headers: {"Content-Type": "application/json"});
    print(response.statusCode);

    if (response.statusCode == 200) {
      widget.notifyParent(true);
      // If the call to the server was successful, parse the JSON
      data = jsonDecode(response.body);
      List responseJson = json.decode(data['d']);

      List<Articulo> ListaArticulos =
      responseJson.map((m) => new Articulo.fromJson(m)).toList();

      for (var i = 0; i < ListaArticulos.length; i++) {
        await DBProvider.db.newCodigoBarra(ListaArticulos[i]);

        var num = double.parse((i / ListaArticulos.length).toStringAsFixed(1));

        setState(() {
          CircularPercent =
              double.parse((i / ListaArticulos.length).toStringAsFixed(2));
        });
      }

      widget.notifyParent(false);


      return ListaArticulos;

      //return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Widget _mensajeCircularPercent() {
    if (CircularPercent == 0) {
      return new Text(
        "Preparando para guardar...",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      );
    }
    if (CircularPercent < 1 && CircularPercent > 0) {
      return new Text(
        "Guardando Datos... $_parte/2 " +
            (CircularPercent * 100).toStringAsFixed(1) +
            "%",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      );
    }
    if (CircularPercent == 1) {
      return new Text(
        "Datos Guardados Exitosamente",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      );
    }
  }

  Widget _buildWidget() {
    return Container(
        alignment: Alignment(0.0, 0.0),
        constraints: BoxConstraints.expand(width: 500.0, height: 500.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    solicitandoArticulos();

                  },
                  child: Text('Sincronizar Datos'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    BorrarDatos();
                    final snackBar = SnackBar(
                      content: Text('Se han borrado los Datos'),
                      action: SnackBarAction(
                        label: 'Aceptar',
                        onPressed: () {
                          // Some code to undo the change!
                        },
                      ),
                    );

                    Scaffold.of(context).showSnackBar(snackBar);


                  },
                  child: Text('Borrar Datos Sincronizados'),
                ),
              ),
            ),
            new CircularPercentIndicator(
              radius: 200.0,
              lineWidth: 13.0,
              animation: false,
              percent: CircularPercent,
              center: new Icon(
                Icons.save,
                size: 100.0,
                color: Colors.blue,
              ),
              footer: _mensajeCircularPercent(),
              progressColor: Colors.indigo,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ModalProgressHUD(child: _buildWidget(), inAsyncCall: _saving),
    );
  }
}

class MostrarSincronizacion extends StatefulWidget {
  @override
  MostrarSincronizacionState createState() {
    return MostrarSincronizacionState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MostrarSincronizacionState extends State<MostrarSincronizacion> {
  // Create a global key that will uniquely identify the Form widget and allow

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Articulo>>(
      future: DBProvider.db.getAllArticulo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        List<Articulo> posts = snapshot.data;
    if(posts.length>0) {
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          print(posts[index].codigoBarra);


          return Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.local_grocery_store),
                    title: Text(
                      posts[index].nombreArticulo,
                      style: TextStyle(fontSize: 15.0),
                    ),
                    subtitle: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Stock:'+posts[index].stock),
                            Text('Codigo de Barra:'),
                          ]),
                    ),
                  ),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('REVISAR'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                        FlatButton(
                          child: const Text('CONTAR'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ),
                ])),
          );
        },
      );
    }else{
     return  Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
            "No hay datos Guardados.",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
        ]),
     );
    }
      },
    );
  }
}
