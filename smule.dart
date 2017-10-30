#!/usr/bin/env dart
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main(List<String> args) {
  String link = args[0];
  linkParser(link);
}

void linkParser(String link) {
  http.read(link).then((res) {
    var doc = parse(res);
    var mediaTitle = doc.getElementsByTagName("meta")[22].attributes['content'];
    var mediaLink = doc.getElementsByTagName("meta")[25].attributes['content'].replaceAll('amp;','');
    mediaDownloader(mediaLink, mediaTitle);
  });
}

void mediaDownloader(String media_link, String mediaTitle) {
  new HttpClient().getUrl(Uri.parse(media_link))
    .then((HttpClientRequest req) => req.close())
    .then((HttpClientResponse res) {
      res.pipe(new File(mediaTitle).openWrite());
    });
}