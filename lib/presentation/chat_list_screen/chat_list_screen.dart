import 'package:chat_app/domain/models/models.dart';
import 'package:chat_app/presentation/chat_room_screen/chat_room_screen.dart';
import 'package:chat_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:chat_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:chat_app/presentation/resources/color_manager.dart';
import 'package:chat_app/presentation/resources/routes_manger.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../resources/assets_manager.dart';
import '../search_screen/search_screen.dart';
import 'bloc/chat_bloc.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
            AppStrings.chats.tr(),
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
                              list: ChatBloc.listUserModel,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppSize.s25,
                  ),
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
            child: BlocBuilder<ChatBloc, ChatBlocState>(
              builder: (context, state) {
                if (state is ChatBlocLoadingState ||
                    state is ChatBlocRefreshLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatBlocSuccessState) {
                  if (state.list.isNotEmpty) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.list
                              .any((element) => element.status == true))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(AppPadding.p8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppPadding.p20),
                                    gradient: LinearGradient(colors: [
                                      ColorManager.deepPurple,
                                      ColorManager.lightPurple,
                                    ]),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            AppStrings.currentlyActive.tr(),
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                      const SizedBox(width: AppSize.s5),
                                      Flexible(
                                          child: Icon(
                                        Icons.circle,
                                        color: ColorManager
                                            .activeUserDarkModeColor,
                                        size: AppSize.s10,
                                      ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSize.s5,
                                ),
                                LimitedBox(
                                  maxHeight: AppSize.s100,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (state.list[index].status == true) {
                                        return currentlyActiveList(
                                            context, index, state.list[index]);
                                      } else {}
                                      return const SizedBox();
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: AppSize.s5),
                                    itemCount: state.list.length,
                                  ),
                                ),
                              ],
                            ),
                          Container(
                            padding: const EdgeInsets.all(AppPadding.p8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppPadding.p20),
                              gradient: LinearGradient(colors: [
                                ColorManager.deepPurple,
                                ColorManager.lightPurple,
                              ]),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(AppStrings.recent.tr(),
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: AppSize.s5),
                                Flexible(
                                    child: Icon(
                                  Icons.access_time_filled,
                                  color: ColorManager.white,
                                  size: AppSize.s15,
                                ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: AppPadding.p10,
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => friendsListWidget(
                                context, index, state.list[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSize.s5),
                            itemCount: state.list.length,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Padding(
                        padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height* MediaQueryAppSize.s0_15,bottom: AppPadding.p100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(JsonAssets.emptyChat,
                                width: AppSize.s200,
                                height: AppSize.s200,
                                fit: BoxFit.fill),
                            const SizedBox(
                              height:  AppSize.s20,
                            ),
                            Text(
                              AppStrings.emptyListDisc.tr(),
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
                if (state is ChatBlocFailureState) {
                  return FlowStateExtesion(ErrorState(state.failure.message,
                          StateRendererType.fullScreenErrorState))
                      .getScreenWidget(context, () {
                    context.read<ChatBloc>().add(GetAllChatBlocEvent());
                  });
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

  currentlyActiveList(context, index, UserModel userModel) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppPadding.p50),
      overlayColor: MaterialStateProperty.all(
        Colors.white12,
      ),
      onTap: (){
         Navigator.push(context, MaterialPageRoute(
             settings: const RouteSettings(name: Routes.chatRoomScreen),
             builder: (context)=>ChatRoomScreen(userModel:userModel,)));
      },
      child: SizedBox(
        width: AppSize.s75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.p5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s35),
                child: CircleAvatar(
                  backgroundImage: Image.asset(ImageAssets.userAvatar).image,
                  foregroundImage: NetworkImage(userModel.image),
                  maxRadius: AppSize.s30,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p1),
                    child: Text(
                      userModel.username,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Offstage(
                    offstage: !userModel.verified,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSize.s0_5),
                      child: Icon(Icons.verified,
                          color: ColorManager.verifiedIconColor,
                          size: AppSize.s14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget friendsListWidget(context, index, UserModel userModel) {
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
              onTap: () {
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
                            backgroundImage:
                                Image.asset(ImageAssets.userAvatar).image,
                            foregroundImage: NetworkImage(userModel.image),
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
                    // Padding(
                    //     padding: const EdgeInsets.only(left: AppPadding.p8),
                    //     child: CircleAvatar(
                    //         backgroundColor:
                    //             ColorManager.countMessageDarkModeColor,
                    //         radius: AppSize.s12,
                    //         child:
                    //            Text(
                    //              '0',
                    //             style: Theme.of(context).textTheme.labelSmall,
                    //           ),
                    //         ))
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
    context.read<ChatBloc>().add(RefreshChatBlocEvent());
  }
}
