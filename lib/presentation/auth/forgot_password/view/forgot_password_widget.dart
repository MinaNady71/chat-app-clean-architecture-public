import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/functions.dart';
import '../../../common/state_renderer/state_renderer.dart';
import '../../../common/state_renderer/state_renderer_impl.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / MediaQueryAppSize.s2_25,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordLoadingState) {
            FlowStateExtesion(LoadingState(
                    stateRendererType: StateRendererType.popupLoadingState,message: AppStrings.loading.tr()))
                .getScreenWidget(context, () {});
          }
          if (state is ForgotPasswordFailureState) {
            FlowStateExtesion(ErrorState(
                    state.failure.message, StateRendererType.popupErrorState))
                .getScreenWidget(context, () {});
          }
          if (state is ForgotPasswordSuccessState) {
            FlowStateExtesion(SuccessState(
              AppStrings.emailSentScript.tr(),
            )).getScreenWidget(context, () {});
          }
        },
        builder: (context, state) {
          return _getContentWidget();
        },
      ),
    );
  }

  _getContentWidget() {
    var bloc = BlocProvider.of<ForgotPasswordBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: SizedBox(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p125, vertical: AppPadding.p4),
                  child: Divider(
                    thickness: AppSize.s2,
                  ),
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      AppStrings.forgotPasswordHeader.tr(),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSize.s16,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: Text(
                    AppStrings.forgotPasswordDesc.tr(),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                const SizedBox(
                  height: AppSize.s20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onTapOutside: (_){
                      unFocusKeyboard();
                    },
                    controller: _emailController,
                    validator: (email) {
                      return isEmailValid(email);
                    },
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      hintText: AppStrings.email.tr(),
                      labelText: AppStrings.email.tr(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                      onPressed:
                          bloc.isEmailSent ? forgotPasswordOnPress : null,
                      child: Text(bloc.isEmailSent
                          ? AppStrings.send.tr()
                          : AppStrings.waitAMinute.tr()),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p28),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: TextButton(
                      style: const ButtonStyle(alignment: Alignment.centerLeft),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios, size: AppSize.s8),
                          Text(AppStrings.back.tr()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void forgotPasswordOnPress() {
    var bloc = BlocProvider.of<ForgotPasswordBloc>(context);
    if (_formKey.currentState!.validate()) {
      bloc.add(ForgotPasswordEvent(_emailController.text));
      // unFocusKeyboard();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    unFocusKeyboard();
    super.dispose();
  }
}
