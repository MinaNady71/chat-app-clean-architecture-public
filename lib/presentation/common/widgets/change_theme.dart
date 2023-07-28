import 'package:chat_app/app/theme/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class ChangeThemeDialog extends StatelessWidget {
   ChangeThemeDialog({super.key});
  final List<String> chooseThemeList=[
    AppStrings.dark.tr(),
    AppStrings.light.tr(),
    AppStrings.deviceSettings.tr(),
  ];
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount:chooseThemeList.length ,
          itemBuilder: (context, index) =>
            SizedBox(
              width: double.infinity,
              child: InkWell(
                child: Padding(
                  padding:  const EdgeInsets.symmetric(vertical: AppPadding.p12,horizontal: AppPadding.p20),
                  child: Text(
                    chooseThemeList[index],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                onTap: (){
                  changeAppTheme(index,context);
                  Navigator.pop(context);
                },
              ),
            ),
        ),
      ),
    );
  }

   changeAppTheme(index,context)async{
   await BlocProvider.of<ThemeCubit>(context).changeAppTheme(index);
   }
}
