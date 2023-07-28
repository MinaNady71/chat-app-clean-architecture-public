import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/network/failure.dart';
import '../../../data/responses/responses.dart';
import '../../../domain/models/models.dart';
import '../../../domain/use_cases/auth/log_out_use_case.dart';
import '../../../domain/use_cases/user/get_current_user_use_case.dart';
import '../../../domain/use_cases/user/update_current_user_use_case.dart';
import '../../../domain/use_cases/user/upload_image_use_case.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase _currentUserUseCase;
  final UpdateCurrentUserUseCase _updateCurrentUserUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final SignOutUseCase _signOutUseCase;
  UserModel? currentUserModel;

  ProfileBloc(this._currentUserUseCase, this._updateCurrentUserUseCase,
      this._signOutUseCase, this._uploadImageUseCase)
      : super(ProfileInitialState()) {
    on<GetCurrentUsersProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      (await _currentUserUseCase.execute(null)).fold((failure) {
        emit(ProfileFailureState(failure));
      }, (response) {
        currentUserModel = response;
        emit(ProfileSuccessState(response));
      });
    });

    on<UpdateCurrentUsersProfileEvent>((event, emit) async {
      emit(UpdateProfileLoadingState());
      (await _updateCurrentUserUseCase.execute(event.userResponse)).fold(
          (failure) {
        emit(UpdateProfileFailureState(failure));
      }, (_) {
        add(GetCurrentUsersProfileEvent());
      });
    });

    on<UpdateCurrentUsersProfileWithImageEvent>((event, emit) async {
      emit(UpdateProfileLoadingState());
      (await _uploadImageUseCase.execute(event.imageFile)).fold((failure) {},
          (imageUrl) {
        UserResponse userResponse = UserResponse(
          username: event.userResponse.username,
          phone: event.userResponse.phone,
          image: imageUrl,
          bio: event.userResponse.bio,
        );
        add(UpdateCurrentUsersProfileEvent(userResponse));
      });
    });

    on<SignOutProfileEvent>((event, emit) async {
      emit(SignOutProfileLoadingState());
      (await _signOutUseCase.execute()).fold(
          (l) => emit(SignOutProfileFailureState(l)),
          (r) => emit(SignOutProfileSuccessState()));
    });
  }
}
