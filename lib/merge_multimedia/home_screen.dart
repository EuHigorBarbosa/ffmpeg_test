import 'dart:io';

import 'package:image_music/merge_multimedia/providers/merge_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_music/common/color_palette.dart';
import 'package:image_music/merge_multimedia/video.dart';
import 'package:image_music/sound_player.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = SoundPlayer();
  @override
  void initState() {
    player.init();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Flutter Learning'),
                  centerTitle: true,
                  backgroundColor: Palette.primary,
                ),
                body: Consumer<MergeProvider>(
                  builder: (context, prov, _) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoShower(
                                              pathVideo: prov.OUTPUT_PATH,
                                            )),
                                  ),
                              icon: Icon(Icons.dock)),
                          prov.loading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                        color: Palette.primary),
                                    SizedBox(width: 15),
                                    Text('Processing...',
                                        style: TextStyle(color: Colors.black))
                                  ],
                                )
                              : Container(),
                          Image.file(
                            File(prov.IMAGE_PATH),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: MaterialButton(
                              onPressed: () async {
                                await prov.saveInFolder();
                                await prov.mergeIntoVideo();
                                await prov.concatenateAudio();
                                // if (!prov.loading) _showAlertDialog(context, prov);
                              },
                              child: Text('Merge',
                                  style: TextStyle(color: Palette.tertiary)),
                              color: Palette.primary,
                              splashColor: Palette.secondary,
                            ),
                          ),
                          SizedBox(height: 15),
                          Center(
                            child: SfSlider(
                              min: 5,
                              max: 15,
                              stepSize: 5,
                              activeColor: Palette.primary,
                              inactiveColor: Palette.secondary,
                              value: prov.limit,
                              interval: 5,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              minorTicksPerInterval: 1,
                              onChanged: (dynamic value) {
                                prov.setTimeLimit(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.ac_unit_outlined),
                            onPressed: () => player.togglePlaying(
                                path: prov.AUDIO_OUTPUT, whenFinished: () {}),
                          )
                        ],
                      ),
                    );
                  },
                ));
          }
          return Container();
        });
  }
}
