import 'dart:math';
import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/particle.dart';
import 'package:flame/particles/animation_particle.dart';
import 'package:flame/particles/translated_particle.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/background.dart';
import 'components/drone/drone_azul.dart';
import 'components/drone/drone_base.dart';
import 'components/drone/drone_branco.dart';
import 'components/drone/drone_cinza.dart';
import 'components/drone/drone_roxo.dart';
import 'components/ui/highscore-display.dart';
import 'components/ui/score-display.dart';
import 'components/view/game_over_view.dart';
import 'components/view/home_view.dart';
import 'view_enum.dart';

//https://pub.dev/packages/flame
class RCDodgeLoop extends BaseGame with MultiTouchDragDetector {
  final SharedPreferences storage;

  // view ativa
  ViewEnum activeView = ViewEnum.home;

  // componentes personalizados
  Background background;
  double dronesWidth;
  double dronesHeight;
  DroneBase player;

  List<DroneBase> enemies;

  // ui
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;

  // views
  HomeView homeView;
  GameOverView gameOverView;

  // uteis
  Random rnd;
  double tileSize;
  bool allLoaded = false;
  int score;

  //
  List<Sprite> enemySprite;

  Rect enemyRect;

  // Future<AudioPlayer> bgm;

  RCDodgeLoop(this.storage) {
    initialize();
  }

  void initialize() async {
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    tileSize = size.width / 9;

    dronesWidth = tileSize * 1.3;
    dronesHeight = tileSize / 3 * 1.3;

    initBack();

    initPlayer();

    initEnemies();

    initViews();

    // bgm = Flame.audio.loop('drone_move_bg.mp3', volume: 0.25);
    score = 0;
    allLoaded = true;
  }

  void initViews() {
    gameOverView = GameOverView(this);
    add(gameOverView);
    homeView = HomeView(this);
    add(homeView);
  }

  void initBack() {
    background = Background();
    add(background);
    scoreDisplay = ScoreDisplay(this);
    add(scoreDisplay);
    highscoreDisplay = HighscoreDisplay(this);
    add(highscoreDisplay);

    // adiciona no BaseGame
  }

  void initPlayer() {
    double x = tileSize;
    double y = size.height / 2;
    player = DroneAzul(this, x, y, dronesWidth, dronesHeight);
    player.isEnemy = false;

    // adiciona no BaseGame
    add(player);
  }

  void initEnemies() {
    enemies = [];
    double y = getRandomY();
    enemies.add(DroneBranco(this, size.width, y, dronesWidth, dronesHeight));

    y = getRandomY();
    enemies.add(DroneCinza(this, size.width, y, dronesWidth, dronesHeight));

    y = getRandomY();
    enemies.add(DroneRoxo(this, size.width, y, dronesWidth, dronesHeight));

    // adiciona no BaseGame
    enemies.forEach((enemy) {
      add(enemy);
    });
  }

  @override
  void onTapCancel(int pointerId) {
    print("onTapCancel");
    super.onTapCancel(pointerId);
  }

  @override
  void onReceiveDrag(DragEvent drag) {
    print("drag");
    onPanStart(drag.initialPosition);

    // mapeamento do drag
    drag
      ..onUpdate = onPanUpdate
      ..onEnd = onPanEnd
      ..onCancel = onPanCancel;
  }

  void onPanCancel() {
    //print("onPanCancel");
  }

  void onPanStart(Offset position) {
    //print("onPanStart");
  }

  void onPanUpdate(details) {
    player.onPanUpdate(details);
  }

  void onPanEnd(details) {
    //print("onPanEnd");
  }

  @override
  void resize(Size size) {
    tileSize = size.width / 9;
    super.resize(size);
  }

  @override
  void onTapDown(int pointerId, TapDownDetails details) {
    print("onTapDown");
    if (this.activeView != ViewEnum.playing) {
      restartGame();
    }
    super.onTapDown(pointerId, details);
  }

  @override
  void onTapUp(int pointerId, TapUpDetails details) {
    print("onTapUp");
    super.onTapUp(pointerId, details);
  }

  double getRandomY() {
    return rnd.nextDouble() * (size.height - (tileSize / 2) );
  }

  void gameOver() {
    add(getExplosion());
    this.player.anim.x = -dronesWidth;
    this.player.anim.y = -dronesHeight;

    this.activeView = ViewEnum.gameOver;
  }

  void restartGame() {
    score = 0;

    player.anim.x = tileSize;
    player.anim.y = size.height / 2;

    enemies.forEach((enemy) {
      enemy.anim.x = size.width + tileSize;
      enemy.anim.y = getRandomY();
    });
    this.activeView = ViewEnum.playing;
  }


  /// Sample "explosion" animation for [AnimationParticle] example
  Animation getBoomAnimation() {
    const columns = 8;
    const rows = 8;
    const frames = columns * rows;
    const imagePath = 'fx/boom3.png';
    final spriteImage = Flame.images.loadedFiles[imagePath];
    final spritesheet = SpriteSheet(
      rows: rows,
      columns: columns,
      imageName: imagePath,
      textureWidth: spriteImage.width ~/ columns,
      textureHeight: spriteImage.height ~/ rows,
    );
    final sprites = List<Sprite>.generate(
      frames,
          (i) => spritesheet.getSprite(i ~/ rows, i % columns),
    );

    return Animation.spriteList(sprites, stepTime: 0.001);
  }

  /// An [AnimationParticle] takes a Flame [Animation]
  /// and plays it during the particle lifespan.
  Particle animationParticle() {
    return AnimationParticle(
      animation: getBoomAnimation(),
      size: Position(dronesWidth, dronesWidth),
      lifespan: 1,

    );
  }

  ///
  Component getExplosion() {
    return TranslatedParticle(
      lifespan: 1,
      offset: Offset(this.player.anim.x, this.player.anim.y),
      child: animationParticle(),
    ).asComponent();
  }
}
