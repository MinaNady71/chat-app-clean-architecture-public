import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

enum StateRendererType {
  //popup states(Dialog)
  popupLoadingState,
  popupErrorState,
  popupSuccessState,
  //Full screen states
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,

  // general
  contentState,
}


class StateRenderer extends StatelessWidget {
 final StateRendererType stateRendererType;
 final  String message;
 final  String title;
 final Function retryActionFunction;

  const StateRenderer(
      {super.key, required this.stateRendererType, this.message = AppStrings
          .loading, this.title = "", required this.retryActionFunction});

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopupDialog([
          _getAnimatedImage(JsonAssets.loading),
        ],context);
      case StateRendererType.popupErrorState:
        return _getPopupDialog([
          _getAnimatedImage(JsonAssets.error),
          if(message.isNotEmpty)
            _getMessage(message, context),
          _getRetryButton(AppStrings.ok.tr(), context)
        ],context);
      case StateRendererType.popupSuccessState:
        return _getPopupDialog([
          _getAnimatedImage(JsonAssets.success),
          _getTitle(title, context),
          if(message.isNotEmpty)
            _getMessage(message, context),
          _getRetryButton(AppStrings.ok.tr(), context)
        ],context);
      case StateRendererType.fullScreenLoadingState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.loading),
          if(message.isNotEmpty)
            _getMessage(message, context)
        ]);
      case StateRendererType.fullScreenErrorState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.error),
          if(message.isNotEmpty)
            _getMessage(message, context),
          _getRetryButton(AppStrings.reTryAgain.tr(), context)
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemColumn([
          _getAnimatedImage(JsonAssets.empty),
          if(message.isNotEmpty)
            _getMessage(message, context)
        ]
        );
      case StateRendererType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  Widget _getPopupDialog(List<Widget> children,context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(AppPadding.p14),
            shape: BoxShape.rectangle,
            boxShadow: const [BoxShadow(color: Colors.black26)],
          ),
          child: _getDialogContent(children)
      ),
    );
  }

  Widget _getDialogContent(List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animatedName) {
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animatedName, fit: BoxFit.fill,),
    );
  }

  Widget _getTitle(String message, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p2),
        child: Text(message, style: Theme
            .of(context)
            .textTheme
            .displayMedium, textAlign: TextAlign.center,),
      ),
    );
  }

  Widget _getMessage(String message, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Text(message, style: Theme
            .of(context)
            .textTheme
            .headlineMedium, textAlign: TextAlign.center,),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                if (stateRendererType ==
                    StateRendererType.fullScreenErrorState) {
                  // call retry function
                  retryActionFunction.call();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(buttonTitle,
              )
          ),
        ),
      ),
    );
  }

}
