//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_sound_web/flutter_sound_web.dart';
import 'package:flutter_tts/flutter_tts_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FlutterSoundPlugin.registerWith(registrar);
  FlutterTtsPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}