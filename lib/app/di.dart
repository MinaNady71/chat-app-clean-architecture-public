import 'package:chat_app/app/theme/theme_cubit.dart';
import 'package:chat_app/data/repositoriesImpl/user_repository_impl.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/use_cases/auth/log_out_use_case.dart';
import 'package:chat_app/domain/use_cases/chat/add_chat_use_case.dart';
import 'package:chat_app/domain/use_cases/chat/get_all_friends_use_case.dart';
import 'package:chat_app/domain/use_cases/chat/get_messages_use_case.dart';
import 'package:chat_app/domain/use_cases/user/get_all_users_use_case.dart';
import 'package:chat_app/domain/use_cases/user/get_current_user_use_case.dart';
import 'package:chat_app/domain/use_cases/user/update_token_use_case.dart';
import 'package:chat_app/domain/use_cases/user/upload_image_use_case.dart';
import 'package:chat_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:chat_app/presentation/auth/register/bloc/register_bloc.dart';
import 'package:chat_app/presentation/chat_list_screen/bloc/chat_bloc.dart';
import 'package:chat_app/presentation/chat_room_screen/bloc/chat_room_bloc.dart';
import 'package:chat_app/presentation/profile_screen/bloc/profile_bloc.dart';
import 'package:chat_app/presentation/users_screen/bloc/users_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/remote_data_source/FCM/fcm.dart';
import '../data/data_source/remote_data_source/firebase_auth_remote_data_source.dart';
import '../data/data_source/remote_data_source/firebase_firestore_remote_data_source.dart';
import '../data/data_source/remote_data_source/firebase_storage_remote_data_source.dart';
import '../data/network/network_info.dart';
import '../data/repositoriesImpl/auth_repository_impl.dart';
import '../data/repositoriesImpl/chat_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/use_cases/auth/forgot_password_use_case.dart';
import '../domain/use_cases/auth/login_use_case.dart';
import '../domain/use_cases/auth/register_use_case.dart';
import '../domain/use_cases/auth/sign_in_with_google_use_case.dart';
import '../domain/use_cases/chat/add_in_friends_list.dart';
import '../domain/use_cases/chat/add_unread_count_messages_chat_use_case.dart';
import '../domain/use_cases/chat/am_i_in_chat_room_chat_use_case.dart';
import '../domain/use_cases/chat/get_unread_count_messages_use_case.dart';
import '../domain/use_cases/chat/reset_unread_count_messages_chat_use_case.dart';
import '../domain/use_cases/user/add_user_use_case.dart';
import '../domain/use_cases/user/update_current_user_use_case.dart';
import '../domain/use_cases/user/update_status_use_case.dart';
import '../presentation/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'app_prefs.dart';
import 'functions.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // firebase init
  await Firebase.initializeApp();

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  //NTP api
  ntpOffset();
  //FCM
  FCM().foregroundMessages();


  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  //Bloc
  instance.registerLazySingleton<UsersBloc>(() => UsersBloc(instance()));
  instance.registerLazySingleton<ChatBloc>(() => ChatBloc(instance(),instance()));
  instance.registerLazySingleton<ProfileBloc>(() => ProfileBloc(instance(),instance(),instance(),instance(),));
  instance.registerLazySingleton<ChatRoomBloc>(
      () => ChatRoomBloc(instance(), instance(),instance(),instance(),instance(),instance()));

  instance.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit());
  //Auth
  instance.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(instance(), instance(),instance(),instance()));
  instance.registerLazySingleton<NetWorkInfo>(
      () => NetWorkInfoImpl(InternetConnectionChecker()));
  instance.registerLazySingleton<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(instance()));

  // repositories
  instance.registerLazySingleton<UserRepository>(
      () => UserRepositoriesImpl(instance(),instance(), instance()));
  instance.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(instance(), instance()));

  //firebase auth
  instance.registerLazySingleton<FirebaseAuthDatasource>(
          () => FirebaseAuthDatasourceImpl());
//firebase firestore
  instance.registerLazySingleton<FirebaseFirestoreDatasource>(
      () => FirebaseFirestoreDatasourceImpl());
  //firebase storage
  instance.registerLazySingleton<FirebaseStorageDatasource>(
          () => FirebaseStorageDatasourceImpl());

  /////////
  //UseCase////
  /////////////
  instance
      .registerLazySingleton<AddUserUseCase>(() => AddUserUseCase(instance()));

  instance.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(instance()));

  instance.registerLazySingleton<AddMessageUseCase>(
      () => AddMessageUseCase(instance()));
  instance.registerLazySingleton<GetMessageUseCase>(
      () => GetMessageUseCase(instance()));
  instance.registerLazySingleton<AddInFriendsListUseCase>(
      () => AddInFriendsListUseCase(instance()));
  instance.registerLazySingleton<GetAllFriendsUseCase>(
      () => GetAllFriendsUseCase(instance()));
  instance.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(instance()));
  instance.registerLazySingleton<UpdateTokenUseCase>(
      () => UpdateTokenUseCase(instance()));
  instance.registerLazySingleton<UpdateCurrentUserUseCase>(
      () => UpdateCurrentUserUseCase(instance()));
  instance.registerLazySingleton<UploadImageUseCase>(
      () => UploadImageUseCase(instance()));
  instance.registerLazySingleton<AddUnreadCountMessagesUseCase>(
      () => AddUnreadCountMessagesUseCase(instance()));
  instance.registerLazySingleton<AmIInChatRoomUseCase>(
      () => AmIInChatRoomUseCase(instance()));
  instance.registerLazySingleton<ResetUnreadCountMessagesUseCase>(
      () => ResetUnreadCountMessagesUseCase(instance()));
  instance.registerLazySingleton<GetUnreadMessagesUseCase>(
      () => GetUnreadMessagesUseCase(instance()));
  instance.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(instance()));
  instance.registerLazySingleton<UpdateStatusUseCase>(
      () => UpdateStatusUseCase(instance()));

  //image picker
  instance.registerLazySingleton<ImagePicker>(
          () => ImagePicker());
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    // Bloc
    instance
        .registerFactory<LoginBloc>(() => LoginBloc(instance(), instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterAuthUseCase>()) {
    instance.registerFactory<RegisterAuthUseCase>(
        () => RegisterAuthUseCase(instance()));
    // Bloc
    instance.registerFactory<RegisterBloc>(
        () => RegisterBloc(instance(), (instance())));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    // Bloc
    instance.registerFactory<ForgotPasswordBloc>(
        () => ForgotPasswordBloc(instance()));
  }
}
