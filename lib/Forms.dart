import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'Cart.dart';
import 'ScopeManage.dart';

class Forms extends StatefulWidget {
  static final String route = 'Form-route';

  @override
  State<StatefulWidget> createState() {
    return FormState();
  }
}

class FormsState extends State<Forms> {
  String namapemesan;
  String nomorhp;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Form pemesan'),
          elevation: 5,
        ),
        body: Container(
          child: Column(children: <Widget>[]),
        ),
        bottomNavigationBar:
            ScopedModelDescendant<AppModel>(builder: (context, child, model) {
          child:
          RaisedButton(
            onPressed: () {
              var finalprint = '';
              printItem(Data d) {
                finalprint +=
                    'Nama item : ${d.nama}\nHarga item : Rp ${d.harga}\n';
              }

              finalprint += 'Halo Supermarket Malioboro Mall\n';
              finalprint +=
                  'Berikut adalah daftar pesanan belanja atas nama ${namapemesan}\n';
              finalprint += 'Nomor handphone: ${nomorhp}';
              finalprint += '=================\n\n';
              model.cartListing.map((d) => printItem(d)).toString();
              finalprint +=
                  '\n=================\nTotal harga : Rp ${CartState.totalHarga}';

              FlutterOpenWhatsapp.sendSingleMessage(
                  '6288806065032', '${finalprint.toString()}');
            },
          );
        }));
  }
}
