import 'package:chat_app/app/app_prefs.dart';
import 'package:chat_app/app/di.dart';
import 'package:chat_app/domain/models/models.dart';
import 'package:chat_app/presentation/onboarding/onboarding_cubit/onboarding_cubit.dart';
import 'package:chat_app/presentation/resources/color_manager.dart';
import 'package:chat_app/presentation/resources/constants_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../resources/routes_manger.dart';
import '../../resources/strings_manager.dart';

class BoardingScreen extends StatelessWidget {
   BoardingScreen({Key? key}) : super(key: key);

  final PageController _pageController = PageController();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<OnboardingCubit>(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      cubit.onPageChanged(index);
                    },
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    itemCount: cubit.list.length,
                    itemBuilder: (context, index) =>
                        buildColumnBoarding(context, cubit.list[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p30, vertical: AppPadding.p14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                                duration: const Duration(
                                    seconds: AppConstants.sliderAnimationTime),
                                curve: Curves.easeInBack);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: SmoothPageIndicator(
                            controller: _pageController,
                            effect: ExpandingDotsEffect(
                                activeDotColor:
                                    ColorManager.placeHolderDarkModeColor,
                                expansionFactor: 3,
                                spacing: 10),
                            count: cubit.list.length),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: ()async{
                            _pageController.nextPage(
                                duration: const Duration(
                                    seconds: AppConstants.sliderAnimationTime),
                                curve: Curves.easeInBack);
                            if (cubit.currentIndex == cubit.list.length - 1) {
                              Navigator.pushReplacementNamed(
                                  context, Routes.loginRoute);
                            }
                            await _appPreferences.setOnboardingViewed();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: () async{
                  Navigator.pushReplacementNamed(context, Routes.loginRoute);
                await _appPreferences.setOnboardingViewed();
                },
                child: Text(
                  AppStrings.skip.tr(),
                  textAlign: TextAlign.end,
                ))
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildColumnBoarding(
      BuildContext context, SliderObject sliderObject) {
    var mq = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SvgPicture.asset(sliderObject.image,
              fit: BoxFit.cover,
              height: mq.height / MediaQueryAppSize.s1_5,
              width: mq.width),
          const SizedBox(
            height: AppSize.s20,
          ),
          Padding(
            padding: const EdgeInsets.all(AppPadding.p30),
            child: Column(
              children: [
                Text(
                  sliderObject.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Text(
                  sliderObject.subTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
