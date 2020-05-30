import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'rc_dodge_loop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.util.fullScreen();
  await Flame.util.setOrientation(DeviceOrientation.landscapeLeft);

  // parallax
  Flame.images.loadAll(<String>[
    'bg/parallax/c1.png',
    'bg/parallax/c2.png',
    'bg/parallax/c3.png',
    'bg/parallax/c4.png',
    'bg/parallax/c5.png',
    'bg/parallax/c6.png',
  ]);

  // drones
  Flame.images.loadAll(<String>[
    'drone/drone_azul_1.png',
    'drone/drone_azul_2.png',
    'drone/drone_branco_1.png',
    'drone/drone_branco_2.png',
    'drone/drone_cinza_1.png',
    'drone/drone_cinza_2.png',
    'drone/drone_roxo_1.png',
    'drone/drone_roxo_2.png',
  ]);

  // fx
  Flame.images.loadAll(<String>['fx/boom3.png', 'fx/zap.png']);

  // audios
  Flame.audio.disableLog();
  Flame.audio.loadAll(<String>[
    'drone_move_bg.mp3',
  ]);

  // game dodge
  SharedPreferences storage = await SharedPreferences.getInstance();
  RCDodgeLoop rcDodgeLoop = RCDodgeLoop(storage);
  runApp(rcDodgeLoop.widget);
}
