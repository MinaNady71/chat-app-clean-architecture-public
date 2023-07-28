import 'package:chat_app/presentation/resources/styles_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';

ThemeData getApplicationTheme(bool isDarkMode) {
  if (isDarkMode) {
    return ThemeData(
        // main colors
        primaryColor: ColorManager.darkGrey1,
        // primaryColorLight: ColorManager.lightPrimary,
        // primaryColorDark: ColorManager.darkPrimary,
        // disabledColor: ColorManager.grey1,
        // splashColor: ColorManager.lightPrimary,
        // card view
        scaffoldBackgroundColor: ColorManager.scaffoldDarkModeColor,
        iconTheme: IconThemeData(
          color: ColorManager.iconDarkModeColor,
        ),
        dividerColor: ColorManager.grey1,
        // card view
        cardTheme: CardTheme(
            color: ColorManager.white,
            shadowColor: ColorManager.grey,
            elevation: AppSize.s4),
        //appbar theme
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.appBarDarkModeColor,
          elevation: AppSize.s0,
          shadowColor: ColorManager.darkGrey,
          titleTextStyle: getRegularStyle(
            color: ColorManager.white,
            fontSize: FontSize.s16,
          ),
        ),
         // button theme
        buttonTheme: ButtonThemeData(
            shape: const StadiumBorder(),
            disabledColor: ColorManager.grey1,
            buttonColor: ColorManager.iconBackgroundDarkModeColor,
            splashColor: ColorManager.iconBackgroundDarkModeColor),
        //elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                textStyle: getRegularStyle(
                    color: ColorManager.white, fontSize: FontSize.s17),
                backgroundColor: ColorManager.bottomDarkModeColor,
                disabledBackgroundColor:
                    ColorManager.iconBackgroundDarkModeColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s12)))),
        // text theme
        textTheme: TextTheme(
          displayLarge: getSemiBoldStyle(
              color: ColorManager.displayLargeDMColor, fontSize: FontSize.s40),
          displayMedium: getSemiBoldStyle(
              color: ColorManager.displayMediumDMColor, fontSize: FontSize.s25),
          displaySmall: getSemiBoldStyle(
              color: ColorManager.displayLargeDMColor, fontSize: FontSize.s16),
          headlineLarge: getSemiBoldStyle(
              color: ColorManager.darkGrey,fontSize:FontSize.s16),
          headlineMedium: getRegularStyle(
              color: ColorManager.textHeaderDarkModeColor,
              fontSize: FontSize.s14),
          titleMedium: getMediumStyle(
              color: ColorManager.textHeaderDarkModeColor,
              fontSize: FontSize.s16),
          titleSmall: getRegularStyle(
              color: ColorManager.white, fontSize: FontSize.s14),
          bodyLarge: getRegularStyle(color: ColorManager.grey1),
          bodySmall: getRegularStyle(color: ColorManager.textHeaderDarkModeColor),
          bodyMedium:
              getRegularStyle(color: ColorManager.textHeaderDarkModeColor),
          labelSmall: getRegularStyle(
              color: ColorManager.textHeaderDarkModeColor,
              fontSize: AppSize.s12,),
          labelLarge:  getMediumStyle(
            color: ColorManager.white,
            fontSize: AppSize.s14,),
        ),
        //TextBottom
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all(ColorManager.textHeaderDarkModeColor),
        )),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: ColorManager.backGroundBottomSheetDarkModeColor),
        // input decoration theme(text form field)
        inputDecorationTheme: InputDecorationTheme(
          fillColor: ColorManager.backGroundTextFiledDarkModeColor,
          //content padding
          contentPadding: const EdgeInsets.all(AppPadding.p8),
          // hint style
          hintStyle: getRegularStyle(
              color: ColorManager.textHeaderDarkModeColor,
              fontSize: FontSize.s14),
          labelStyle: getMediumStyle(
              color: ColorManager.textHeaderDarkModeColor,
              fontSize: FontSize.s14),
          errorStyle: getRegularStyle(color: ColorManager.error),
          prefixIconColor: ColorManager.iconDarkModeColor,
          suffixIconColor: ColorManager.iconDarkModeColor,

          //enabled border style

          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.grey1, width: AppSize.s1_5),
            borderRadius: BorderRadius.circular(
                AppSize.s8),
          ),
          //focused border
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.grey1, width: AppSize.s1_5),
            borderRadius: BorderRadius.circular(
                AppSize.s8),
          ),
          // error border
          errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: BorderRadius.circular(
                AppSize.s8),
          ),
          // focused border
          focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.white, width: AppSize.s1_5),
            borderRadius: BorderRadius.circular(
                AppSize.s8),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: ColorManager.darkGrey5, width: AppSize.s1_5),
            borderRadius: BorderRadius.circular(
                AppSize.s8),
          ),
        ),
        dialogTheme: DialogTheme(
            contentTextStyle:
                TextStyle(color: ColorManager.textHeaderDarkModeColor),
            titleTextStyle:
                TextStyle(color: ColorManager.textHeaderDarkModeColor),
            backgroundColor: ColorManager.backGroundDialogDarkModeColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ColorManager.iconBackgroundDarkModeColor,
          selectedItemColor: ColorManager.selectedIconDarkModeColor,
          unselectedItemColor: ColorManager.iconDarkModeColor,
        ),

    );













  } else {
    return ThemeData(
      // main colors
      primaryColor: ColorManager.containerLMColor,
      scaffoldBackgroundColor: ColorManager.scaffoldLMColor,
      iconTheme: IconThemeData(
        color: ColorManager.iconLMColor,
      ),
      dividerColor: ColorManager.grey1,
      // card view
      cardTheme: CardTheme(
          color: ColorManager.white,
          shadowColor: ColorManager.grey,
          elevation: AppSize.s4),
      //appbar theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: ColorManager.appBarLMColor,
        elevation: AppSize.s0,
        shadowColor: ColorManager.darkGrey,
        titleTextStyle: getRegularStyle(
          color: ColorManager.textAppBarLMColor,
          fontSize: FontSize.s16,
        ),
      ),
      // button theme
      buttonTheme: ButtonThemeData(
          shape: const StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.iconBackgroundLMColor,
          splashColor: ColorManager.iconBackgroundLMColor),
      //elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(
                  color: ColorManager.white, fontSize: FontSize.s17),
              backgroundColor: ColorManager.bottomLMColor,
              disabledBackgroundColor:
              ColorManager.iconBackgroundLMColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12)))),
      // text theme
      textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(
            color: ColorManager.displayLargeDMColor, fontSize: FontSize.s40),
        displayMedium: getSemiBoldStyle(
            color: ColorManager.displayMediumDMColor, fontSize: FontSize.s25),
        displaySmall: getSemiBoldStyle(
            color: ColorManager.displayLargeDMColor, fontSize: FontSize.s16),
        headlineLarge: getSemiBoldStyle(
            color: ColorManager.darkGrey,fontSize:FontSize.s16),
        headlineMedium: getRegularStyle(
            color: ColorManager.textHeaderLMColor,
            fontSize: FontSize.s14),
        titleMedium: getMediumStyle(
            color: ColorManager.textHeaderLMColor,
            fontSize: FontSize.s16),
        titleSmall: getRegularStyle(
            color: ColorManager.whiteTextLMColor, fontSize: FontSize.s14),
        bodyLarge: getRegularStyle(color: ColorManager.grey1),
        bodySmall: getRegularStyle(color: ColorManager.textHeaderLMColor),
        bodyMedium:
        getRegularStyle(color: ColorManager.textHeaderLMColor),
        labelSmall: getRegularStyle(
          color: ColorManager.whiteTextLMColor,
          fontSize: AppSize.s12,),
        labelLarge:  getMediumStyle(
          color: ColorManager.textHeaderLMColor,
          fontSize: AppSize.s14,),
      ),
      //TextBottom
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all(ColorManager.textHeaderLMColor),
          )),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: ColorManager.backGroundBottomSheetLMColor),
      // input decoration theme(text form field)
      inputDecorationTheme: InputDecorationTheme(
        fillColor: ColorManager.backGroundTextFiledLMColor,
        //content padding
        contentPadding: const EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle: getRegularStyle(
            color: ColorManager.textHeaderLMColor,
            fontSize: FontSize.s14),
        labelStyle: getMediumStyle(
            color: ColorManager.textHeaderLMColor,
            fontSize: FontSize.s14),
        errorStyle: getRegularStyle(color: ColorManager.error),
        prefixIconColor: ColorManager.iconLMColor,
        suffixIconColor: ColorManager.iconLMColor,

        //enabled border style

        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.grey1, width: AppSize.s1_5),
          borderRadius: BorderRadius.circular(
              AppSize.s8),
        ),
        //focused border
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.grey1, width: AppSize.s1_5),
          borderRadius: BorderRadius.circular(
              AppSize.s8),
        ),
        // error border
        errorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.error, width: AppSize.s1_5),
          borderRadius: BorderRadius.circular(
              AppSize.s8),
        ),
        // focused border
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.white, width: AppSize.s1_5),
          borderRadius: BorderRadius.circular(
              AppSize.s8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: ColorManager.darkGrey5, width: AppSize.s1_5),
          borderRadius: BorderRadius.circular(
              AppSize.s8),
        ),
      ),
      dialogTheme: DialogTheme(
          contentTextStyle:
          TextStyle(color: ColorManager.textHeaderLMColor),
          titleTextStyle:
          TextStyle(color: ColorManager.textHeaderLMColor),
          backgroundColor: ColorManager.backGroundDialogLMColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedLabelStyle: TextStyle(color:ColorManager.textHeaderLMColor),
        backgroundColor: ColorManager.iconBackgroundLMColor,
        selectedItemColor: ColorManager.selectedIconLMColor,
        unselectedItemColor: ColorManager.iconLMColor,
      ),

    );
  }
}
