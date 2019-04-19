
import 'package:flutter/material.dart';
import 'package:testapp/Database.dart';
import 'package:testapp/ArticuloModel.dart';




class BarCodeDetailsPage extends StatefulWidget {
  final String CodeBar;

  BarCodeDetailsPage({Key key,  this.CodeBar}) : super(key: key);

  @override
  BarCodeDetailsPageState createState() {
    return BarCodeDetailsPageState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class BarCodeDetailsPageState extends State<BarCodeDetailsPage> {
  // Create a global key that will uniquely identify the Form widget and allow



  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Articulo>>(
      future: DBProvider.db.getCodigoBarra(widget.CodeBar),
      builder: (context, snapshot) {
        print(widget.CodeBar);

        List<Articulo> posts = snapshot.data;
        if(!snapshot.hasData) {
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
                          posts[index].sku,
                          style: TextStyle(fontSize: 15.0),
                        ),
                        subtitle: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Unidad de medida:'+posts[index].unidadMedida),
                                Text('Cantidad Base :'+posts[index].cantidadBase),
                                Text('Codigo de Barra :'+posts[index].codigoBarra),
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
                    "No se han econtrado coincidencia.",
                    style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                ]),
          );
        }
      },
    );
  }
}
