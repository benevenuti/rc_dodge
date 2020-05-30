import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/parallax_component.dart';

class Background extends Component {
  List<ParallaxComponent> parallaxers = [];
  //bool loaded = false;

  Background() {
    // céu e montanhas
    final img1 = [
      ParallaxImage("bg/parallax/c1.png"),
      ParallaxImage("bg/parallax/c2.png"),
      ParallaxImage("bg/parallax/c3.png"),
    ];

    // casas, árvores e rua
    final img2 = [
      ParallaxImage("bg/parallax/c4.png"),
      ParallaxImage("bg/parallax/c5.png"),
      ParallaxImage("bg/parallax/c6.png"),
    ];

    // 3 camadas de fundo mais lentas
    parallaxers.add(ParallaxComponent(img1,
        baseSpeed: Offset(5, 0), layerDelta: Offset(5, 0)));

    // 3 camadas de frente mais rápidas
    parallaxers.add(ParallaxComponent(img2,
        baseSpeed: Offset(20, 0), layerDelta: Offset(10, 0)));

    // inicializa cada item da lista
    parallaxers.forEach((element) {
      element.onMount();
    });

  }

  void render(Canvas canvas) {
    // aplica o render em cada elemento
    parallaxers.forEach((element) {
      if (element.loaded()) {
        element.render(canvas);
      }
    });
  }

  void update(double time) {
    // aplica o update em cada elemento
    parallaxers.forEach((element) {
        element.update(time);
    });
  }

  void resize(Size size) {
    // aplica o update em cada elemento
    parallaxers.forEach((element) {
      element.resize(size);
    });
  }

}
