import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/particle.dart';
import 'package:flame/particles/animation_particle.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';

import '../../rc_dodge_loop.dart';
import '../../view_enum.dart';

class DroneBase extends Component {
  RCDodgeLoop game;

  List<Sprite> _sprites = [];
  double _stepTime = .025;
  List<String> _images = [];
  bool isLoaded = false;

  Animation _droneAnimation;

  AnimationComponent anim;

  double angleObjective = 0;
  bool isEnemy = true;
  double speed = 3;

  DroneBase.empty();

  DroneBase.fromImages(this.game, this._images, x, y, w, h, this.speed) {
    // gera uma lista de sprites com base do nome da imagem
    _sprites.addAll(_images.map((image) => Sprite(image)));

    // gera um animation dos sprites
    _droneAnimation = Animation.spriteList(_sprites, stepTime: _stepTime);

    // parametriza o componente
    this.anim = AnimationComponent(w, h, _droneAnimation);
    this.anim.x = x;
    this.anim.y = y;
    this.anim.onMount();
    this.isLoaded = true;
  }

  @override
  bool loaded() {
    return isLoaded;
  }

  getRect() {
    if (!loaded()) return;
    this.anim.toRect();
  }

  // calcula o angulo da animação para deixar mais real o movto do drone
  void angleChanged(double direction) {
    if (!loaded()) return;
    print("Direction $direction");

    // lógica do flame do direction
    double front = 0;
    double up = -pi / 2;
    double back = pi;
    double down = pi / 2;

    bool movDireita = (direction > up && direction < front) ||
        (direction >= front && direction <= down);
    bool movEsquerda = (direction < up && direction > -pi) ||
        (direction > down && direction <= back);

    if (movDireita) {
      this.angleObjective = pi / 8;
    } else if (movEsquerda) {
      this.angleObjective = -pi / 8;
    } else {
      this.angleObjective = pi / 32;
    }
  }

  // para o player
  void onPanUpdate(DragUpdateDetails details) {
    if (!loaded()) return;
    if (this.game.activeView == ViewEnum.playing) {
      //angleChanged(details.delta.direction);
      this.anim.setByRect(
          this.anim.toRect().translate(details.delta.dx, details.delta.dy));
      checkPlayerIsOut();
    }
  }

  void update(double time) {
    if (!loaded()) return;
    this.angleUpdate(time);
    this.anim.update(time);

    // xObjective == null é player
    // xObjective == <= 0 é inimigo
    if (isEnemy) {
      xUpdate(time);
    } else {
      colliderCheck();
    }
  }

  void colliderCheck() {
    if (!loaded()) return;
    game.enemies.forEach((_drn) {
      Rect e = _drn.anim.toRect();
      Rect p = this.anim.toRect();
      if (e.overlaps(p)) {
        game.gameOver();
      }
    });
  }

  // para inimigos, calcula o rect fazendo andar para esquerda
  void xUpdate(double time) {
    double xAmount = this.anim.width * speed * time * -1;
    this.anim.setByRect(this.anim.toRect().translate(xAmount, 0));
    checkEnemyIsOut();
  }

  // verifica se o drone inimigo saiu da tela à esquerda
  void checkEnemyIsOut() {
    if (this.anim.x < this.anim.width * -1) {
      if (this.game.activeView == ViewEnum.playing) {
        scoreRegister();
      }
      restartEnemy();
    }
  }

  void scoreRegister() {
    this.game.score += 1;
    this.game.highscoreDisplay.updateHighscore();

    if (game.score > (game.storage.getInt('highscore') ?? 0)) {
      this.game.storage.setInt('highscore', game.score);
      this.game.highscoreDisplay.updateHighscore();
    }
  }

  checkPlayerIsOut() {
    if (this.anim.x <
                this.anim.width /
                    -2 || // saiu mais da metade do drone na esquerda
            this.anim.x >
                this.game.size.width +
                    (this.anim.width /
                        2) || // saiu mais da metade do drone na direita
            this.anim.y <
                this.anim.height / -2 || // saiu mais da metade do drone acima
            this.anim.y >
                this.game.size.height +
                    (this.anim.height /
                        2) // saiu mais da metade do drone abaixo
        ) {
      this.game.gameOver();
    }
  }

  // posiciona um novo drone em random Y, fora da tela à direita
  void restartEnemy() {
    this.anim.x = this.game.size.width;
    this.anim.y = this.game.getRandomY();
  }

  // troca o angulo do animation component
  void angleUpdate(double time) {
    if (this.anim.angle != this.angleObjective) {
      if (this.anim.angle > this.angleObjective) {
        this.anim.angle += time * 1.5;
      } else if (this.anim.angle < this.angleObjective) {
        this.anim.angle -= time * 1.5;
      }
    }
  }

  void render(Canvas canvas) {
    if (!loaded()) return;
    if (this.isEnemy || this.game.activeView == ViewEnum.playing) {
      this.anim.render(canvas);
    }
  }

  void resize(Size size) {
    if (!loaded()) return;
    this.anim.resize(size);
  }

}
