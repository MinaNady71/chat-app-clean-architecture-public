import 'package:chat_app/presentation/resources/color_manager.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/constants.dart';
import '../../../app/functions.dart';

navigateToPush(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

Widget customTextFieldInput({
  required BuildContext context,
  TextEditingController? controller,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  String? labelText,
  int? maxLength,
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool? enabled,
  Color? prefixIconColor,
  Color? labelColor,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    controller: controller,
    validator: validator,
    maxLength: maxLength,
    enabled: enabled,
    onTapOutside: (_){
      unFocusKeyboard();
    },
    style: TextStyle(color: labelColor),
    decoration: InputDecoration(
      prefixIconColor: prefixIconColor,
      counterText: Constants.empty,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ),
  );
}

defaultAlertShowDialog(
        {required context,
        required String title,
        String? greenButton,
        required String redButton,
        onPress}) =>
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: AppSize.s0,
              left: AppSize.s10,
              right: AppSize.s10,
              top: AppSize.s15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: ColorManager.greenDeep),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(greenButton ?? AppStrings.back.tr(),
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: ColorManager.greenDeep,
                                ))),
                  ),
                  Flexible(
                    child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: onPress,
                        child: Text(redButton,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: ColorManager.error,
                                ))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
