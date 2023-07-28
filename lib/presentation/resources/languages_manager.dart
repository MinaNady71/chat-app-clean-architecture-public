


import 'package:flutter/material.dart';

const String english = 'en';
const String arabic = 'ar';
const String assetsPathLocalization = 'assets/translations';
const Locale englishLocale = Locale('en','US');
const Locale arabicLocale = Locale('ar','EG');

enum LanguageType{
  english,
  arabic
}
extension LanguageTypeExtension on LanguageType{
      getValue(){
        switch(this){
          case LanguageType.english:
            return english;
          case LanguageType.arabic:
            return arabic;
        }
      }
}


