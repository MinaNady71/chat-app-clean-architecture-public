import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key, required this.onPress});

  final Function onPress;

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p125, vertical: AppPadding.p4),
              child: Divider(
                thickness: AppSize.s2,
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  AppStrings.sortBy.tr(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  widget.onPress(0);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Icon(
                      Icons.circle,
                      size: AppSize.s15,
                      color: ColorManager.greenDeep,
                    )),
                    const SizedBox(
                      width: AppSize.s5,
                    ),
                    Flexible(
                      child: Text(AppStrings.online.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: ColorManager.greenDeep,
                              )),
                    ),
                  ],
                )),
            TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  widget.onPress(1);
                  Navigator.pop(context);
                },
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Icon(
                        Icons.circle,
                        size: AppSize.s15,
                        color: ColorManager.disActiveUserDarkModeColor,
                      )),
                      const SizedBox(
                        width: AppSize.s5,
                      ),
                      Flexible(
                        child: Text(AppStrings.offline.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color:
                                      ColorManager.disActiveUserDarkModeColor,
                                )),
                      )
                    ])),
            TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  widget.onPress(2);
                  Navigator.pop(context);
                },
                child: Text(AppStrings.all.tr(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: ColorManager.disActiveUserDarkModeColor,
                        ))),
          ],
        ),
      ),
    );
  }
}
