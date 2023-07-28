import 'dart:async';

import 'package:chat_app/presentation/resources/assets_manager.dart';
import 'package:chat_app/presentation/resources/constants_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resources/routes_manger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() {
   var istUserLoggedIn = _appPreferences.istUserLoggedInOrRegistered();
      if(istUserLoggedIn){
        Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute, (route) => false);
      }else{
      var isOnBoardingViewed = _appPreferences.isOnboardingViewed();
          if(isOnBoardingViewed){
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          }else{
            Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
          }
      }
  }

  @override
  void initState() {
    _startDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mqSize = MediaQuery.of(context).size;
    return  Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Image(
              image: const AssetImage(
                ImageAssets.splashLogo,
              ),
              height: mqSize.height /MediaQueryAppSize.s2,
              width: mqSize.width /MediaQueryAppSize.s2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
