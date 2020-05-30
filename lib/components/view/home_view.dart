import 'dart:ui';

import 'package:RC_Dodge/view_enum.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/painting.dart';

import '../../rc_dodge_loop.dart';

class HomeView extends Component {
  final RCDodgeLoop game;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  HomeView(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xFF155C8B),
      fontSize: 90,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    //position = Offset.zero;

    painter.text = TextSpan(
      text: 'RC Drone Game',
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (game.size.width / 2) - (painter.width / 2),
      (game.size.height / 2) - (painter.height / 2),
    );
  }

  @override
  void render(Canvas canvas) {
    if (this.game.activeView == ViewEnum.home) {
      painter.paint(canvas, position);
    }
  }

  @override
  void update(double t) {
  }
}
