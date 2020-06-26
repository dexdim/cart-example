import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Cart.dart';
import 'ScopeManage.dart';
import 'Details.dart';

class Home extends StatefulWidget {
  final AppModel appModel;
  static final String route = 'Home-route';

  Home({this.appModel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  Widget gridGenerate(List<Data> data, aspectRadtio) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height + 150)),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(detail: data[index])));
                },
                child: Container(
                    height: 300.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 8.0)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Image.network(
                                      'http://www.malmalioboro.co.id/${data[index].gambar}',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            '${data[index].nama}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(height: 50),
                              Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Text(
                                  'Rp ${data[index].harga}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              ));
        },
        itemCount: data.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Malioboro Mall Supermarket'),
        elevation: 0.0,
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 20, 20),
                child: InkResponse(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              Positioned(
                child: ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) {
                    return Container(
                      child: Text(
                        (model.cartListing.length > 0)
                            ? model.cartListing.length.toString()
                            : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
      body: ScopedModelDescendant<AppModel>(builder: (context, child, model) {
        return gridGenerate(model.itemListing, (itemWidth / itemHeight));
      }),
    );
  }
}
