import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import 'audiolist.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
dynamic audioFile;
dynamic path;
class _HomeState extends State<Home> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recorder.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            StreamBuilder<RecordingDisposition>(
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                String twoDigits(int n) => n.toString().padLeft(10);
                final twoDigitMinutes =
                    twoDigits(duration.inMinutes.remainder(60));
                final twoDigitSeconds =
                    twoDigits(duration.inSeconds.remainder(60));
                return Text('$twoDigitMinutes:$twoDigitSeconds');
              },
              stream: recorder.onProgress,
            ),
            IconButton(
                onPressed: () async {
                  if (recorder.isRecording) {
                    await stop();
                  } else {
                    await record();
                  }
                  setState(() {});
                },
                icon: Icon(recorder.isRecording ? Icons.pause : Icons.mic)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AudioList(
                            path: path,
                          )));
                },
                child: Text('Next'))
          ],
        ),
      ),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
     path = await recorder.stopRecorder();
     audioFile = File(path!);
    print('Recorded audio:$audioFile');
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'micro phone permission not granted';
    }
    await recorder.openRecorder();
    isRecorderReady = true;
  }
}
