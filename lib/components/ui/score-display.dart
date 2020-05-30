import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/painting.dart';

import '../../rc_dodge_loop.dart';
import '../../view_enum.dart';


class ScoreDisplay extends Component {
  final RCDodgeLoop game;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xFFFFFFFF,),
      fontSize: 50,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas canvas) {
    if (this.game.activeView == ViewEnum.playing) {
      painter.paint(canvas, position);
    }
  }

  void update(double t) {
    if ((painter.text?.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.size.width / 2) - (painter.width / 2),
        0,
      );
    }
  }
}
