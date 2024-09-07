import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/theme.dart';
import 'package:flutter_application_1/utils/shared_preference_util.dart';

final lightGreenTheme = createTheme(Colors.green);

final darkTheme = createTheme(Colors.green, brightness: Brightness.dark);

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData = lightGreenTheme;
  late Brightness _brightness;
  Color _seedColor = Colors.green;
  ThemeNotifier({required Brightness brightness}) {
    _brightness = brightness;
    getMyTheme();
    //_themeData = brightness == Brightness.dark ? darkTheme : lightGreenTheme;
  }

  ThemeData get themeData => _themeData;

  Brightness get brightness => _brightness;
  Color get seedColor => _seedColor;

  void getMyTheme() async{
    int index = await SharedPreferencesManager.instance
        .get<int>(SharedPreferencesKey.theme);
        debugPrint("读取主题${index}");
      toggleTheme(PresetThemes.values[index].color);
  }

  void changeStyle(Brightness brightness) {
    _brightness = brightness;
    toggleTheme(_seedColor);
  }

  void toggleTheme(Color seedColor) {
    _seedColor = seedColor;
    _themeData = createTheme(seedColor, brightness: _brightness);
    notifyListeners();
  }
}

ThemeData createTheme(Color seedColor,
    {Brightness brightness = Brightness.light}) {
  ColorScheme colorScheme =
      ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  return ThemeData(
    colorScheme: colorScheme,
    // 其他主题属性...
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
