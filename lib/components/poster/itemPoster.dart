import 'package:flutter/material.dart';
import 'package:jellyflut/components/banner/LeftBanner.dart';
import 'package:jellyflut/components/banner/RightBanner.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progressBar.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatefulWidget {
  const ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.widgetAspectRatio,
      this.showName = true,
      this.showParent = true,
      this.showLogo = false,
      this.clickable = true,
      this.tag = 'Primary',
      this.boxFit = BoxFit.cover});

  final Item item;
  final String? heroTag;
  final double? widgetAspectRatio;
  final Color textColor;
  final bool showName;
  final bool showParent;
  final bool showLogo;
  final bool clickable;
  final String tag;
  final BoxFit boxFit;

  @override
  _ItemPosterState createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // Dpad navigation
  late final FocusNode _node;
  late final String posterHeroTag;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _node = FocusNode();
    posterHeroTag = widget.heroTag ?? widget.item.id + Uuid().v4();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(
        aspectRatio:
            widget.widgetAspectRatio ?? widget.item.getPrimaryAspectRatio(),
        child: body(context));
  }

  Widget body(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
                aspectRatio: widget.widgetAspectRatio ??
                    widget.item.getPrimaryAspectRatio(),
                child: Stack(fit: StackFit.expand, children: [
                  Poster(
                      showParent: widget.showParent,
                      tag: widget.tag,
                      aspectRatio: widget.widgetAspectRatio,
                      clickable: widget.clickable,
                      heroTag: posterHeroTag,
                      boxFit: widget.boxFit,
                      item: widget.item),
                  IgnorePointer(
                      child: Stack(
                    children: [
                      if (widget.item.isNew())
                        Positioned(top: 8, left: 0, child: newBanner()),
                      if (widget.item.isPlayed())
                        Positioned(top: 8, right: 0, child: playedBanner()),
                    ],
                  )),
                  if (widget.showLogo)
                    IgnorePointer(
                        child: Logo(
                      item: widget.item,
                      size: Size.infinite,
                    )),
                  if (widget.item.hasProgress()) progress(),
                ])),
          ],
        ),
      ),
      if (widget.showName) name()
    ]);
  }

  Widget progress() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(child: progressBar())));
  }

  Widget name() {
    return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          children: [
            Text(
              widget.showParent ? widget.item.parentName() : widget.item.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
            ),
            if (widget.item.isFolder != null &&
                widget.item.parentIndexNumber != null)
              Text(
                'Season ${widget.item.parentIndexNumber}, Episode ${widget.item.indexNumber}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 12),
              ),
          ],
        ));
  }

  Widget newBanner() {
    return CustomPaint(
        painter: LeftBanner(color: Colors.red[700]!),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Text('NEW',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
  }

  Widget playedBanner() {
    return CustomPaint(
        painter: RightBanner(color: Colors.green[700]!),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )));
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.2,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProgressBar(item: widget.item)));
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return 2;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(
            width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }
}
