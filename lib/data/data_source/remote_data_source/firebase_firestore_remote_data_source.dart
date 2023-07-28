import 'package:chat_app/app/constants.dart';
import 'package:chat_app/app/extensions.dart';
import 'package:chat_app/data/data_source/remote_data_source/firebase_constant.dart';
import 'package:chat_app/data/mapper/mapper.dart';
import 'package:chat_app/data/responses/responses.dart';
import 'package:chat_app/domain/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseFirestoreDatasource {
  Future<void> addUser(UserResponse userResponse);

  Future<void> updateCurrentUser(UserResponse userResponse);

  Future<void> updateToken(String token);
  Future<void> updateStatus(bool status);

  Future<void> addChatMessage(MessagesResponse messagesResponse);

  Future<void> addInFriendsList(String toUid);

  Future<void> addUnreadCountMessages(String toUid);
  Future<void> resetUnreadCountMessages(String toUid);
  Future<void> amIInChatRoom(String toUid,bool inChatRoom);

  Future<List<UserModel>> getAllUsers();

  Future<UserModel> getCurrentUser();

  Future<List<UserModel>> getAllFriends();

  Stream<List<MessagesModel>> getMessages(String toUid);

  Stream<List<CountUnreadMessagesModel>> getUnreadCountMessages();
}

class FirebaseFirestoreDatasourceImpl implements FirebaseFirestoreDatasource {
  final db = FirebaseFirestore.instance;
  final _userCollection =
      FirebaseFirestore.instance.collection(FirebaseConstants.userCollection);
  final _chatCollection =
      FirebaseFirestore.instance.collection(FirebaseConstants.chatsCollection);

  get userUid => FirebaseAuth.instance.currentUser?.uid;
  List friendsList = [];

  @override
  Future<void> addUser(UserResponse userResponse) async {
    await db
        .collection(FirebaseConstants.userCollection)
        .doc(userResponse.uid)
        .set(userResponse.toJson().removeNullValue());
  }

  @override
  Future<void> updateCurrentUser(UserResponse userResponse) async {
    await db
        .collection(FirebaseConstants.userCollection)
        .doc(userUid)
        .update(userResponse.toJson().removeNullValue());
  }

  @override
  Future<void> updateToken(String token) async {
    await db
        .collection(FirebaseConstants.userCollection)
        .doc(userUid)
        .update({FirebaseConstants.token: token});
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot querySnapshot = await _userCollection
        .where(FirebaseConstants.uid, isNotEqualTo: userUid)
        .get();
    return querySnapshot.docs
        .map((doc) => UserResponse.fromJson(doc.data() as Map<String, dynamic>)
            .toDomain())
        .toList();
  }

  @override
  Future<void> addChatMessage(MessagesResponse messagesResponse) async {
    await Future.wait([
      //For me
      _chatCollection
          .doc(messagesResponse.fromUid)
          .collection(FirebaseConstants.messageCollection)
          .doc(messagesResponse.toUid)
          .collection(FirebaseConstants.messagesListCollection)
          .add(messagesResponse.toJson().removeNullValue()),
      //For friend
      _chatCollection
          .doc(messagesResponse.toUid)
          .collection(FirebaseConstants.messageCollection)
          .doc(messagesResponse.fromUid)
          .collection(FirebaseConstants.messagesListCollection)
          .add(messagesResponse.toJson().removeNullValue()),
    ]);
  }

  @override
  Stream<List<MessagesModel>> getMessages(toUid) {
    return _chatCollection
        .doc(userUid)
        .collection(FirebaseConstants.messageCollection)
        .doc(toUid)
        .collection(FirebaseConstants.messagesListCollection)
        .limit(50)
        .orderBy(FirebaseConstants.timestamp, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessagesResponse.fromJson(doc.data()).toDomain())
            .toList());
  }

  @override
  Future<List<UserModel>> getAllFriends() async {
     friendsList = [];
    await _chatCollection.doc(userUid)
        .get()
        .then((value) {
      if (value.data() != null) {
        friendsList = value.data()![FirebaseConstants.friendsList].toList();
      } else {
        friendsList = [Constants.empty];
      }
    });
    QuerySnapshot querySnapshot = await _userCollection.where(FirebaseConstants.uid, whereIn: friendsList)
        .get();
    return querySnapshot.docs
        .map((doc) => UserResponse.fromJson(doc.data() as Map<String, dynamic>)
            .toDomain())
        .toList();
  }

  @override
  Future<void> addInFriendsList(String toUid) async {
    await Future.wait([
      //For me
      _chatCollection.doc(userUid).set({
        FirebaseConstants.friendsList: FieldValue.arrayUnion([toUid])
      }, SetOptions(merge: true)),
      //For friend
      _chatCollection.doc(toUid).set({
        FirebaseConstants.friendsList: FieldValue.arrayUnion([userUid])
      }, SetOptions(merge: true)),
    ]);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    DocumentSnapshot doc = await _userCollection.doc(userUid).get();
    return UserResponse.fromJson(doc.data() as Map<String, dynamic>).toDomain();
  }

  @override
  Future<void> addUnreadCountMessages(String toUid) async {
    await _chatCollection
        .doc(toUid)
        .collection(FirebaseConstants.messageCollection)
        .doc(userUid)
        .set({FirebaseConstants.unreadMessagesCount: FieldValue.increment(1)}, SetOptions(merge: true));
  }
  @override
  Future<void> resetUnreadCountMessages(String toUid) async {
    await _chatCollection
        .doc(toUid)
        .collection(FirebaseConstants.messageCollection)
        .doc(userUid)
        .set({FirebaseConstants.unreadMessagesCount: 0}, SetOptions(merge: true));
  }

  @override
  Future<void> amIInChatRoom(String toUid,bool inChatRoom) async {
    await _chatCollection
        .doc(userUid)
        .collection(FirebaseConstants.messageCollection)
        .doc(toUid)
        .set({FirebaseConstants.amIInChatRoom: inChatRoom},SetOptions(merge:true));
  }

  @override
  Stream<List<CountUnreadMessagesModel>> getUnreadCountMessages() {
    return _chatCollection
        .doc(userUid)
        .collection(FirebaseConstants.messageCollection)
        .snapshots()
        .map((snapshot) =>snapshot.docs.map((doc) => CountUnreadMessagesResponse.fromJson(doc.data()).toDomain()).toList());
  }

  @override
  Future<void> updateStatus(bool status) async {
    await db
        .collection(FirebaseConstants.userCollection)
        .doc(userUid)
        .update({FirebaseConstants.status: status});
  }
}
