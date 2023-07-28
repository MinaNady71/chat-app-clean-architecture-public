import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';

import 'constants.dart';

String? isEmailValid(String? email) {
  if (RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email!)) {
    return null;
  } else if (email.isEmpty) {
    return AppStrings.pleaseEnterYourEmail.tr();
  } else {
    return AppStrings.emailInvalid.tr();
  }
}

String? isPasswordValid(String? password) {
  if (password!.isEmpty) {
    return AppStrings.passwordError.tr();
  } else if (password.length < 8) {
    return AppStrings.passwordInvalid.tr();
  } else {
    return null;
  }
}

String? isUsernameValid(String? username) {
  if (username!.isEmpty) {
    return AppStrings.usernameError.tr();
  } else if (username.length < 8) {
    return AppStrings.usernameInvalid.tr();
  } else {
    return null;
  }
}

String? isMobileNumberValid(String? mobileNumber) {
  if (mobileNumber!.isEmpty) {
    return AppStrings.mobileNumber.tr();
  } else if (mobileNumber.length < 8) {
    return AppStrings.usernameInvalid.tr();
  } else {
    return null;
  }
}

String? confirmPasswordValidate(String? confirmPassword, String? password) {
  if (password != confirmPassword) {
    return AppStrings.confirmPasswordError.tr();
  } else {
    return null;
  }
}

String showTimeHM(int value) {
 return DateFormat('h:mma').format(DateTime.fromMillisecondsSinceEpoch(value).toLocal()).toString();
}

String showDateMessage(int value) {
  if ((DateFormat.d().format(DateTime.fromMillisecondsSinceEpoch(value).add(DateTime.now().timeZoneOffset))).toString() == DateTime.now().day.toString()) {
    return AppStrings.today.tr();
  }
  if (DateFormat.d().format(DateTime.fromMillisecondsSinceEpoch(value).add(DateTime.now().timeZoneOffset)).toString() == (DateTime.now().day -1).toString()) {
    return AppStrings.yesterday.tr();
  } else {
    return DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(value).add(DateTime.now().timeZoneOffset));
  }
}

void unFocusKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

String showFirstAndSecondName(String string) {
  var splitString = string.split(' ');
  String joinString =Constants.empty;
  if(splitString.length > 1) {
     joinString = '${splitString.first} ${splitString[1]}';
  }else{
     joinString = splitString.first;
  }
  return joinString;
}


late Duration ntpTimeZoneOffset;
Future<void> ntpOffset()async {
  try{
    DateTime ntp = await NTP.now(timeout:const Duration(seconds: Constants.ntpTimeout));
    ntpTimeZoneOffset = ntp.toUtc().difference(DateTime.now().toUtc());
  }catch(_){
    ntpTimeZoneOffset = DateTime.now().toUtc().timeZoneOffset;
  }
}