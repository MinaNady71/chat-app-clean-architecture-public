import 'package:bloc/bloc.dart';
import 'package:chat_app/app/app_prefs.dart';
import 'package:flutter/material.dart';

import '../di.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());
  final AppPreferences _appPreferences =instance<AppPreferences>();
 late bool? isDark = _appPreferences.getAppTheme();
  
  getAppTheme(){
    isDark = _appPreferences.getAppTheme();
    emit(GetAppThemeState());
  }
  changeAppTheme(int index)async{
    await _appPreferences.changeAppTheme(index);
    getAppTheme();
    emit(ChangeAppThemeState());
  }
}
