import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/components/carroussel/carrousselBackGroundImage.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/carrousselModel.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/collection/listItems.dart';
import 'package:jellyflut/shared/background.dart';
import 'package:provider/provider.dart';

class CollectionMain extends StatefulWidget {
  final Item item;

  const CollectionMain({@required this.item});

  @override
  State<StatefulWidget> createState() {
    return _CollectionMainState();
  }
}

class _CollectionMainState extends State<CollectionMain> {
  var items = <Item>[];
  var itemsToShow = <Item>[];

  // Provider
  ListOfItems listOfItems;
  CarrousselModel carrousselModel;

  @override
  void initState() {
    super.initState();
    listOfItems = ListOfItems();
    carrousselModel = CarrousselModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context);
    listOfItems.setParentItem(widget.item);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Background(
            child: Stack(children: [
          if (widget.item.collectionType == 'movies' ||
              widget.item.collectionType == 'books')
            ChangeNotifierProvider.value(
                value: carrousselModel, child: CarrousselBackGroundImage()),
          Padding(
              padding: EdgeInsets.only(top: size.padding.top),
              child: ChangeNotifierProvider.value(
                  value: listOfItems, child: ListItems()))
        ])));
  }
}
