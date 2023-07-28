import 'package:chat_app/app/app_prefs.dart';
import 'package:chat_app/app/constants.dart';
import 'package:chat_app/app/di.dart';
import 'package:chat_app/app/theme/theme_cubit.dart';
import 'package:chat_app/presentation/profile_screen/bloc/profile_bloc.dart';
import 'package:chat_app/presentation/resources/routes_manger.dart';
import 'package:chat_app/presentation/resources/theme_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upgrader/upgrader.dart';

import '../presentation/auth/forgot_password/bloc/forgot_password_bloc.dart';
import '../presentation/chat_room_screen/bloc/chat_room_bloc.dart';
import '../presentation/resources/app_mode_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance();
  bool settingsMode = isDarkMode();

  @override
  void didChangeDependencies() async {
    Locale locale = _appPreferences.getLocal();
    context.setLocale(locale);
    listenToPlatformBrightnessChanged();
    _permission();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => instance<ThemeCubit>()),
        BlocProvider(create: (_) => instance<ChatRoomBloc>()),
        BlocProvider(create: (_) => instance<ProfileBloc>()),
        BlocProvider(create: (_) => instance<ForgotPasswordBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          var cubit = BlocProvider.of<ThemeCubit>(context);
          return UpgradeAlert(upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: Constants.durationCheckAgainForUpdate)),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeAnimationCurve: Curves.easeInOutBack,
              themeAnimationDuration: const Duration(seconds: AppLength.l2),
              theme: getApplicationTheme(cubit.isDark ?? settingsMode),
              onGenerateRoute: RoutesGenerator.getRoute,
              initialRoute: Routes.splashRoute,
            ),
          );
        },
      ),
    );
  }

  listenToPlatformBrightnessChanged() {
    final window = WidgetsBinding.instance.platformDispatcher;
    // This callback is called every time the brightness changes.
    WidgetsBinding.instance.handlePlatformBrightnessChanged();
    window.onPlatformBrightnessChanged = () {
      final brightness = window.platformBrightness;
      if (brightness == Brightness.dark) {
        setState(() {
          settingsMode = true;
        });
      } else {
        setState(() {
          settingsMode = false;
        });
      }
    };
  }

  _permission()async{
    if(await Permission.notification.isDenied){
      Permission.notification.request();
    }
  }
}
