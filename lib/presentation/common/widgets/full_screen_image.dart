import 'dart:io';

import 'package:chat_app/presentation/resources/strings_manager.dart';
import 'package:chat_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';

class FullscreenImage extends StatelessWidget {
  const FullscreenImage({super.key, required this.image, this.localImage});

  final String image;
  final File? localImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profilePhoto.tr()),
      ),
      body: InteractiveViewer(
        panEnabled: false,
        child: Center(
          child: CircleAvatar(
            backgroundImage: Image.asset(ImageAssets.userAvatar).image,
            foregroundImage: localImage != null
                ? Image.file(localImage!).image
                : NetworkImage(image),
            maxRadius: AppSize.s100,
          ),
        ),
      ),
    );
  }
}
