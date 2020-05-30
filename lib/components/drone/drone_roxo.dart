import 'package:RC_Dodge/rc_dodge_loop.dart';

import 'drone_base.dart';

class DroneRoxo extends DroneBase {

  static final List<String> imagesDroneRoxo = [
    "drone/drone_roxo_1.png",
    "drone/drone_roxo_2.png"
  ];

  static final double _speed = 3;

  DroneRoxo(RCDodgeLoop game,  double x, double y, double w, double h) : super.fromImages(game, DroneRoxo.imagesDroneRoxo, x, y, w, h, _speed);

}