// onBoarding screen

class SliderObject{
    String title;
    String subTitle;
    String image;
    SliderObject(this.title,this.subTitle,this.image,);

}

// onBoarding screen
class SliderViewObject{
    SliderObject sliderObject;
    int numbOfSlides;
    int currentIndex;
    SliderViewObject({
   required this.sliderObject,
   required  this.numbOfSlides,
   required this.currentIndex,
  });

}



// userModel
class UserModel {
  String username;
  String email;
  String phone;
  String uid;
  String image;
  String bio;
  String token;
  String creationTimestamp;
  bool status;
  bool verified;

  UserModel({
   required this.username,
   required this.email,
   required this.phone,
   required this.uid,
   required this.image,
   required this.bio,
   required this.token,
   required this.creationTimestamp,
   required this.status,
   required this.verified,
  });
}


// message Model
class MessagesModel {
  String fromUid;
  String toUid;
  String chatUid;
  bool isViewed;
  int createdAt;
  String message;
  dynamic timestamp;

  MessagesModel({
   required this.toUid,
   required this.fromUid,
   required this.chatUid,
   required this.isViewed,
   required this.createdAt,
   required this.message,
   required this.timestamp,
  });
}// message Model

class CountUnreadMessagesModel {
  int unreadMessagesCount;
  bool amIInChatRoom;


  CountUnreadMessagesModel({
   required this.unreadMessagesCount,
   required this.amIInChatRoom,
  });
}