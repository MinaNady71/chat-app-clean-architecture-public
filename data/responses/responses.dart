// flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
import "package:json_annotation/json_annotation.dart";
part 'responses.g.dart';

///
/// UserResponse
///
@JsonSerializable()
class UserResponse {
  @JsonKey(name: 'username')
  String? username;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'uid')
  String? uid;
  @JsonKey(name: 'image')
  String? image;
  @JsonKey(name: 'bio')
  String? bio;
  @JsonKey(name: 'token')
  String? token;
  @JsonKey(name: 'creation_timestamp')
  String? creationTimestamp;
  @JsonKey(name: 'status')
  bool? status;
  @JsonKey(name: 'verified')
  bool? verified;

  UserResponse({
     this.username,
     this.email,
     this.phone,
     this.uid,
     this.image,
     this.bio,
     this.token,
     this.status,
     this.creationTimestamp,
     this.verified,
  });

//fromJson
  factory UserResponse.fromJson(Map<String,dynamic> json) =>
      _$UserResponseFromJson(json);

  // toJson
  Map<String,dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class MessagesResponse {
  @JsonKey(name: 'fromUid')
  String? fromUid;
  @JsonKey(name: 'toUid')
  String? toUid;
  @JsonKey(name: 'chatUid')
  String? chatUid;
  @JsonKey(name: 'isViewed')
  bool? isViewed;
  @JsonKey(name: 'createdAt')
  int? createdAt;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'timestamp')
  dynamic timestamp;

  MessagesResponse({
     this.message,
     this.createdAt,
     this.isViewed,
     this.chatUid,
     this.fromUid,
     this.toUid,
     this.timestamp,
  });

//fromJson
  factory MessagesResponse.fromJson(Map<String,dynamic> json) =>
      _$MessagesResponseFromJson(json);

  // toJson
  Map<String,dynamic> toJson() => _$MessagesResponseToJson(this);
}

@JsonSerializable()
class CountUnreadMessagesResponse {
  @JsonKey(name: 'unreadMessagesCount')
  int? unreadMessagesCount;
  @JsonKey(name: 'amIInChatRoom')
  bool? amIInChatRoom;

  CountUnreadMessagesResponse({
    this.unreadMessagesCount,
    this.amIInChatRoom,
  });

//fromJson
  factory CountUnreadMessagesResponse.fromJson(Map<String,dynamic> json) =>
      _$CountUnreadMessagesResponseFromJson(json);

  // toJson
  Map<String,dynamic> toJson() => _$CountUnreadMessagesResponseToJson(this);
}
