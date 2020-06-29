import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                (MediaQuery.of(context).size.height / 1.1)),
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
                    height: 330.0,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10.0)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            height: 310.0,
                            child: Column(children: <Widget>[
                              Container(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'http://www.malmalioboro.co.id/${data[index].gambar}',
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '${data[index].nama}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                              ),
                            ])),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'Rp ${data[index].harga}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
        automaticallyImplyLeading: false,
        title: Text('Malioboro Mall Supermarket'),
        elevation: 5,
        actions: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, right: 15),
                child: InkResponse(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()));
                  },
                  child: Icon(Icons.shopping_cart),
                ),
              ),
              Positioned(
                //right: 500,
                child: ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) {
                    return Container(
                      child: Text(
                        (model.cartListing.length > 0)
                            ? model.cartListing.length.toString()
                            : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
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
