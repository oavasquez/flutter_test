import 'package:flutter/material.dart';
import 'package:testapp/Database.dart';
import 'package:testapp/ArticuloModel.dart';
import 'package:testapp/CountPage.dart';

class BarCodeDetailsPage extends StatefulWidget {
  final String CodeBar;

  BarCodeDetailsPage({Key key, this.CodeBar}) : super(key: key);

  @override
  BarCodeDetailsPageState createState() {
    return BarCodeDetailsPageState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class BarCodeDetailsPageState extends State<BarCodeDetailsPage> {
  // Create a global key that will uniquely identify the Form widget and allow

  TextEditingController _nombreArticulo = new TextEditingController();
  TextEditingController _unidadMedida = new TextEditingController();

  _showDialog(Articulo articulo) async {
    _nombreArticulo.text = articulo.nombreArticulo;
    _unidadMedida.text = articulo.unidadMedida;

    showDialog(
        child: new Dialog(
          child: Center(
            child: Container(
              width: 400.0,
              height: 500.0,
              child:
              new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child:
                    Text("Articulo: "+articulo.nombreArticulo,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child:
                    Text("Unidad de Medida: "+articulo.unidadMedida,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child:
                    new TextField(
                      decoration: InputDecoration(
                        labelText: 'BIN',
                        border: OutlineInputBorder(),
                      ),
                      controller: _unidadMedida,
                    ),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child:
                    new TextField(
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                      controller: _unidadMedida,
                    ),),

                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                        FlatButton(
                          child: const Text('Enviar'),
                          onPressed: () {

                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Articulo>>(
      future: DBProvider.db.getCodigoBarra(widget.CodeBar),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        List<Articulo> posts = snapshot.data;
        if (posts.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.local_grocery_store),
                            title: Text(
                              posts[index].sku +
                                  "-" +
                                  posts[index].nombreArticulo,
                              style: TextStyle(fontSize: 15.0),
                            ),
                            subtitle: Center(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Unidad de medida:' +
                                        posts[index].unidadMedida),
                                    Text('Cantidad Base :' +
                                        posts[index].cantidadBase),
                                    Text('Codigo de Barra :' +
                                        posts[index].codigoBarra),
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

                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>  new CountPage(articulo: posts[index])));
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
        } else {
          return Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "No se encontraron coicidencias.",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                ]),
          );
        }
      },
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
