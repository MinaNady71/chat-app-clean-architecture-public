import 'dart:ui';

import 'package:chat_app/presentation/resources/languages_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/app_mode_manager.dart';

const String prefsKeyLanguage = "prefs_key_language";
const String prefsKeyOnboarding = "prefs_key_onboarding";
const String prefsKeyAppTheme = "prefs_key_app_theme";
const String prefsKeyIsUserLoggedIn ="prefs_key_is_user_loggedIn";
const String prefsKeyTimeZoneOffset ="prefs_key_time_zone_offset";


class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  String? getLanguage(){
    String? language = _sharedPreferences.getString(prefsKeyLanguage);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.english.getValue();
    }
  }

  Future<void> changeAppLanguage(int index) async {
    String? currentLanguage = getLanguage();
      if(index == 0) {
        if(currentLanguage != LanguageType.english.getValue()) {
          await _sharedPreferences.setString(
            prefsKeyLanguage, LanguageType.english.getValue());
        }
      }else if(index == 1){
        if(currentLanguage != LanguageType.arabic.getValue()) {
          await _sharedPreferences.setString(
              prefsKeyLanguage, LanguageType.arabic.getValue());
        }
      }
  }

  bool? getAppTheme() {
    bool? theme = _sharedPreferences.getBool(prefsKeyAppTheme);
      return theme;
  }

  Future<void> changeAppTheme(int index) async {
    if (index == 0) {
      await _sharedPreferences.setBool(
          prefsKeyAppTheme,ThemeType.dark.getValue());
    } else if (index == 1){
      await _sharedPreferences.setBool(
          prefsKeyAppTheme,ThemeType.light.getValue());
    }else if (index == 2){
      await _sharedPreferences.remove(prefsKeyAppTheme);
    }
  }

  Locale getLocal() {
    String? currentLanguage = getLanguage();
    if (currentLanguage == LanguageType.english.getValue()) {
      return englishLocale;
    } else {
      return arabicLocale;
    }
  }


// Onboarding Screen
  Future<void> setOnboardingViewed() async {
    await _sharedPreferences.setBool(prefsKeyOnboarding,true);
  }

  bool isOnboardingViewed() {
    return _sharedPreferences.getBool(prefsKeyOnboarding) ?? false;
  }

  // login Screen
  Future<void> setUserLoggedInOrRegistered()async{
    _sharedPreferences.setBool(prefsKeyIsUserLoggedIn, true);
  }
  bool istUserLoggedInOrRegistered(){
    return _sharedPreferences.getBool(prefsKeyIsUserLoggedIn)?? false;
  }

  // logout Screen
  Future<void> setUserLogout()async{
    _sharedPreferences.remove(prefsKeyIsUserLoggedIn);
  }

}
