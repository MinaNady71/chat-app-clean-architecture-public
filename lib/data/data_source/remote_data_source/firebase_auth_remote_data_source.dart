import 'package:chat_app/data/network/requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthDatasource {
  Future<UserCredential> login(LoginRequest loginRequest);
  Future<UserCredential> signUp(SignupRequest signupRequest);
  Future<UserCredential> signInWithGoogle();
  Future<void> forgotPassword(String email);
  Future<void> signOut();
}

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {

static final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> login(LoginRequest loginRequest) async {
    return await auth.signInWithEmailAndPassword(
        email: loginRequest.email, password: loginRequest.password);
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential =
       GoogleAuthProvider.credential(accessToken: googleAuth!.accessToken,idToken: googleAuth.idToken );
    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }

  @override
  Future<void> forgotPassword(email)async {
    await auth
        .sendPasswordResetEmail(email:email);
  }

  @override
  Future<UserCredential> signUp(SignupRequest signupRequest)async {
    return await auth.createUserWithEmailAndPassword(
        email: signupRequest.email, password: signupRequest.password);
  }

  @override
  Future<void> signOut()async{
    await auth.signOut();
    await GoogleSignIn().signOut();
  }

}
