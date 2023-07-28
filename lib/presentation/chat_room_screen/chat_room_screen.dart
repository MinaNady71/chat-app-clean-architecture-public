import 'package:chat_app/data/data_source/remote_data_source/FCM/fcm.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/presentation/chat_room_screen/bloc/chat_room_bloc.dart';
import 'package:chat_app/presentation/profile_screen/bloc/profile_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/functions.dart';
import '../../data/data_source/remote_data_source/firebase_auth_remote_data_source.dart';
import '../../domain/models/models.dart';
import '../common/state_renderer/state_renderer.dart';
import '../common/state_renderer/state_renderer_impl.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'dart:ui' as ui;

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen>
    with WidgetsBindingObserver {
  bool isEmojiOffstage = true;
  bool? isListEmpty;

  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  late ChatRoomBloc bloc;

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _bloc();
    _listener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    bloc = context.read<ChatRoomBloc>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: AppSize.s80,
        title: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSize.s25),
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back),
                    const SizedBox(
                      width: AppSize.s4,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          Image.asset(ImageAssets.userAvatar).image,
                      foregroundImage: NetworkImage(widget.userModel.image),
                      maxRadius: AppSize.s25,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: AppSize.s10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          showFirstAndSecondName(widget.userModel.username),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(
                        width: AppSize.s5,
                      ),
                      Flexible(
                        flex: 0,
                        child: Offstage(
                          offstage: !widget.userModel.verified,
                          child: Icon(Icons.verified,
                              color: ColorManager.verifiedIconColor,
                              size: AppSize.s16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSize.s8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Icon(
                        Icons.circle,
                        size: AppSize.s8,
                        color: widget.userModel.status
                            ? ColorManager.activeUserDarkModeColor
                            : ColorManager.disActiveUserDarkModeColor,
                      )),
                      const SizedBox(
                        width: AppSize.s2,
                      ),
                      Flexible(
                        child: Text(
                            widget.userModel.status
                                ? AppStrings.online.tr()
                                : AppStrings.offline.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: widget.userModel.status
                                      ? ColorManager.activeUserDarkModeColor
                                      : ColorManager.disActiveUserDarkModeColor,
                                )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: AppPadding.p8),
            child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.inProcess.tr())));
                },
                icon: Icon(
                  size: AppSize.s30,
                  Icons.phone,
                  color: Theme.of(context).iconTheme.color,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppPadding.p8),
            child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.inProcess.tr())));
                },
                icon: Icon(
                  size: AppSize.s30,
                  Icons.photo_camera,
                  color: Theme.of(context).iconTheme.color,
                )),
          ),
        ],
      ),
      body: BlocBuilder<ChatRoomBloc, ChatRoomState>(
        builder: (context, state) {
          if (state is ChatRoomGetMessagesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatRoomGetMessagesSuccessState) {
            return _screenContent(state, bloc);
          }
          if (state is ChatRoomGetMessagesFailureState) {
            return _failureWidget(state);
          }
          if (state is ChatRoomAddMessageFailureState) {
            return _failureWidget(state);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _failureWidget(state) {
    return FlowStateExtesion(ErrorState(
            state.failure.message, StateRendererType.fullScreenErrorState))
        .getScreenWidget(context, () {
      context
          .read<ChatRoomBloc>()
          .add(ChatRoomGetMessagesEvent(widget.userModel.uid));
    });
  }

  Widget _screenContent(ChatRoomGetMessagesSuccessState state, bloc) {
    return Stack(
      children: [
        Column(
          children: [
            Directionality(
              textDirection: ui.TextDirection.ltr,
              child: Expanded(
                child: Scrollbar(
                  radius: const Radius.circular(AppSize.s25),
                  child: StreamBuilder(
                    stream: state.chatStream.asBroadcastStream(),
                    builder: (context, snapshot) {
                      isListEmpty = snapshot.data?.isEmpty;
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return ListView.separated(
                          padding: isEmojiOffstage
                              ? null
                              : EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      MediaQueryAppSize.s0_30),
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data![index].fromUid ==
                                FirebaseAuth.instance.currentUser!.uid) {
                              return _ownerMessages(snapshot.data![index]);
                            } else {
                              return _otherMessagesMessage(
                                  snapshot.data![index]);
                            }
                          },
                          separatorBuilder: (context, index) {
                            if (showDateMessage(
                                    snapshot.data![index].createdAt) !=
                                showDateMessage(
                                    snapshot.data![index + 1].createdAt)) {
                              return Row(
                                children: [
                                  const Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(
                                        left: AppPadding.p85,
                                        right: AppSize.s5),
                                    child: Divider(thickness: AppSize.s1),
                                  )),
                                  Text(
                                    showDateMessage(
                                        snapshot.data![index].createdAt),
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.only(
                                        right: AppPadding.p85,
                                        left: AppSize.s5),
                                    child: Divider(thickness: AppSize.s1),
                                  )),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      } else if (snapshot.data?.isEmpty != null) {
                        return Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppStrings.sayHello.tr(),
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(
                              width: AppSize.s5,
                            ),
                            const Icon(Icons.waving_hand)
                          ],
                        ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: AppPadding.p65,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              height: AppSize.s65,
              child: Row(
                children: [
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          focusNode.unfocus();
                          focusNode.canRequestFocus = false;
                          isEmojiOffstage = !isEmojiOffstage;
                        });
                      },
                      icon: Icon(
                        size: AppSize.s25,
                        Icons.emoji_emotions,
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedItemColor,
                      )),
                  Expanded(
                      child: TextFormField(
                    maxLines: null,
                    focusNode: focusNode,
                    controller: _messageController,
                        onTapOutside: (_){
                          unFocusKeyboard();
                        },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: AppStrings.typeMessage.tr(),
                      hintStyle: TextStyle(
                          color: ColorManager.placeHolderDarkModeColor),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSize.s15),
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSize.s10),
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  )),
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: _messageController.text.isNotEmpty
                          ? () {
                              sendMessageTap(bloc);
                            }
                          : null,
                      disabledColor: ColorManager.darkGrey2,
                      icon: Icon(
                        size: AppSize.s25,
                        Icons.send,
                        color: _messageController.text.isNotEmpty
                            ? Theme.of(context)
                                .bottomNavigationBarTheme
                                .selectedItemColor
                            : ColorManager.darkGrey2,
                      )),
                ],
              ),
            ),
            Offstage(
              offstage: isEmojiOffstage,
              child: showingEmoji(),
            )
          ],
        ),
      ],
    );
  }

  Widget _ownerMessages(MessagesModel messagesModel) {
    return Padding(
      padding: const EdgeInsets.only(right: AppPadding.p15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LimitedBox(
            maxWidth:
                MediaQuery.of(context).size.width * MediaQueryAppSize.s0_70,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p8),
              child: Container(
                padding: const EdgeInsets.all(AppPadding.p8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppSize.s15),
                      bottomRight: Radius.circular(AppSize.s15),
                      topLeft: Radius.circular(AppSize.s15)),
                  gradient: LinearGradient(colors: [
                    ColorManager.leftTexTUserBGDMColor,
                    ColorManager.rightTexTUserBGDMColor,
                  ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(messagesModel.message,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            height: AppSize.s1_25, wordSpacing: AppSize.s1)),
                    Padding(
                      padding: const EdgeInsets.only(top: AppPadding.p2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            showTimeHM(messagesModel.createdAt),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: AppSize.s10),
                            // const SizedBox(
                            //   width: AppSize.s2,
                            // ),
                            // Icon(Icons.done_all,
                            //     size: 15,
                            //     color: messagesModel.isViewed
                            //         ? ColorManager.lightBlueAccent
                            //         : ColorManager.lightGrey
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _otherMessagesMessage(MessagesModel messagesModel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: CircleAvatar(
            backgroundImage: Image.asset(ImageAssets.userAvatar).image,
            foregroundImage: NetworkImage(widget.userModel.image),
            maxRadius: AppSize.s25,
          ),
        ),
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width * MediaQueryAppSize.s0_70,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppSize.s15),
                    bottomRight: Radius.circular(AppSize.s15),
                    topRight: Radius.circular(AppSize.s15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(messagesModel.message,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          height: AppSize.s1_25,
                          wordSpacing: AppSize.s1,
                          fontWeight: FontWeightManager.regular)),
                  Padding(
                    padding: const EdgeInsets.only(top: AppPadding.p2),
                    child: Text(
                      showTimeHM(messagesModel.createdAt),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: AppSize.s10),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showingEmoji() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * MediaQueryAppSize.s0_30,
        child: _showModalBottomSheetWidget());
  }

  Widget _showModalBottomSheetWidget() {
    return EmojiPicker(
      textEditingController: _messageController,
      config: Config(
        columns: 9,
        emojiSizeMax: AppSize.s25,
        bgColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  sendMessageTap(
    bloc,
  ) {
    if (_messageController.text.isNotEmpty) {
      bloc.add(ChatRoomAddMessageEvent(MessagesResponse(
          createdAt: DateTime.now()
              .toUtc()
              .add(ntpTimeZoneOffset)
              .millisecondsSinceEpoch,
          timestamp: FieldValue.serverTimestamp(),
          message: _messageController.text,
          fromUid: FirebaseAuthDatasourceImpl.auth.currentUser?.uid,
          toUid: widget.userModel.uid,
          isViewed: true //update it later to dynamic
          )));
      if (isListEmpty == true) {
        bloc.add(ChatRoomAddInFriendsListEvent(widget.userModel.uid));
      }
      sendNotification();
      setState(() {
        _messageController.clear();
      });
      _countUnreadMessage();
    }
  }

  _countUnreadMessage() {
    bloc.add(AddUnreadCountMessagesEvent(
      widget.userModel.uid,
    ));
  }

  sendNotification() async {
    await FCM().fcmChatMessage(
        token: widget.userModel.token,
        bodyName: _messageController.text,
        titleText:
            BlocProvider.of<ProfileBloc>(context).currentUserModel!.username,
        image: BlocProvider.of<ProfileBloc>(context).currentUserModel!.image,
        uid: BlocProvider.of<ProfileBloc>(context).currentUserModel!.uid);
  }

  _bloc() {
    context
        .read<ChatRoomBloc>()
        .add(ChatRoomGetMessagesEvent(widget.userModel.uid));
    // context
    //     .read<ChatRoomBloc>()
    //     .add(AmIInChatRoomEvent(widget.userModel.uid, true));
    // context
    //     .read<ChatRoomBloc>()
    //     .add(ResetUnreadCountMessagesEvent(widget.userModel.uid,)); //TODO remove comment later
  }

  _listener() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isEmojiOffstage = true;
        });
      }
    });
    _messageController.addListener(() {
      setState(() {
        _messageController.text;
      });
    });
  }

  _didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.resumed) {
    //   bloc.add(AmIInChatRoomEvent(widget.userModel.uid, true));
    // } else {
    //   bloc.add(AmIInChatRoomEvent(widget.userModel.uid, false));
    // }
  }

  @override
  void dispose() {
    _messageController.dispose();
    bloc.add(AmIInChatRoomEvent(widget.userModel.uid, false));
    super.dispose();
  }
}
