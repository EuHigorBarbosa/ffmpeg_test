import 'package:flutter/cupertino.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_music/common/constants.dart';
import 'package:image_music/common/localStorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;

class MergeProvider with ChangeNotifier {
  bool loading = false, isPlaying = false;
  dynamic limit = 10;
  late double startTime = 0, endTime = 10;

  ///data/user/0/com.yt.image_music/files

  String VIDEO_PATH = '';
  String AUDIO_PATH = '';
  String AUDIO_PATH2 = '';
  String AUDIO_PATH3 = '';
  String AUDIO_OUTPUT = '';
  String OUTPUT_PATH = '';
  String IMAGE_PATH = '';
  String mainPath = '';

  void setTimeLimit(dynamic value) async {
    limit = value;
    notifyListeners();
  }

  Future<void> saveInFolder() async {
    AUDIO_PATH =
        await LocalStorage().saveFileFromAssets('audio.mp3', 'audio.mp3');
    AUDIO_PATH2 = await LocalStorage()
        .saveFileFromAssets('nasa_on_a_mission.mp3', 'nasa_on_a_mission.mp3');
    AUDIO_PATH3 = await LocalStorage().saveFileFromAssets('moo.mp3', 'moo.mp3');
    VIDEO_PATH =
        await LocalStorage().saveFileFromAssets('video.mp4', 'video.mp4');

    OUTPUT_PATH = await LocalStorage().getInternalDirectory() + '/output.mp4';
    AUDIO_OUTPUT =
        await LocalStorage().getInternalDirectory() + '/audio_output.mp3';

    IMAGE_PATH = await LocalStorage()
        .saveFileFromAssets('bg_image.jpeg', 'bg_image.jpeg');
    mainPath = await LocalStorage().getInternalDirectory();
    notifyListeners();
  }

  Future<void> mergeIntoVideo() async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    String timeLimit = '00:00:';
    notifyListeners();

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10)
        timeLimit = timeLimit + '0' + limit.toString();
      else
        timeLimit = timeLimit + limit.toString();

      /// To combine audio with video
      ///
      /// Merging video and audio, with audio re-encoding
      /// -c:v copy -c:a aac
      ///
      /// Copying the audio without re-encoding
      /// -c copy
      ///
      /// Replacing audio stream
      /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0
      String commandToExecute =
          '-r 15 -f mp4 -i ${VIDEO_PATH} -f mp3 -i ${AUDIO_PATH} -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -t $timeLimit -y ${OUTPUT_PATH}';

      /// To combine audio with image
      // String commandToExecute =
      //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with gif
      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      /// To combine audio with sequence of images
      // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
      //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      await _flutterFFmpeg.execute(commandToExecute).then((rc) {
        loading = false;
        notifyListeners();
        dev.log('MERGE NO VIDEO FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      notifyListeners();
      openAppSettings();
    }
  }

  Future<void> concatenateAudio() async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    loading = true;
    String timeLimit = '00:00:';
    notifyListeners();

    if (await Permission.storage.request().isGranted) {
      if (limit.toInt() < 10)
        timeLimit = timeLimit + '0' + limit.toString();
      else
        timeLimit = timeLimit + limit.toString();

      /// To combine audio with video
      ///
      /// Merging video and audio, with audio re-encoding
      /// -c:v copy -c:a aac
      ///
      /// Copying the audio without re-encoding
      /// -c copy
      ///
      /// Replacing audio stream
      /// -c:v copy -c:a aac -map 0:v:0 -map 1:a:0

      /// copia até o 16s partindo do 2s
      // String commandToExecute =
      //     ' -i ${AUDIO_PATH} -ss 2 -to 16 -c copy ${AUDIO_OUTPUT}';

      /// Concatena audios
      String commandToExecute =
          ' -i concat:${AUDIO_PATH3}|${AUDIO_PATH3}|${AUDIO_PATH3} -acodec copy ${AUDIO_OUTPUT}';

      /// To combine audio with image
      // String commandToExecute =
      //     '-r 15 -f mp3 -i ${Constants.AUDIO_PATH} -f image2 -i ${Constants.IMAGE_PATH} -pix_fmt yuv420p -t $timeLimit -y ${Constants.OUTPUT_PATH}';

      /// To combine audio with gif
      // String commandToExecute = '-r 15 -f mp3 -i ${Constants
      //     .AUDIO_PATH} -f gif -re -stream_loop 5 -i ${Constants.GIF_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      /// To combine audio with sequence of images
      // String commandToExecute = '-r 30 -pattern_type sequence -start_number 01 -f image2 -i ${Constants
      //     .IMAGES_PATH} -f mp3 -i ${Constants.AUDIO_PATH} -y ${Constants
      //     .OUTPUT_PATH}';

      await _flutterFFmpeg.executeWithArguments([
        '-i',
        'concat:${AUDIO_PATH3}|${AUDIO_PATH3}|${AUDIO_PATH2}',
        '-acodec',
        'copy',
        '${AUDIO_OUTPUT}'
      ]).then((rc) {
        loading = false;
        notifyListeners();
        dev.log('CONCATENATE ON AUDIOS FFmpeg process exited with rc: $rc');
        ;

        // await _flutterFFmpeg.execute(commandToExecute).then((rc) {
        //   loading = false;
        //   notifyListeners();
        //   dev.log('CONCATENATE ON AUDIOS FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      notifyListeners();
      openAppSettings();
    }
  }
}
