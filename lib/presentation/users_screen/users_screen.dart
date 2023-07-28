import 'package:chat_app/domain/models/models.dart';
import 'package:chat_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:chat_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:chat_app/presentation/resources/color_manager.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:chat_app/presentation/users_screen/bloc/users_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../chat_room_screen/chat_room_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manger.dart';
import '../search_screen/search_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      edgeOffset: AppSize.s50,
      onRefresh: onRefresh,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          title: Text(
            AppStrings.people.tr(),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        body: _getScreenContent(),
      ),
    );
  }

  Widget _getScreenContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSize.s25),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SearchScreen(
                              list: BlocProvider.of<UsersBloc>(context)
                                  .searchPageList,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s25),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p15, vertical: AppPadding.p10),
                child: Row(children: [
                  Text(
                    AppStrings.search.tr(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  const Icon(Icons.search),
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: AppPadding.p10,
          ),
          Expanded(
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadingState ||
                    state is UsersRefreshLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UsersSuccessState) {
                  if(state.list.isNotEmpty) {
                    return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        usersList(context, index, state.list[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSize.s5),
                    itemCount: state.list.length,
                  );
                  }else {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      child: Padding(
                        padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height* MediaQueryAppSize.s0_15,bottom: AppPadding.p100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(JsonAssets.emptyList,
                                width: AppSize.s200,
                                height: AppSize.s200,
                                fit: BoxFit.fill),
                            const SizedBox(
                              height:  AppSize.s20,
                            ),
                            Text(
                              AppStrings.refreshThePage.tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(
                              height: AppSize.s10,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                if (state is UsersFailureState) {
                  return FlowStateExtesion(ErrorState(state.failure.message,
                          StateRendererType.fullScreenErrorState))
                      .getScreenWidget(context, () {context.read<UsersBloc>().add(GetAllUsersEvent());});
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget usersList(context, index, UserModel userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: ColorManager.borderColor, width: AppSize.s0_25),
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(AppSize.s25),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSize.s25),
              onLongPress: () {},
              onTap: ()  {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: Routes.chatRoomScreen),
                        builder: (context) => ChatRoomScreen(
                          userModel: userModel,
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p10, horizontal: AppPadding.p10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: Image.asset(ImageAssets.userAvatar).image,
                            foregroundImage:NetworkImage(userModel.image),
                            maxRadius: AppSize.s23,
                          ),
                          CircleAvatar(
                            radius: AppSize.s8,
                            backgroundColor: ColorManager.black45,
                            child: CircleAvatar(
                              maxRadius: AppSize.s5,
                              backgroundColor: userModel.status
                                  ? ColorManager.activeUserDarkModeColor
                                  : ColorManager.disActiveUserDarkModeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: AppSize.s15,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  userModel.username,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                              const SizedBox(
                                width: AppSize.s5,
                              ),
                              if (userModel.verified)
                                Flexible(
                                    flex: 0,
                                    child: Icon(Icons.verified,
                                        color: ColorManager
                                            .verifiedIconColor,
                                        size: AppSize.s16)),
                            ],
                          ),
                          const SizedBox(
                            height: AppSize.s10,
                          ),
                          Text(
                            userModel.bio,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: AppPadding.p8),
                      child: Text(
                        userModel.status
                            ? AppStrings.online.tr()
                            : AppStrings.offline.tr(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: userModel.status
                                  ? ColorManager.activeUserDarkModeColor
                                  : ColorManager.disActiveUserDarkModeColor,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> onRefresh() async {
    Future.delayed(const Duration(seconds: 0));

    context.read<UsersBloc>().add(RefreshUsersEvent());
  }
}

