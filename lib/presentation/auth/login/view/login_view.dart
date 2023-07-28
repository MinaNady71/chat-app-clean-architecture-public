import 'package:chat_app/presentation/auth/forgot_password/view/forgot_password_widget.dart';
import 'package:chat_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:chat_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:chat_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:chat_app/presentation/resources/assets_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../app/functions.dart';
import '../../../resources/routes_manger.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) async {
      if (state is LoginLoadingState || state is SignInWithGoogleLoadingState) {
        FlowStateExtesion(LoadingState(
                stateRendererType: StateRendererType.popupLoadingState,message: AppStrings.loading.tr()))
            .getScreenWidget(context, () {});
      }
      if (state is LoginFailureState) {
        FlowStateExtesion(ErrorState(
                state.failure.message, StateRendererType.popupErrorState))
            .getScreenWidget(context, () {});
      }
      if (state is SignInWithGoogleFailureState) {
        FlowStateExtesion(ErrorState(
                state.failure.message, StateRendererType.popupErrorState))
            .getScreenWidget(context, () {});
      }
      if (state is LoginSuccessState || state is SignInWithGoogleSuccessState) {
         _appPreferences.setUserLoggedInOrRegistered();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.mainRoute, (route) => false);
      }
    }, builder: (context, state) {
      return _getContentWidget();
    }));
  }

  _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(
          top: AppPadding.p50, right: AppPadding.p28, left: AppPadding.p28),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                // const Center(child: Image(image: AssetImage(ImageAssets.splashLogo))),
                const SizedBox(
                  height: AppSize.s50,
                ),
                Text(
                  AppStrings.welcome.tr(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: AppSize.s8,
                ),
                Text(
                  AppStrings.loginToYourAccount.tr(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(
                  height: AppSize.s60,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (email) {
                    return isEmailValid(email);
                  },
                  onTapOutside: (_){
                    unFocusKeyboard();
                  },
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    labelText: AppStrings.email.tr(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s16,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  obscureText: showPassword?false:true,
                  onTapOutside: (_){
                    unFocusKeyboard();
                  },
                  validator: (password) {
                    return isPasswordValid(password);
                  },
                  decoration: InputDecoration(
                      labelText: AppStrings.password.tr(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: TextButton(
                          onPressed: forgotPasswordOnPress,
                          child: Text(
                            AppStrings.forgotPassword.tr(),
                          ))),
                ),
                Row(
                  children: [
                    Checkbox(
                        side: BorderSide(
                            color: Theme.of(context).iconTheme.color!),
                        value: showPassword,
                        onChanged: (value) {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        }),
                    Text(AppStrings.showPassword.tr()),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: AppSize.s40,
                  child: ElevatedButton(
                    onPressed: loginOnPress,
                    child: Text(AppStrings.login.tr()),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p14),
                            child: Divider(),
                          )),
                      Expanded(
                        child: Text(
                          AppStrings.orContinueWith.tr(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppPadding.p14),
                            child: Divider(),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                  child: ElevatedButton(
                      onPressed: () async {
                        signInWithGoogleOnPress();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppPadding.p8),
                              child: Image.asset(
                                ImageAssets.googleIcon,
                                fit: BoxFit.cover,
                                height: AppSize.s30,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: AppSize.s8,
                          ),
                          Flexible(
                            flex: 2,
                            child: Text(
                              AppStrings.continueWithGoogle.tr(),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.visible,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.registerRoute);
                      },
                      child: Text(
                        AppStrings.registerText.tr(),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    unFocusKeyboard();
    super.dispose();
  }

  void loginOnPress() {
    var bloc = BlocProvider.of<LoginBloc>(context);
    if (_formKey.currentState!.validate()) {
      bloc.add(LoginEvent(_emailController.text, _passwordController.text));
    }
    //   _passwordController.clear();
    unFocusKeyboard();
  }

  void signInWithGoogleOnPress() {
    var bloc = BlocProvider.of<LoginBloc>(context);
    bloc.add(SignInWithGoogleEvent());
  }

  void forgotPasswordOnPress() {
    initForgotPasswordModule();
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (context) => const ForgotPassword());
    });
  }
}
