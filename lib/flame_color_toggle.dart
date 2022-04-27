library flame_color_toggle;

import 'dart:ui';
import 'package:flame/effects.dart';

class ColorEffectToggle extends ColorEffect {
  bool fadingIn = false;
  double duration;
  late SequenceEffectController sequence;
  ColorEffectToggle(color, offset, this.duration, parent,
      {String? paintId, start = false, add = true})
      : super(
            color,
            offset,
            EffectController(
                duration: duration, alternate: true, infinite: true),
            paintId: paintId) {
    if (!start) {
      pause();
    }
    if (add) {
      parent.add(this);
    }
    sequence = (controller as InfiniteEffectController).child
        as SequenceEffectController;
  }
  void toggle() {
    fadingIn = !fadingIn;
    if (isPaused) {
      resume();
    } else {
      pause();
      if (previousProgress <= .01) {
        reset();
        pause();
        return;
      }
      sequence.advance(2 * duration * (1 - previousProgress));
      resume();
    }
  }

  @override
  void render(Canvas canvas) {
    if (!isPaused &&
        (fadingIn
            ? (controller.progress + .01 >= 1)
            : (controller.progress - .01 <= 0))) {
      pause();
      apply(fadingIn ? 1 : 0);
    }
    super.render(canvas);
  }
}
