import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class ChangeLanguageDialog extends StatelessWidget {
  ChangeLanguageDialog({super.key});
   final AppPreferences _appPreferences = instance<AppPreferences>();

 final List<String> chooseLanguageList=[
    AppStrings.english.tr(),
    AppStrings.arabic.tr(),
  ];
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount:chooseLanguageList.length ,
          itemBuilder: (context, index) =>
            SizedBox(
              width: double.infinity,
              child: InkWell(
                child: Padding(
                  padding:  const EdgeInsets.symmetric(vertical: AppPadding.p12,horizontal: AppPadding.p20),
                  child: Text(
                    chooseLanguageList[index],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                onTap: (){
                  changeAppLanguage(index,context);
                  Navigator.pop(context);
                },
              ),
            ),
        ),
      ),
    );
  }

   changeAppLanguage(index,context)async{
     await _appPreferences.changeAppLanguage(index);
     Restart.restartApp();
   }
}
