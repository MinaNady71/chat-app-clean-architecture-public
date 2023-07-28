// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      uid: json['uid'] as String?,
      image: json['image'] as String?,
      bio: json['bio'] as String?,
      token: json['token'] as String?,
      status: json['status'] as bool?,
      creationTimestamp: json['creation_timestamp'] as String?,
      verified: json['verified'] as bool?,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'uid': instance.uid,
      'image': instance.image,
      'bio': instance.bio,
      'token': instance.token,
      'creation_timestamp': instance.creationTimestamp,
      'status': instance.status,
      'verified': instance.verified,
    };

MessagesResponse _$MessagesResponseFromJson(Map<String, dynamic> json) =>
    MessagesResponse(
      message: json['message'] as String?,
      createdAt: json['createdAt'] as int?,
      isViewed: json['isViewed'] as bool?,
      chatUid: json['chatUid'] as String?,
      fromUid: json['fromUid'] as String?,
      toUid: json['toUid'] as String?,
      timestamp: json['timestamp'],
    );

Map<String, dynamic> _$MessagesResponseToJson(MessagesResponse instance) =>
    <String, dynamic>{
      'fromUid': instance.fromUid,
      'toUid': instance.toUid,
      'chatUid': instance.chatUid,
      'isViewed': instance.isViewed,
      'createdAt': instance.createdAt,
      'message': instance.message,
      'timestamp': instance.timestamp,
    };

CountUnreadMessagesResponse _$CountUnreadMessagesResponseFromJson(
        Map<String, dynamic> json) =>
    CountUnreadMessagesResponse(
      unreadMessagesCount: json['unreadMessagesCount'] as int?,
      amIInChatRoom: json['amIInChatRoom'] as bool?,
    );

Map<String, dynamic> _$CountUnreadMessagesResponseToJson(
        CountUnreadMessagesResponse instance) =>
    <String, dynamic>{
      'unreadMessagesCount': instance.unreadMessagesCount,
      'amIInChatRoom': instance.amIInChatRoom,
    };
