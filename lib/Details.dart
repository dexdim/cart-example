import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'ScopeManage.dart';

class Details extends StatefulWidget {
  static final String route = 'Home-route';
  final Data detail;
  Details({this.detail});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsState();
  }
}

class DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int active = 0;

  Widget buildDot(int index, int num) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(
            color: (num == index) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle),
      ),
    );
  }

  showCartSnak(String msg, bool flag) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: (flag) ? Colors.green : Colors.red[500],
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Detail Item'),
          elevation: 0.0,
        ),
        body: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 220.0,
                    padding: EdgeInsets.only(top: 10.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          child: Image.network(
                            'http://www.malmalioboro.co.id/${widget.detail.gambar}',
                            height: 150.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 250.0,
                      alignment: Alignment(1.0, 1.0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Column(
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[],
                        ),
                      ))
                ],
              ),
              Divider(
                color: Colors.grey[300],
                height: 1.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.detail.nama,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20.0),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Kode barcode: ${widget.detail.deskripsi}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
            //margin: EdgeInsets.only(top: 10),
            height: 50.0,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey[300], width: 1.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 140.0,
                        child: Text('Harga subtotal:',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400)),
                      ),
                      Text('Rp ${widget.detail.harga}',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) {
                    return RaisedButton(
                      color: Colors.deepOrange,
                      onPressed: () {
                        model.addCart(widget.detail);
                        Timer(Duration(milliseconds: 500), () {
                          showCartSnak(model.cartMsg, model.success);
                        });
                      },
                      child: Text(
                        'TAMBAH',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                )
              ],
            )),
      ),
    );
  }
}
