import 'package:chat_app/app/app_prefs.dart';
import 'package:chat_app/app/constants.dart';
import 'package:chat_app/app/di.dart';
import 'package:chat_app/presentation/common/widgets/change_language.dart';
import 'package:chat_app/presentation/common/widgets/change_theme.dart';
import 'package:chat_app/presentation/common/widgets/components.dart';
import 'package:chat_app/presentation/common/widgets/full_screen_image.dart';
import 'package:chat_app/presentation/profile_screen/bloc/profile_bloc.dart';
import 'package:chat_app/presentation/profile_screen/edit_profile_screen.dart';
import 'package:chat_app/presentation/resources/assets_manager.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/use_cases/user/update_status_use_case.dart';
import '../common/state_renderer/state_renderer.dart';
import '../common/state_renderer/state_renderer_impl.dart';
import '../resources/routes_manger.dart';
import '../resources/values_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final UpdateStatusUseCase updateStatusUseCase =
      instance<UpdateStatusUseCase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          AppStrings.profile.tr(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: _getScreenContent(),
    );
  }

  Widget _getScreenContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                right: AppPadding.p25,
                top: AppPadding.p25,
                bottom: AppPadding.p100,
                left: AppPadding.p25),
            child: Column(
              children: [
                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) async {
                    _signOutIfSuccess(state);
                  },
                  builder: (context, state) {
                    if (state is ProfileSuccessState) {
                      return _imageProfileWidget(state.userModel.image);
                    } else if (state is SignOutProfileLoadingState) {
                      return Center(
                        child: SingleChildScrollView(
                            child: FlowStateExtesion(LoadingState(
                                    stateRendererType:
                                        StateRendererType.popupLoadingState,
                                    message: AppStrings.loading.tr()))
                                .getScreenWidget(context, () {})),
                      );
                    } else {
                      return _imageProfileWidget(Constants.empty);
                    }
                  },
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                ElevatedButton(
                    onPressed: () {
                      navigateToPush(context, const EditProfileScreen());
                    },
                    child: Text(AppStrings.editProfile.tr())),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.generalSettings.tr(),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    Column(
                      children: [
                        ListTile(
                          minLeadingWidth: AppSize.s10,
                          title: Text(
                            AppStrings.darkMode.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          leading: Icon(
                            Icons.dark_mode,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          trailing: Text(
                            _appPreferences.getAppTheme() == true
                                ? AppStrings.dark.tr()
                                : _appPreferences.getAppTheme() == false
                                    ? AppStrings.light.tr()
                                    : AppStrings.deviceSettings.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ChangeThemeDialog();
                                });
                          },
                        ),
                        ListTile(
                          minLeadingWidth: AppSize.s10,
                          title: Text(
                            AppStrings.changeLanguage.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          leading: Icon(
                            Icons.language,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          trailing: Text(
                            AppStrings.currentLanguage.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ChangeLanguageDialog();
                                });
                          },
                        ),
                        ListTile(
                          minLeadingWidth: AppSize.s10,
                          title: Text(
                            AppStrings.logout.tr(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          leading: Icon(
                            Icons.logout,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onTap: () {
                            defaultAlertShowDialog(
                                redButton: AppStrings.logout.tr(),
                                context: context,
                                title: AppStrings.logoutConfirmation.tr(),
                                onPress: () {
                                  _signOut();
                                });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppPadding.p10),
          alignment: Alignment.bottomRight,
          child:Text(Constants.appVersion,style:Theme.of(context).textTheme.bodyLarge),
        )
      ],
    );
  }

  Widget _imageProfileWidget(String image) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: AppSize.s150,
        height: AppSize.s150,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Material(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const CircleBorder(),
              child: Align(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullscreenImage(image: image),
                          fullscreenDialog: true,
                        ));
                  },
                  child: CircleAvatar(
                    backgroundImage: Image.asset(ImageAssets.userAvatar).image,
                    foregroundImage: NetworkImage(image),
                    maxRadius: double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signOut() {
    context.read<ProfileBloc>().add(SignOutProfileEvent());
    Navigator.pop(context);
  }

  _signOutIfSuccess(ProfileState state) async {
    if (state is SignOutProfileSuccessState) {
      _appPreferences.setUserLogout();
      await updateStatusUseCase.execute(false);
      await GetIt.instance.reset();
      await initAppModule();
      // navigate to login screen
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginRoute,
        (route) => false,
      );
    }
  }
}
