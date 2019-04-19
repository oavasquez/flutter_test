//https://github.com/Rahiche/sqlite_demo/blob/master/lib/main.dart

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testapp/ClientModel.dart';
import 'package:testapp/ArticuloModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestAPP.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {


      await db.execute(
          "CREATE TABLE CODIGOBARRA ("
          "Id INTEGER PRIMARY KEY,"
          "CodigoBarra TEXT,"
          "SKU TEXT,"
          "UnidadMedida TEXT,"
          "CantidadBase TEXT)");

      await db.execute("CREATE TABLE ARTICULOS ("
          "Id INTEGER PRIMARY KEY,"
          "NombreArticulo TEXT,"
          "CodigoBarra TEXT,"
          "SKU TEXT,"
          "Stock TEXT"
          ")");

    });
  }

  newArticulo(Articulo newArticulo) async {
    final db = await database;
    //get the biggest id in the table

    var table = await db.rawQuery("SELECT MAX(Id)+1 AS Id FROM ARTICULOS");

    int id = table.first["Id"];

    //insert to the table using the new id

    var raw = await db.rawInsert(
        "INSERT INTO ARTICULOS ( Id , NombreArticulo, CodigoBarra, SKU, Stock)"
        " VALUES (?,?,?,?,?)",
        [id, newArticulo.nombreArticulo,newArticulo.codigoBarra,newArticulo.sku,newArticulo.stock]);
    return raw;
  }


  newCodigoBarra(Articulo newArticulo) async {
    final db = await database;
    //get the biggest id in the table

    var table = await db.rawQuery("SELECT MAX(Id)+1 AS Id FROM CODIGOBARRA");

    int id = table.first["Id"];

    //insert to the table using the new id

    var raw = await db.rawInsert(
        "INSERT INTO CODIGOBARRA ( Id , CodigoBarra, SKU, UnidadMedida, CantidadBase)"
            " VALUES (?,?,?,?,?)",
        [id, newArticulo.codigoBarra,newArticulo.sku,newArticulo.unidadMedida,newArticulo.cantidadBase]);
    return raw;
  }

  Future<List<Articulo>> getAllArticulo() async {
    final db = await database;
    var res = await db.query("ARTICULOS");

    List<Articulo> list =
    res.isNotEmpty ? res.map((c) => Articulo.fromMap(c)).toList() : [];

    return list;
  }

  Future<List<Articulo>> getCodigoBarra(String CodigoBarra) async {
    final db = await database;

    var res = await db.query("CODIGOBARRA", where: "CodigoBarra = ?", whereArgs: [CodigoBarra]);

    List<Articulo> list =
    res.isNotEmpty ? res.map((c) => Articulo.fromMap(c)).toList() : [];

    return list;

  }





  blockOrUnblock(Client client) async {
    final db = await database;
    Client blocked = Client(
        id: client.id,
        firstName: client.firstName,
        lastName: client.lastName,
        blocked: !client.blocked);
    var res = await db.update("Client", blocked.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return res;
  }

  updateClient(Client newClient) async {
    final db = await database;
    var res = await db.update("Client", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getBlockedClients() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);

    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }



  deleteClient(int id) async {
    final db = await database;
    return db.delete("Client", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;

    db.rawDelete("DELETE FROM ARTICULOS");

  }
}
