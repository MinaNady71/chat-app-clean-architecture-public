import 'package:chat_app/presentation/resources/languages_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'app/di.dart';
import 'app/my_app.dart';
import 'data/data_source/remote_data_source/FCM/fcm.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
 // print("Handling a background message: ${message.messageId}");

}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  FCM().backgroundMessages(_firebaseMessagingBackgroundHandler);
  runApp(EasyLocalization(
      supportedLocales: const [englishLocale, arabicLocale],
      path: assetsPathLocalization,
      child: MyApp()));
}
