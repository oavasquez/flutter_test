import 'package:testapp/fab_with_icons.dart';
import 'package:testapp/Database.dart';
import 'package:testapp/ArticuloModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Sincronizar extends StatefulWidget {
  @override
  SincronizarState createState() {
    return SincronizarState();
  }
}

void BorrarDatos() async {

  await DBProvider.db.deleteAll();
  print("Datos Borrados Exitosamente");

}

Future<List<Articulo>> solicitandoArticulos() async {
  Map data;
  final response =


  //await http.get('https://jsonplaceholder.typicode.com/posts');
  await http.post(
      'http://192.168.0.93:80/inventario.aspx/consultarArticulosJson',
      headers: {"Content-Type": "application/json"});


  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    data = jsonDecode(response.body);
    List responseJson = json.decode(data['d']);

    List<Articulo> ListaArticulos = responseJson.map((m) => new Articulo.fromJson(m)).toList();

    print(ListaArticulos[50].nombreArticulo);


    for(var i = 0; i < ListaArticulos.length; i++){
      await DBProvider.db.newArticulo(ListaArticulos[i]);
      print(ListaArticulos[i]);
    }

    print("se ha terminado la sincronizacion");

    return ListaArticulos;


    //return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}



// Create a corresponding State class. This class will hold the data related to
// the form.
class SincronizarState extends State<Sincronizar> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  @override
  void initState() {
    DBProvider.db.initDB();
    super.initState();
  }
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!



  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Container(
        alignment: Alignment(0.0, 0.0),
        constraints: BoxConstraints.expand(width: 290.0, height: 300.0),
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
            ),    Padding(
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

                  },
                  child: Text('Borrar Datos Sincronizados'),
                ),
              ),
            ),
          ],
        ));
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

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            List<Articulo> posts = snapshot.data;

            return Card(

              child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album),
                          title:  Text(posts[index].nombreArticulo, style: TextStyle(fontSize: 18.0),),
                          subtitle: Center(
                            child: Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Precio:'),
                                  Text('Strock:'),
                                  Text('Estado:'),

                                ]
                            ),),
                        ),
                        ButtonTheme.bar( // make buttons use the appropriate styles for cards
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('REVISAR'),
                                onPressed: () { /* ... */ },
                              ),
                              FlatButton(
                                child: const Text('CONTAR'),
                                onPressed: () { /* ... */ },
                              ),
                            ],
                          ),
                        ),
                      ]
                  )

              ),
            );
          },
        );
      },
    );
  }



}

