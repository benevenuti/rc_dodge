import '../../rc_dodge_loop.dart';
import 'drone_base.dart';

class DroneBranco extends DroneBase {

  static final List<String> imagesDroneBranco = [
    "drone/drone_branco_1.png",
    "drone/drone_branco_2.png"
  ];

  static final double _speed = 2.5;

  DroneBranco(RCDodgeLoop game, double x, double y, double w, double h) : super.fromImages(game, DroneBranco.imagesDroneBranco, x, y, w, h, _speed);

}