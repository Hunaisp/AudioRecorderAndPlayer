import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
class AudioList extends StatefulWidget {
  final path;
  const AudioList({super.key,required this.path});

  @override
  State<AudioList> createState() => _AudioListState();
}

class _AudioListState extends State<AudioList> {

  final audioPlayer=AudioPlayer();
  bool isPlaying=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying=state==PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {setState(() {
      duration=newDuration;
    }); });

    audioPlayer.onPositionChanged.listen((newPosition) { setState(() {
      position=newPosition;
    });});
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [
      Slider(min: 0,max: duration.inSeconds.toDouble(),value: position.inSeconds.toDouble(),onChanged: (value)async{
        final position=Duration(seconds: value.toInt());
        await audioPlayer.seek(position);
        await audioPlayer.resume();
      },),SizedBox(height: 40,),Row(children: [
        // Text(formatTime(position)),Text(formatTime(duration-position))
      ],),IconButton(onPressed: ()async{

        if(isPlaying){
          await audioPlayer.pause();
        }else{
          String url=widget.path;
          audioPlayer.play(UrlSource(url));
        }

      }, icon:Icon(isPlaying?Icons.pause:Icons.play_arrow))
    ],),);
  }
}
