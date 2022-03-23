import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_music/merge_multimedia/videoPlayerWidget.dart';
import 'package:video_player/video_player.dart';

class VideoShower extends StatefulWidget {
  VideoShower({required this.pathVideo, Key? key}) : super(key: key);
  String pathVideo;

  @override
  State<VideoShower> createState() => _VideoShowerState();
}

class _VideoShowerState extends State<VideoShower> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(File(widget.pathVideo))
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(
      controller: controller,
    );
  }
}
