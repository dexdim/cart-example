import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class AppModel extends Model {
  final String url =
      'http://www.malmalioboro.co.id/index.php/api/produk/get_list';
  List<Item> _items = [];
  List<Data> data = new List<Data>();
  List<Data> _data = [];
  List<Data> _cart = [];
  String cartMsg = "";
  bool success = false;
  Database _db;
  Directory tempDir;
  String tempPath;
  final LocalStorage storage = new LocalStorage('app_data');

  Future<List<Data>> getData() async {
    Map body = {'idtenan': '136'};

    http.Response response = await http.post(Uri.encodeFull(url), body: body);

    var jsonResponse = json.decode(response.body);

    for (var dataJson in jsonResponse) {
      data.add(new Data.fromJson(dataJson));
    }
    notifyListeners();
    return data;
  }

  AppModel() {
    // Create DB Instance & Create Table
    createDB();
  }

  deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'cart.db');

    await deleteDatabase(path);
    if (storage.getItem("isFirst") != null) {
      await storage.deleteItem("isFirst");
    }
  }

  createDB() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'cart.db');

      print(path);
//      await storage.deleteItem("isFirst");
//      await this.deleteDB();

      var database =
          await openDatabase(path, version: 1, onOpen: (Database db) {
        this._db = db;
        print("OPEN DBV");
        this.createTable();
      }, onCreate: (Database db, int version) async {
        this._db = db;
        print("DB Crated");
      });
    } catch (e) {
      print("ERRR >>>");
      print(e);
    }
  }

  createTable() async {
    try {
      var qry = "CREATE TABLE IF NOT EXISTS item_list ( "
          "id INTEGER PRIMARY KEY,"
          "nama TEXT,"
          "deskripsi TEXT"
          "gambar TEXT,"
          "harga REAL,"
          "datetime DATETIME)";
      await this._db.execute(qry);
      qry = "CREATE TABLE IF NOT EXISTS cart_list ( "
          "id INTEGER PRIMARY KEY,"
          "nama TEXT,"
          "deskripsi TEXT"
          "gambar TEXT,"
          "harga REAL,"
          "datetime DATETIME)";

      await this._db.execute(qry);

      var _flag = storage.getItem("isFirst");
      print("FLAG IS FIRST $_flag");
      if (_flag == "true") {
        this.fetchLocalData();
        this.fetchCartList();
      } else {
        this.insertInLocal();
      }
    } catch (e) {
      print("ERRR ^^^");
      print(e);
    }
  }

  fetchLocalData() async {
    try {
      // Get the records
      List<Map> list = await this._db.rawQuery('SELECT * FROM item_list');
      list.map((dd) {
        Data d = new Data();
        d.id = dd["id"];
        d.nama = dd["nama"];
        d.deskripsi = dd["deskripsi"];
        d.gambar = dd["gambar"];
        d.harga = dd["harga"];
        _data.add(d);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR %%%");
      print(e);
    }
  }

  insertInLocal() async {
    try {
      await this._db.transaction((tx) async {
        for (var i = 0; i < data.length; i++) {
          print("Called insert $i");
          Data d = new Data();
          d.id = i + 1;
          d.nama = data[i].nama;
          d.deskripsi = data[i].deskripsi;
          d.harga = data[i].harga;
          d.gambar = data[i].gambar;
          try {
            var qry =
                'INSERT INTO item_list(nama, deskripsi, harga, gambar) VALUES("${d.nama}",${d.deskripsi},${d.harga},"${d.gambar}")';
            var _res = await tx.rawInsert(qry);
          } catch (e) {
            print("ERRR >>>");
            print(e);
          }
          _data.add(d);
          notifyListeners();
        }

        storage.setItem("isFirst", "true");
      });
    } catch (e) {
      print("ERRR ## > ");
      print(e);
    }
  }

  insertInCart(Data d) async {
    await this._db.transaction((tx) async {
      try {
        var qry =
            'INSERT INTO cart_list(shop_id,nama, deskripsi, harga,gambar) VALUES(${d.id},"${d.nama}",${d.deskripsi},"${d.harga}",${d.gambar})';
        var _res = await tx.execute(qry);
        this.fetchCartList();
      } catch (e) {
        print("ERRR @@ @@");
        print(e);
      }
    });
  }

  fetchCartList() async {
    try {
      // Get the records
      _cart = [];
      List<Map> list = await this._db.rawQuery('SELECT * FROM cart_list');
      print("Cart len ${list.length.toString()}");
      list.map((dd) {
        Data d = new Data();
        d.id = dd["id"];
        d.nama = dd["nama"];
        d.deskripsi = dd["deskripsi"];
        d.harga = dd["harga"];
        d.gambar = dd["gambar"];
        _cart.add(d);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  // Item List
  List<Data> get itemListing => _data;

  // Item Add
  void addItem(Data dd) {
    Data d = new Data();
    d.id = _data.length + 1;
    d.nama = "New";
    d.deskripsi = "Barcode";
    d.harga = 154.0;
    d.gambar =
        "https://rukminim1.flixcart.com/image/832/832/jao8uq80/shoe/3/r/q/sm323-9-sparx-white-original-imaezvxwmp6qz6tg.jpeg?q=70";
    _data.add(d);
    notifyListeners();
  }

  // Cart Listing
  List<Data> get cartListing => _cart;

  // Add Cart
  void addCart(Data dd) {
    print(dd);
    print(_cart);
    int _index = _cart.indexWhere((d) => d.id == dd.id);
    if (_index > -1) {
      success = false;
      cartMsg = "${dd.nama.toUpperCase()} sudah ada di daftar keranjang.";
    } else {
      this.insertInCart(dd);
      success = true;
      cartMsg =
          "${dd.nama.toUpperCase()} sukses ditambahkan dalam daftar keranjang.";
    }
  }

  removeCartDB(Data d) async {
    try {
      var qry = "DELETE FROM cart_list where id = ${d.id}";
      this._db.rawDelete(qry).then((data) {
        print(data);
        int _index = _cart.indexWhere((dd) => dd.id == d.id);
        _cart.removeAt(_index);
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print("ERR rm cart$e");
    }
  }

  // Remove Cart
  void removeCart(Data dd) {
    this.removeCartDB(dd);
  }
}

class Item {
  final String nama;

  Item(this.nama);
}

class Data {
  int id;
  String nama;
  String deskripsi;
  double harga;
  String gambar;

  Data({this.id, this.nama, this.deskripsi, this.harga, this.gambar});

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nama = json['nama'],
        deskripsi = json['deskripsi'],
        harga = json['harga'],
        gambar = json['gambar'];
}
