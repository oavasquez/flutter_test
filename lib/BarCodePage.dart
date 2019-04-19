
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:testapp/Database.dart';
import 'package:testapp/BarCodeDetailsPage.dart';
import 'package:testapp/ArticuloModel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async';
import 'dart:convert';


class BarCodePage extends StatefulWidget {
  BarCodePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BarCodePageState createState() => new _BarCodePageState();
}

class _BarCodePageState extends State<BarCodePage> {
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
  }


  Widget _builListView() {

    if(_scanBarcode!=''){
     return  BarCodeDetailsPage();
    }else{
      return Text(
          '',
          style: TextStyle(fontSize: 20));

    }

  }




  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes =
      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              initPlatformState();
            },
            child: Text("Escanear"),
          ),
          Text(
            'El Codigo de Barra es : $_scanBarcode\n',
            style: TextStyle(fontSize: 20),
          ),
    Expanded(
    child: _builListView(),
    )
        ]

      ),
      )
    );
  }
}

