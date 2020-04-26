import 'dart:async';
import 'dart:io';

//import 'package:dart_console/dart_console.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart' as http;

// Initialize the YoutubeExplode instance.
final YoutubeExplode yt = YoutubeExplode();

//final console = Console();

Future<void> main() async {
  portal();
}

Future<void> portal() async {
  print('Type the video id or url: ');

  var url =
      'https://www.youtube.com/watch?v=52nfjRzIaj8'; //stdin.readLineSync().trim();
  print(url);
  // Get the video url.
  var id = YoutubeExplode.parseVideoId(url);
  print(id);
  if (id == null) {
    print('Invalid video id or url.');
    exit(1);
  }

  // Save the video to the download directory.
  Directory('downloads').createSync();
  //console.hideCursor();

  // Download the video.
  await download(id);
  print('se descargo');
  yt.close();
  //console.showCursor();
  exit(0);
}

Future<void> download(String id) async {
  // Get the video media stream.
  var mediaStream = await yt.getVideoMediaStream(id);

  // Get the last audio track (the one with the highest bitrate).
  //var audio = mediaStream.audio.last;
  var muxed = mediaStream.muxed.last;

  // Compose the file name removing the unallowed characters in windows.
  var fileName =
      '${mediaStream.videoDetails.title}.${muxed.container.toString()}'
          .replaceAll('Container.', '')
          .replaceAll(r'\', '')
          .replaceAll('/', '')
          .replaceAll('*', '')
          .replaceAll('?', '')
          .replaceAll('"', '')
          .replaceAll('<', '')
          .replaceAll('>', '')
          .replaceAll('|', '');
  var file = File('downloads/$fileName');

  // Create the StreamedRequest to track the download status.
  var req = http.Request('get', muxed.url);
  var resp = await req.send();

  // Open the file in appendMode.
  var output = file.openWrite(mode: FileMode.writeOnlyAppend);
  // Track the file download status.
  var len = resp.contentLength;
  var count = 0;
  var oldProgress = -1;

  // Create the message and set the cursor position.
  var msg = 'Downloading `${mediaStream.videoDetails.title}`:  \n';
  //var row = console.cursorPosition.row;
  //var col = msg.length - 2;
  //console.cursorPosition = Coordinate(row, 0);
  print(msg);

  // Listen for data received.
  return resp.stream.listen((data) {
    count += data.length;
    var progress = ((count / len) * 100).round();
    if (progress != oldProgress) {
      //console.cursorPosition = Coordinate(row, col);
      print('$progress%');
      oldProgress = progress;
    }
    output.add(data);
  }, onDone: () async {
    await output.close();
  }).asFuture();
}
