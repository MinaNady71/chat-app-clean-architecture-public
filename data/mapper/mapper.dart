import 'package:chat_app/app/constants.dart';
import 'package:chat_app/app/extensions.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/models/models.dart';

extension UserResponseMapper on UserResponse? {
  UserModel toDomain() {
    return UserModel(
        username: this?.username.orEmpty() ?? Constants.empty,
        email: this?.email.orEmpty() ?? Constants.empty,
        phone: this?.phone ?? Constants.defaultPhone,
        uid: this?.uid.orEmpty() ?? Constants.empty,
        image: this?.image ?? Constants.defaultImage,
        bio: this?.bio ?? Constants.defaultBio,
        token: this?.token.orEmpty() ?? Constants.empty,
        creationTimestamp: this?.creationTimestamp.orEmpty() ?? Constants.empty ,
        status: this?.status.orFalse() ?? Constants.orFalse,
        verified:this?.verified.orFalse() ?? Constants.orFalse,
    );
  }
}


extension MessageResponseMapper on MessagesResponse? {
  MessagesModel toDomain() {
    return MessagesModel(
        message:this?.message.orEmpty() ?? Constants.empty,
        chatUid:this?.chatUid.orEmpty() ?? Constants.empty,
        createdAt:this?.createdAt.orZero() ?? Constants.zero,
        fromUid:this?.fromUid.orEmpty() ?? Constants.empty,
        isViewed:this?.isViewed.orTrue() ?? Constants.orTrue,
        toUid:this?.toUid ?? Constants.defaultBio,
        timestamp: this?.timestamp ?? Constants.defaultBio,

    );
  }
}
extension CountUnreadMessagesResponseMapper on CountUnreadMessagesResponse? {
  CountUnreadMessagesModel toDomain() {
    return CountUnreadMessagesModel(
      unreadMessagesCount: this?.unreadMessagesCount.orZero() ?? Constants.zero,
      amIInChatRoom: this?.amIInChatRoom.orFalse() ?? Constants.orFalse,

    );
  }
}
