import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ScopeManage.dart';

class Cart extends StatefulWidget {
  static final String route = 'Cart-route';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CartState();
  }
}

class CartState extends State<Cart> {
  Widget generateCart(Data d) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border(
              bottom: BorderSide(color: Colors.grey[100], width: 1.0),
              top: BorderSide(color: Colors.grey[100], width: 1.0),
            )),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5.0)
                  ],
                  image: DecorationImage(
                      image: NetworkImage(
                          'http://www.malmalioboro.co.id/${d.gambar}'),
                      fit: BoxFit.fill)),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          d.nama,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15.0),
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          child: ScopedModelDescendant<AppModel>(
                            builder: (context, child, model) {
                              return InkResponse(
                                  onTap: () {
                                    model.removeCart(d);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                  ));
                            },
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('Rp. ${d.harga}'),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Daftar Keranjang'),
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[300], width: 1.0))),
          child: ScopedModelDescendant<AppModel>(
            builder: (context, child, model) {
              return ListView(
                shrinkWrap: true,
                children:
                    model.cartListing.map((d) => generateCart(d)).toList(),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: Container(
            height: 50,
            child: ScopedModelDescendant<AppModel>(
                builder: (context, child, model) {
              dynamic totalHarga;
              List cart;
              //List<dynamic> _cartList;
              //model.cartListing.map((d) => _cartList);
              print(model.cartListing);
              /*
              totalHarga = _cartList.fold(0, (sum, item) {
                sum += item.harga;
              });
              */

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total harga $totalHarga'),
                  RaisedButton(
                    color: Colors.deepOrange,
                    onPressed: () {},
                    child: Text(
                      'CHECKOUT',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
            }),
          ),
        ));
  }
}
