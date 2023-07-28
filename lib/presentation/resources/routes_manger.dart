import 'package:chat_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:chat_app/presentation/main_screen/main_screen.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/di.dart';
import '../auth/login/view/login_view.dart';
import '../auth/register/bloc/register_bloc.dart';
import '../auth/register/view/register_screen.dart';
import '../onboarding/onboarding_cubit/onboarding_cubit.dart';
import '../onboarding/view/onboarding_view.dart';
import '../splash_screen/splash_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String resetPasswordRoute = "/resetPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
  static const String chatRoomScreen = "/chatRoomScreen";
  static const String webViewContactUsRoute = "/webViewContactUsRoute";
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => OnboardingCubit(),
                  child: BoardingScreen(),
                ));
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => instance<LoginBloc>(),
                  child: const LoginView(),
                ));
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => instance<RegisterBloc>(),
                  child: const RegisterScreen(),
                ));
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) =>  const MainScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.noRouteFound.tr()),
        ),
        body:  Center(child: Text(AppStrings.noRouteFound.tr())),
      ),
    );
  }
}
