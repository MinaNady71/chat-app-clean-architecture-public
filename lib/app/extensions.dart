import 'package:chat_app/app/constants.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullIntger on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}

extension NonNullBooleanOrFalse on bool? {
  bool orFalse() {
    if (this == null) {
      return Constants.orFalse;
    } else {
      return this!;
    }
  }
}
extension NonNullBooleanOrTrue on bool? {
  bool orTrue() {
    if (this == null) {
      return Constants.orTrue;
    } else {
      return this!;
    }
  }
}

extension RemoveNullValue on Map<String,dynamic> {
  Map<String, dynamic> removeNullValue() {
    removeWhere((key, value) => value == null);
    return this;
  }
}