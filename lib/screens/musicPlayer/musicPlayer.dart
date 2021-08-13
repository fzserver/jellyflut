import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/musicPlayer/components/songControls.dart';
import 'package:jellyflut/screens/musicPlayer/components/songHeaderBar.dart';
import 'package:jellyflut/screens/musicPlayer/components/songImage.dart';
import 'package:jellyflut/provider/musicPlayer.dart' as music_player_provider;
import 'package:jellyflut/screens/musicPlayer/components/songInfos.dart';
import 'package:jellyflut/screens/musicPlayer/components/songPlaylist.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late music_player_provider.MusicPlayer musicPlayer;
  late Color backgroundColor1;
  late Color backgroundColor2;
  late Color foregroundColor;
  late int musicPlayerIndex;

  @override
  void initState() {
    super.initState();
    backgroundColor1 = jellyLightPurple;
    backgroundColor2 = jellyDarkPurple;
    foregroundColor = Colors.black;
    musicPlayer = music_player_provider.MusicPlayer();
    musicPlayer.getCommonPlayer!
        .listenPlayingindex()
        .listen((event) => setState(() {
              musicPlayer.setPlayingIndex(event);
            }));
    // musicPlayerIndex = musicPlayer.assetsAudioPlayer.current.value!.index;
    setAlbumPrimaryColor();
    setForegroundColorFromBackground();
    // playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<music_player_provider.MusicPlayer>(
        builder: (context, mp, child) {
      return player();
    });
  }

  Widget player() {
    var statusBarHeight =
        MediaQuery.of(context).padding.top == 0 ? 12.toDouble() : 12.toDouble();
    var size = MediaQuery.of(context).size;
    var height = size.height - statusBarHeight;
    return Scaffold(
        extendBody: false,
        backgroundColor: Colors.grey.shade900,
        body: ChangeNotifierProvider.value(
            value: musicPlayer,
            child: ScreenTypeLayout.builder(
                mobile: (BuildContext context) =>
                    phoneTemplate(height, statusBarHeight),
                tablet: (BuildContext context) =>
                    largeScreenTemplate(height, statusBarHeight),
                desktop: (BuildContext context) =>
                    largeScreenTemplate(height, statusBarHeight))));
  }

  Widget largeScreenTemplate(double height, double statusBarHeight) {
    var singleSize = (height * 0.90 > 600 ? 600 : height * 0.90) * 0.6;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SongHeaderBar(height: height * 0.05, color: Colors.white),
      ),
      Expanded(
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: singleSize, child: SongInfos(color: Colors.white)),
                  SizedBox(
                    height: singleSize + 40,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SongImage(
                            singleSize: singleSize,
                            color: foregroundColor,
                            albumColors: [backgroundColor1, backgroundColor2]),
                        Positioned.fill(
                            top: singleSize - 40,
                            child: SongControls(
                                color: foregroundColor,
                                backgroundColor: backgroundColor2)),
                      ],
                    ),
                  ),
                ]),
          )),
          Expanded(
            child: ClipRRect(
              child: Column(
                children: [
                  Expanded(
                    child: SongPlaylist(
                        backgroundColor: Colors.grey.shade900,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ]),
      )
    ]);
  }

  Widget phoneTemplate(double height, double statusBarHeight) {
    var singleSize = (height * 0.90 > 600 ? 600 : height * 0.90) * 0.6;
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: statusBarHeight,
            ),
            SongHeaderBar(height: height * 0.05, color: Colors.white),
            SizedBox(width: singleSize, child: SongInfos(color: Colors.white)),
            SizedBox(
              height: singleSize + 40,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SongImage(
                      singleSize: singleSize,
                      color: foregroundColor,
                      albumColors: [backgroundColor1, backgroundColor2]),
                  Positioned.fill(
                      top: singleSize - 40,
                      child: SongControls(
                          color: foregroundColor,
                          backgroundColor: backgroundColor2)),
                ],
              ),
            ),
          ],
        ));
  }

  void setAlbumPrimaryColor() {
    final image = musicPlayer.getCurrentMusic?.image;
    if (image != null) {
      PaletteGenerator.fromImageProvider(MemoryImage(image))
          .then((PaletteGenerator value) => setState(() => {
                setBackground(
                    value.paletteColors[0].color, value.paletteColors[1].color),
                setForegroundColorFromBackground()
              }));
    }
  }

  void setBackground(Color color1, Color color2) {
    backgroundColor1 = color1;
    backgroundColor2 = color2;
  }

  void setForegroundColorFromBackground() {
    foregroundColor =
        backgroundColor1.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
