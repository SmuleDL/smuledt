#!/usr/bin/env dart
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main(List<String> args) {
  String link = args[0];
  link_parser(link);
}

void link_parser(String link) {
  http.read(link).then((res) {
    var doc = parse(res);
    var media_title = doc.getElementsByTagName("meta")[22].attributes['content'];
    var media_link = doc.getElementsByTagName("meta")[25].attributes['content'].replaceAll('amp;','');
    media_download(media_link, media_title);
  });
}

void media_download(String media_link, String media_title) {
  new HttpClient().getUrl(Uri.parse(media_link))
    .then((HttpClientRequest req) => req.close())
    .then((HttpClientResponse res) {
      res.pipe(new File(media_title).openWrite());
    });
}