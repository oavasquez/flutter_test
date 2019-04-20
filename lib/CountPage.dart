import 'package:flutter/material.dart';
import 'package:testapp/Database.dart';
import 'package:testapp/BarCodeDetailsPage.dart';
import 'package:testapp/ArticuloModel.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class CountPage extends StatefulWidget {
  final Articulo articulo;

  CountPage({Key key, this.articulo}) : super(key: key);

  @override
  CountPageState createState() {
    return CountPageState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class CountPageState extends State<CountPage> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Articulo>> key = new GlobalKey();

  TextEditingController _nombreArticulo = new TextEditingController();
  TextEditingController _unidadMedida = new TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  Widget row(Articulo articulo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          articulo.bin,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          articulo.bin,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Articulo>>(
        future: DBProvider.db.getBines(),
        builder: (context, snapshot) {
          _nombreArticulo.text=widget.articulo.nombreArticulo;
          _unidadMedida.text=widget.articulo.unidadMedida;
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<Articulo> bines = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text("Enviar Datos de Conteo"),
            ),
            body: Center(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Articulo',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                      ),
                      controller: _nombreArticulo,

                      /* validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese una contraseña valida';
                    }
                  },*/
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Unidad de Medida',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                      ),
                      controller: _unidadMedida,

                      /* validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese una contraseña valida';
                    }
                  },*/
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:2.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                      ),

                      /* validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese una contraseña valida';
                    }
                  },*/
                    ),
                  ),
                  Expanded(
                    child: searchTextField = AutoCompleteTextField<Articulo>(
                      key: key,
                      clearOnSubmit: false,
                      suggestions: bines,
                      suggestionsAmount: 10,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      decoration: InputDecoration(
                        labelText: 'Seleccionar Bin',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person),
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      itemFilter: (item, query) {
                        return item.bin
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                      itemSorter: (a, b) {
                        return a.bin.compareTo(b.bin);
                      },
                      itemSubmitted: (item) {
                        searchTextField.textField.controller.text = item.bin;
                      },
                      itemBuilder: (context, item) {
                        // ui for the autocompelete row
                        return row(item);
                      },
                    ),
                  ), RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);

                    },
                    child: Text("Enviar"),
                  ),

                ],
              ),
            ),
          );
        });
  }
}
