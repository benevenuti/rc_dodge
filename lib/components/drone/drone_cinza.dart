import 'package:RC_Dodge/rc_dodge_loop.dart';

import 'drone_base.dart';

class DroneCinza extends DroneBase {

  static final List<String> imagesDroneCinza = [
    "drone/drone_cinza_1.png",
    "drone/drone_cinza_2.png"
  ];

  static final double _speed = 3.5;

  DroneCinza(RCDodgeLoop game, double x, double y, double w, double h) : super.fromImages(game, DroneCinza.imagesDroneCinza, x, y, w, h, _speed);

}