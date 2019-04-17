

import 'dart:convert';



class Articulo {

  final String nombreArticulo;

  Articulo({ this.nombreArticulo});

  factory Articulo.fromMap(Map<String, dynamic> json) => new Articulo(
    nombreArticulo: json["NombreArticulo"],

  );

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      //userId: json['userId'],
      //id: json['id'],
      nombreArticulo: json['NombreArticulo'],
      //body: json['body'],
    );
  }

  Map<String, dynamic> toMap() => {
    "NombreArticulo": nombreArticulo,

  };



  Articulo articuloFromJson(String str) {
    final jsonData = json.decode(str);
    return Articulo.fromMap(jsonData);
  }

  String ArticuloToJson(Articulo data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }
}