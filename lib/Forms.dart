import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'Cart.dart';
import 'ScopeManage.dart';

class Forms extends StatefulWidget {
  static final String route = 'Form-route';

  @override
  State<StatefulWidget> createState() {
    return FormsState();
  }
}

class FormsState extends State<Forms> {
  final namaController = TextEditingController();
  final nomorhpController = TextEditingController();
  String namapemesan;
  String nomorhp;

  Widget textPesan() {
    return Container(
        width: MediaQuery.of(context).size.width / 1.3,
        child: Text(
          'Silakan anda bisa mengisi form dibawah ini untuk melengkapi proses pemesanan di Malioboro Mall Supermarket',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ));
  }

  Widget formPesan(String title, controller) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50,
              child: TextFormField(
                  controller: controller,
                  onSaved: (value) => title = value,
                  style: TextStyle(color: Colors.grey[850], fontSize: 16),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: title,
                      labelStyle: TextStyle(color: Colors.grey[850]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.deepOrangeAccent,
                      )),
                      filled: true)),
            ),
            SizedBox(height: 10),
          ]),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Form pemesanan'),
          elevation: 5,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(children: <Widget>[
            SizedBox(height: 100),
            textPesan(),
            SizedBox(height: 30),
            formPesan('Nama', namaController),
            formPesan('Nomor handphone', nomorhpController)
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: ScopedModelDescendant<AppModel>(
                builder: (context, child, model) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      color: Colors.deepOrangeAccent,
                      onPressed: () {
                        var finalprint = '';
                        printItem(Data d) {
                          finalprint +=
                              '\nNama item : ${d.nama}\nHarga item : Rp ${d.harga}\nKode barcode : ${d.deskripsi}\n';
                        }

                        finalprint += 'Halo Supermarket Malioboro Mall\n';
                        finalprint += 'Berikut adalah daftar belanja dari,\n';
                        finalprint += 'Nama pemesan: ${namaController.text}\n';
                        finalprint +=
                            'Nomor handphone: ${nomorhpController.text}';
                        finalprint += '\n=================\n\n';
                        model.cartListing.map((d) => printItem(d)).toString();
                        finalprint +=
                            '\n\n=================\nTotal harga : Rp ${CartState.totalHarga}';
                        finalprint +=
                            '\nMohon untuk dicek ketersediaan stocknya. Terima kasih.';

                        FlutterOpenWhatsapp.sendSingleMessage(
                            '6282138020366', '${finalprint.toString()}');
                      },
                      child: Text(
                        'ORDER',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                ],
              );
            }),
          ),
        ));
  }
}
