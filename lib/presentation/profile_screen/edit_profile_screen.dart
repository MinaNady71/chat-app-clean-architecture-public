import 'dart:io';

import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/models/models.dart';
import 'package:chat_app/presentation/common/widgets/full_screen_image.dart';
import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/di.dart';
import '../../app/functions.dart';
import '../common/state_renderer/state_renderer.dart';
import '../common/state_renderer/state_renderer_impl.dart';
import '../common/widgets/components.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';
import 'bloc/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  File? _localImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          AppStrings.editProfile.tr(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: _getScreenContent(),
    );
  }

  Widget _getScreenContent() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        var bloc = BlocProvider.of<ProfileBloc>(context);
        if (state is ProfileSuccessState) {
          _usernameController.text = state.userModel.username;
          _emailController.text = state.userModel.email;
          _bioController.text = state.userModel.bio;
          _mobilNumberController.text = state.userModel.phone;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: AppPadding.p25,
                  top: AppPadding.p25,
                  bottom: AppPadding.p100,
                  left: AppPadding.p25),
              child: Column(
                children: [
                  Align(
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
                                        builder: (context) => FullscreenImage(
                                          image: state.userModel.image,
                                          localImage: _localImage,
                                        ),
                                        fullscreenDialog: true,
                                      ));
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      Image.asset(ImageAssets.userAvatar).image,
                                  foregroundImage: _localImage != null
                                      ? Image.file(_localImage!).image
                                      : NetworkImage(state.userModel.image),
                                  maxRadius: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(AppSize.s40),
                            onTap: () {
                              _showPicker(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .selectedItemColor,
                              radius: AppSize.s22,
                              child: const Icon(
                                Icons.camera_alt,
                                size: AppSize.s22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p15,
                    ),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            customTextFieldInput(
                              context: context,
                              keyboardType: TextInputType.name,
                              controller: _usernameController,
                              validator: (username) {
                                return isUsernameValid(username);
                              },
                              maxLength: AppLength.l100,
                              labelText: AppStrings.username.tr(),
                              prefixIcon: const Icon(Icons.person),
                              suffixIcon: const Icon(Icons.edit),
                            ),
                            const SizedBox(
                              height: AppSize.s18,
                            ),
                            customTextFieldInput(
                              enabled: false,
                              context: context,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              maxLength: AppLength.l100,
                              validator: (email) {
                                return isEmailValid(email);
                              },
                              labelText: AppStrings.email.tr(),
                              prefixIcon: const Icon(Icons.email),
                              prefixIconColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .disabledBorder!
                                  .borderSide
                                  .color,
                              labelColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .disabledBorder!
                                  .borderSide
                                  .color,
                            ),
                            const SizedBox(
                              height: AppSize.s16,
                            ),
                            customTextFieldInput(
                              context: context,
                              keyboardType: TextInputType.text,
                              controller: _bioController,
                              prefixIcon: const Icon(Icons.info_outline),
                              maxLength: AppLength.l100,
                              labelText: AppStrings.bio.tr(),
                              suffixIcon: const Icon(Icons.edit),
                            ),
                            const SizedBox(
                              height: AppSize.s16,
                            ),
                            customTextFieldInput(
                              context: context,
                              keyboardType: TextInputType.number,
                              controller: _mobilNumberController,
                              prefixIcon: const Icon(Icons.phone),
                              maxLength: AppLength.l100,
                              labelText: AppStrings.mobileNumber.tr(),
                              suffixIcon: const Icon(Icons.edit),
                            ),
                            const SizedBox(
                              height: AppSize.s35,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _updateUserProfile(state.userModel, bloc);
                                },
                                child: Text(AppStrings.update.tr())),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileFailureState) {
          return Center(
            child: SingleChildScrollView(
              child: FlowStateExtesion(ErrorState(state.failure.message,
                      StateRendererType.fullScreenErrorState))
                  .getScreenWidget(context, () {
                bloc.add(GetCurrentUsersProfileEvent());
              }),
            ),
          );
        } else if (state is UpdateProfileFailureState) {
          return Center(
            child: SingleChildScrollView(
              child: FlowStateExtesion(ErrorState(state.failure.message,
                      StateRendererType.fullScreenErrorState))
                  .getScreenWidget(context, () {
                bloc.add(GetCurrentUsersProfileEvent());
              }),
            ),
          );
        } else if (state is UpdateCurrentUsersProfileWithImageLoadingState ||
            state is UpdateProfileLoadingState) {
          return Center(
            child: SingleChildScrollView(
                child: FlowStateExtesion(LoadingState(
                        stateRendererType:
                            StateRendererType.fullScreenLoadingState,
                        message: AppStrings.loading.tr()))
                    .getScreenWidget(context, () {})),
          );
        } else if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  leading: Icon(
                    Icons.camera,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(AppStrings.photoGallery.tr()),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(AppStrings.photoCamera.tr()),
                  onTap: () {
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imageFromGallery() async {
    if (await Permission.storage.request().isGranted || await Permission.photos.request().isGranted) {
      var image = await _imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: AppSize.s50.toInt());
      setState(() {
        if (image != null && image.path.isNotEmpty) {
          _localImage = File(image.path);
        }
      });
    }
  }

  _imageFromCamera() async {
    if (await Permission.camera.request().isGranted) {
      var image = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: AppSize.s50.toInt());
      setState(() {
        if (image != null && image.path.isNotEmpty) {
          _localImage = File(image.path);
        }
      });
    }
  }

  _updateUserProfile(UserModel userModel, ProfileBloc bloc) async {
    if(_formKey.currentState!.validate()) {
      if (isDataChanged(userModel)) {
      if (_localImage != null) {
        UserResponse userResponse = UserResponse(
          bio: _bioController.text,
          phone: _mobilNumberController.text,
          username: _usernameController.text,
        );
        bloc.add(UpdateCurrentUsersProfileWithImageEvent(
            _localImage!, userResponse));
        _localImage = null;
      } else {
        UserResponse userResponse = UserResponse(
          bio: _bioController.text,
          phone: _mobilNumberController.text,
          username: _usernameController.text,
        );
        bloc.add(UpdateCurrentUsersProfileEvent(userResponse));
      }
    } else {
      return FlowStateExtesion(ErrorState(AppStrings.changeCharAlert.tr(),
              StateRendererType.popupErrorState))
          .getScreenWidget(context, () {});
    }
    }
  }

  bool isDataChanged(UserModel userModel) {
    if (userModel.phone != _mobilNumberController.text ||
        userModel.username != _usernameController.text ||
        userModel.bio != _bioController.text ||
        userModel.bio != _bioController.text ||
        _localImage != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _mobilNumberController.dispose();
    super.dispose();
  }
}
