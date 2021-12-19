import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'dart:ui';

class WindowPreferenceAdapter extends PreferenceAdapter<Rect> {
  static const instance = WindowPreferenceAdapter._();
  const WindowPreferenceAdapter._();

  @override
  Rect? getValue(SharedPreferences preferences, String key) {
    final left = preferences.getDouble(key + '_left');
    final top = preferences.getDouble(key + '_top');
    final right = preferences.getDouble(key + '_right');
    final bottom = preferences.getDouble(key + '_bottom');
    final scale = preferences.getDouble(key + '_scale');
    if (left == null ||
        top == null ||
        right == null ||
        bottom == null ||
        scale == null) return null;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  Future<bool> setValue(
    SharedPreferences preferences,
    String key,
    Rect value,
  ) {
    return preferences
        .setDouble(key + '_left', value.left)
        .then((_) => preferences.setDouble(key + '_top', value.top))
        .then((_) => preferences.setDouble(key + '_right', value.right))
        .then((_) => preferences.setDouble(key + '_bottom', value.bottom));
  }
}
