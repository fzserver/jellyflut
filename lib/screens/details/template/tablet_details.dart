import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/detail_header_bar.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/screens/details/template/rightDetails.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;

class TabletDetails extends StatefulWidget {
  final Item item;
  final Future<Item> itemToLoad;
  final Future<Color> dominantColorFuture;
  final String? heroTag;

  TabletDetails(
      {Key? key,
      required this.item,
      required this.itemToLoad,
      required this.dominantColorFuture,
      this.heroTag})
      : super(key: key);

  @override
  _TabletDetailsState createState() => _TabletDetailsState();
}

class _TabletDetailsState extends State<TabletDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tabletScreenTemplate();
  }

  Widget tabletScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: ImageType.BACKDROP,
      ),
      ClipRect(
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
        child: FutureBuilder<Color>(
            future: widget.dominantColorFuture,
            builder: (context, colorsSnapshot) {
              if (colorsSnapshot.hasData) {
                final finalDetailsThemeData =
                    Luminance.computeLuminance(colorsSnapshot.data!);
                return Theme(
                    data: finalDetailsThemeData,
                    child: detailsBuilder(finalDetailsThemeData));
              }
              return Theme(
                  data: personnal_theme.Theme.defaultThemeData,
                  child:
                      detailsBuilder(personnal_theme.Theme.defaultThemeData));
            }),
      )),
      DetailHeaderBar(
        color: Colors.white,
        showDarkGradient: false,
        height: 64,
      ),
    ]);
  }

  Widget detailsBuilder(ThemeData themeData) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: themeData.backgroundColor.withOpacity(0.4)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 82, 24, 24),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    poster(),
                    if (widget.item.hasLogo())
                      Flexible(
                          child:
                              Logo(item: widget.item, size: mediaQuery.size)),
                  ],
                ),
                asyncRightDetails()
              ],
            ))
      ],
    );
  }

  Widget asyncRightDetails() {
    return FutureBuilder<Item>(
        future: widget.itemToLoad,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RightDetails(
                item: snapshot.data!,
                dominantColorFuture: widget.dominantColorFuture);
          }
          return SkeletonRightDetails();
        });
  }

  Widget poster() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: itemHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: AspectRatio(
          aspectRatio: widget.item.getPrimaryAspectRatio(showParent: true),
          child: Poster(
            item: widget.item,
            boxFit: BoxFit.cover,
            clickable: false,
            showParent: true,
            tag: ImageType.PRIMARY,
            heroTag: widget.heroTag,
          ),
        ),
      ),
    );
  }
}
