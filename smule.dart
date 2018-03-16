#!/usr/bin/env dart
import 'dart:async';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'Collab.dart';

void main(List<String> args) {

  load(); // load env

  String link = args[0];
  linkParser(link);
}

Collab collabParser(doc) {
  List<Element> metas = doc.getElementsByTagName("meta");
  Collab collab = new Collab();
  //TODO: Refactor this later
  metas.forEach((meta) {
    if(meta.attributes['name'] == "twitter:player:stream") collab.url = meta.attributes['content'].replaceAll('amp;','');
    if(meta.attributes['name'] == "twitter:description") collab.description = meta.attributes['content'].replaceAll('/', ' ').split("on Sing")[0].trim();
    if(meta.attributes['name'] == "twitter:image:src") collab.imageUrl = meta.attributes['content'];
  });
  return collab;
}

linkParser(String link) async {
  print("Parsing the link");
  http.read(link).then((res) {
    var doc = parse(res);
    var collab = collabParser(doc);
    var collabUrl = collab.url;
    var collabDesc = collab.description;
    var collabImg = collab.imageUrl;
    print("Downloading...");
    //mediaDownloader(collabUrl, collabDesc);
    getMedia(collabUrl, collabDesc);
  });
}

@deprecated
Future mediaDownloader(String link, title) async {
  try {
    HttpClientRequest client = await new HttpClient().getUrl(Uri.parse(link));
    HttpClientResponse res = await client.close();
    File file = new File(title);
    Future writing = await res.pipe(file.openWrite());
  } catch (Exception) {
    // later
  }
}

void getMedia(String link, String title) {
  var data = http.readBytes(link);
  data.then((buffer) {
    // TODO: Check if folder exists
    File file = new File("${env['DL_DEFAULT']}/$title.mp4");
    RandomAccessFile rf = file.openSync(mode: FileMode.WRITE);
    rf.writeFromSync(buffer);
    rf.flushSync();
    rf.closeSync();
    print("Downloaded!");
  });
}