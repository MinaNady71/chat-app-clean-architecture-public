import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/models/models.dart';
import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitialState());

  int currentIndex = 0;

   final  List<SliderObject> list = [
    SliderObject(AppStrings.onBoardingTitle1.tr(), AppStrings.onBoardingSubTitle1.tr(), ImageAssets.onBoardingLogo1),
    SliderObject(AppStrings.onBoardingTitle2.tr(), AppStrings.onBoardingSubTitle2.tr(), ImageAssets.onBoardingLogo2),
    SliderObject(AppStrings.onBoardingTitle3.tr(), AppStrings.onBoardingSubTitle3.tr(), ImageAssets.onBoardingLogo3),
    SliderObject(AppStrings.onBoardingTitle4.tr(), AppStrings.onBoardingSubTitle4.tr(), ImageAssets.onBoardingLogo4),
  ];



  onPageChanged(index){
    currentIndex = index;
    emit(OnboardingOnPageChangedState());
  }
//
//   goNext(){
//     if(currentIndex == list.length -1){
//         currentIndex = 0;
//     }else{
//         currentIndex++;
//     }
//     emit(OnboardingGoNextState());
//   }
//
//   goPrevious(){
//     if(currentIndex == 0){
//         currentIndex = list.length -1;
//     }else{
//         currentIndex--;
//     }
//     emit(OnboardingGoPreviousState());
// }
}