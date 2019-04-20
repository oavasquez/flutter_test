import 'dart:convert';

class Articulo {
  final String nombreArticulo;
  final String codigoBarra;
  final String sku;
  final String stock;
  final String cantidadBase;
  final String unidadMedida;
  final String bin;

  Articulo(
      {this.nombreArticulo,
      this.codigoBarra,
      this.sku,
      this.stock,
      this.cantidadBase,
      this.unidadMedida,
      this.bin});

  factory Articulo.fromMap(Map<String, dynamic> json) => new Articulo(
      nombreArticulo:
          json["NombreArticulo"] == null ? "" : json["NombreArticulo"],
      codigoBarra: json["CodigoBarra"] == null ? "" : json["CodigoBarra"],
      sku: json["SKU"] == null ? "" : json["SKU"],
      stock: json["Stock"] == null ? "" : json["Stock"],
      cantidadBase: json["CantidadBase"] == null ? "" : json["CantidadBase"],
      unidadMedida: json["UnidadMedida"] == null ? "" : json["UnidadMedida"],
      bin: json["NombreBin"] == null ? "" : json["NombreBin"]);

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
        nombreArticulo:
            json['NombreArticulo'] == null ? "" : json["NombreArticulo"],
        codigoBarra: json["CodigoBarra"] == null ? "" : json["CodigoBarra"],
        sku: json["SKU"] == null ? "" : json["SKU"],
        stock: json["Stock"] == null ? "" : json["Stock"],
        cantidadBase: json["CantidadBase"] == null ? "" : json["CantidadBase"],
        unidadMedida: json["UnidadMedida"] == null ? "" : json["UnidadMedida"],
        bin: json["NombreBin"] == null ? "" : json["NombreBin"]);
  }

  Map<String, dynamic> toMap() => {
        "NombreArticulo": nombreArticulo,
        "CodigoBarra": codigoBarra,
        "SKU": sku,
        "Stock": stock,
        "CantidadBase": cantidadBase,
        "UnidadMedida": unidadMedida,
        "NombreBin": bin,
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
