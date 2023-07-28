import 'dart:io';

import 'package:chat_app/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../data/network/failure.dart';
import '../base_use_case.dart';

class UploadImageUseCase implements BaseUseCase<File,String>{
  final UserRepository _userRepository;

  UploadImageUseCase(this._userRepository);
  @override
  Future<Either<Failure,String>> execute(File imageFile)async {
    return await _userRepository.uploadImage(imageFile);
  }
}