
import 'package:chat_app/data/network/failure.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../presentation/resources/strings_manager.dart';

class ErrorHandler implements Exception{
  late Failure failure;
  ErrorHandler.handle(dynamic error){
    if(error is FirebaseAuthException){
    // error response OF THE Firebase
    failure = _handleError(error);
    }else{
      //default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }

}

Failure _handleError(FirebaseException firebaseError){
  switch(firebaseError.code){
    case ResponseCode.USERNOTFOUND :
      return  DataSource.INCORRECTUSERNAME.getFailure();
    case ResponseCode.EMAILFOUND:
      return DataSource.EMAILALREADYINUSE.getFailure();
    case ResponseCode.WRONGPASSWORD:
      return  DataSource.INCORRECTPASSWORD.getFailure();
    default:
      return  DataSource.DEFAULT.getFailure();
  }

}

enum DataSource {
  INCORRECTUSERNAME,
  INCORRECTPASSWORD,
  EMAILALREADYINUSE,
  DEFAULT,
  NO_INTERNET_CONNECTION,

}


extension DataSourceExtension on DataSource{
 Failure getFailure(){
    switch(this){
      case DataSource.INCORRECTUSERNAME:
        return Failure(ResponseCode.USERNOTFOUND, ResponseMessage.INCORRECTUSERNAMEORPASSWORD.tr());
      case DataSource.INCORRECTPASSWORD:
        return Failure(ResponseCode.WRONGPASSWORD, ResponseMessage.INCORRECTUSERNAMEORPASSWORD.tr());
        case DataSource.EMAILALREADYINUSE:
        return Failure(ResponseCode.EMAILFOUND, ResponseMessage.EMAILALREADYEXISTS.tr());
      case DataSource.DEFAULT:
        return Failure(ResponseCode.WRONGPASSWORD, ResponseMessage.DEFAULT.tr());
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION, ResponseMessage.NO_INTERNET_CONNECTION.tr());
    }
  }

}

class ResponseCode{
  static const String USERNOTFOUND = 'user-not-found';
  static const String WRONGPASSWORD = 'wrong-password';
  static const String EMAILFOUND = 'email-already-in-use';
  static const String OTHERERROR = 'other-error';
  static const int NO_INTERNET_CONNECTION = -6;


}

class ResponseMessage{
  static const String INCORRECTUSERNAMEORPASSWORD = AppStrings.incorrectUsernameOrPassword;
  static const String EMAILALREADYEXISTS = AppStrings.emailAlreadyExists;
  static const String DEFAULT = AppStrings.defaultError;
  static const String NO_INTERNET_CONNECTION = AppStrings.noInternetError;


}