import 'package:chat_app/app/constants.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/presentation/resources/routes_manger.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../app/functions.dart';
import '../../../common/state_renderer/state_renderer.dart';
import '../../../common/state_renderer/state_renderer_impl.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';
import '../bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilNumberController = TextEditingController();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = AppStrings.countryCodeDefault;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: AppSize.s0,
        ),
        body: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) async{
          if (state is RegisterLoadingState) {
            FlowStateExtesion(LoadingState(
                    stateRendererType: StateRendererType.popupLoadingState,message: AppStrings.loading.tr()))
                .getScreenWidget(context, () {});
          }
          if (state is RegisterFailureState) {
            FlowStateExtesion(ErrorState(
                    state.failure.message, StateRendererType.popupErrorState))
                .getScreenWidget(context, () {});
          }
          if (state is RegisterSuccessState) {
             _appPreferences.setUserLoggedInOrRegistered();
            Navigator.pushNamedAndRemoveUntil(context, Routes.mainRoute, (route) => false);
          }
        }, builder: (context, state) {
          return _getContentWidget();
        }));
  }

  _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p18,left:AppPadding.p28,right:AppPadding.p28),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  AppStrings.register.tr(),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(
                  height: AppSize.s8,
                ),
                Text(
                  AppStrings.registerDesc.tr(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _usernameController,
                  onTapOutside: (_){
                    unFocusKeyboard();
                  },
                  validator: (username) {
                    return isUsernameValid(username);
                  },
                  maxLength: AppLength.l100,
                  decoration: InputDecoration(
                    counterText: Constants.empty,
                    labelText: AppStrings.username.tr(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Center(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: CountryCodePicker(
                              dialogBackgroundColor: Theme.of(context)
                                  .dialogTheme
                                  .backgroundColor,
                              dialogTextStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              padding: EdgeInsets.zero,
                              initialSelection: AppStrings.countryCodeDefault,
                              favorite: AppStrings.favouriteCountryCodeList,
                              showCountryOnly: true,
                              hideMainText: true,
                              showOnlyCountryWhenClosed: true,
                              barrierColor:
                                  ColorManager.barrierColorDarkModeColor,
                              onChanged: (countryCodeList) {
                                _countryCode = countryCodeList.dialCode ??
                                    AppStrings.countryCodeDefault;
                              }),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _mobilNumberController,
                          maxLength: AppLength.l100,
                          onTapOutside: (_){
                            unFocusKeyboard();
                          },
                          decoration: InputDecoration(
                            counterText: Constants.empty,
                            labelText:
                                '${AppStrings.mobileNumber.tr()}(${AppStrings.optional.tr()})',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSize.s16,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  maxLength: AppLength.l100,
                  onTapOutside: (_){
                    unFocusKeyboard();
                  },
                  validator: (email) {
                    return isEmailValid(email);
                  },
                  decoration: InputDecoration(
                    counterText: Constants.empty,
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
                  maxLength: AppLength.l100,
                  onTapOutside: (_){
                    unFocusKeyboard();
                  },
                  obscureText: showPassword?false:true,
                  validator: (password) {
                    return isPasswordValid(password);
                  },
                  decoration: InputDecoration(
                    counterText: Constants.empty,
                    labelText: AppStrings.password.tr(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _confirmPasswordController,
                  maxLength: AppLength.l100,
                  onTapOutside: (_){
                    unFocusKeyboard();
                  },
                  obscureText: showPassword?false:true,
                  validator: (password) {
                    return confirmPasswordValidate(
                        password, _passwordController.text);
                  },
                  decoration: InputDecoration(
                    counterText: Constants.empty,
                    labelText: AppStrings.confirmPassword.tr(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
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
                    onPressed: registerOnPress,
                    child: Text(AppStrings.register.tr()),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppStrings.loginText.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                ),
              ],
            )),
      ),
    );
  }

  void registerOnPress() {
    var bloc = BlocProvider.of<RegisterBloc>(context);
    if (_formKey.currentState!.validate()) {
      bloc.add(RegisterEvent(
          _emailController.text,
          _passwordController.text,
          UserResponse(
            username: _usernameController.text,
            email: _emailController.text,
            phone: _mobilNumberController.text.isNotEmpty
                ? _countryCode + _mobilNumberController.text
                : null,
          )));
    }
    //   _passwordController.clear();
    unFocusKeyboard();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
