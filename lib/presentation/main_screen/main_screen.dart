import 'package:chat_app/domain/use_cases/user/update_status_use_case.dart';
import 'package:chat_app/presentation/profile_screen/profile_screen.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di.dart';
import '../../data/data_source/remote_data_source/FCM/fcm.dart';
import '../chat_list_screen/bloc/chat_bloc.dart';
import '../chat_list_screen/chat_list_screen.dart';
import '../profile_screen/bloc/profile_bloc.dart';
import '../users_screen/bloc/users_bloc.dart';
import '../users_screen/users_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 1;
  UpdateStatusUseCase updateStatusUseCase = instance<UpdateStatusUseCase>();
  final List<Widget> _list = [
    const UsersScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<ProfileBloc>().add(GetCurrentUsersProfileEvent());
    FCM().onMessageOpenedApp(context);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => instance<UsersBloc>()..add(GetAllUsersEvent())),
        BlocProvider(
            create: (_) => instance<ChatBloc>()..add(GetAllChatBlocEvent())),
      ],
      child: Scaffold(
        extendBody: true,
        body: _list[_currentIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p50, vertical: AppPadding.p20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s25),
            child: BottomNavigationBar(
                unselectedFontSize: AppSize.s10,
                selectedFontSize: AppSize.s12,
                currentIndex: _currentIndex,
                onTap: onTapCurrentIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.groups,
                      ),
                      label: AppStrings.people.tr()),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.wechat_sharp),
                      label: AppStrings.chats.tr()),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.person),
                      label: AppStrings.profile.tr()),
                ]),
          ),
        ),
      ),
    );
  }

  onTapCurrentIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has come to the foreground (opened)
      updateStatusUseCase.execute(true);
    } else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // App is still visible but not receiving user interactions (closed)
      updateStatusUseCase.execute(false);
    }
    super.didChangeAppLifecycleState(state);
  }
}
