import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/painting.dart';

import '../../rc_dodge_loop.dart';

class HighscoreDisplay extends Component {
  final RCDodgeLoop game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  HighscoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    Shadow shadow = Shadow(
      blurRadius: 3,
      color: Color(0xff000000),
      offset: Offset.zero,
    );

    textStyle = TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 16,
      shadows: [shadow, shadow, shadow, shadow],
    );

    position = Offset.zero;

    updateHighscore();
  }

  void updateHighscore() {
    int highscore = game.storage.getInt('highscore') ?? 0;

    painter.text = TextSpan(
      text: 'High-score: ' + highscore.toString(),
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      game.size.width - (game.tileSize * .10) - painter.width,
      game.tileSize * .10,
    );
  }

  @override
  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }

  @override
  void update(double t) {

  }
}
