import 'package:RC_Dodge/rc_dodge_loop.dart';
import 'drone_base.dart';

class DroneAzul extends DroneBase {

  static final List<String> imagesDroneAzul = [
    "drone/drone_azul_1.png",
    "drone/drone_azul_2.png"
  ];

  static final double _speed = null;

  DroneAzul(RCDodgeLoop game, double x, double y, double w, double h) : super.fromImages(game, DroneAzul.imagesDroneAzul, x, y, w, h, _speed);

}