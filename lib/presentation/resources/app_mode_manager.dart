
import 'package:flutter/material.dart';

const bool dark = true;
const bool light = false;

enum ThemeType{
  dark,
  light
}
extension ThemeTypeExtension on ThemeType{
      getValue(){
        switch(this){
          case ThemeType.dark:
            return dark;
          case ThemeType.light:
            return light;
        }
      }
}
bool isDarkMode() {
  final darkMode = WidgetsBinding.instance.window.platformBrightness;
  if (darkMode == Brightness.dark) {
    return ThemeType.dark.getValue();
  } else {
    return ThemeType.light.getValue();
  }
}