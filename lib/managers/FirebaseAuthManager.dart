import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword({required String email, required String password}) async {
    print("email: $email, password: $password");
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("userCredential: $userCredential");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  //Future<User> signInWithGoogle() async {
  //  try {
     // final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
     // final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
   //   final AuthCredential credential = GoogleAuthProvider.credential(
      //  accessToken: googleSignInAuthentication.accessToken,
      //  idToken: googleSignInAuthentication.idToken,
    //  );
    //  final UserCredential authResult = await _auth.signInWithCredential(credential);
     // final User user = authResult.user;
     // return user;
   // } catch (e) {
   //   print(e.toString());
    //  return null;
  //  }
  //}

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
