import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttercocktail/login/firebase_errors.dart';
import 'package:fluttercocktail/login/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user = new User(email: '', password: '', name: '', cpf: '', id: '');

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;
      this.user = user;

      await user.saveData();

      user.saveToken();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut() {
    auth.signOut();
    user;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').document(currentUser.uid).get();
      user = User.fromDocument(docUser);

      user.saveToken();

      final docAdmin =
          await firestore.collection('admins').document(user.id).get();
      if (docAdmin.exists) {
        user.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user.admin;
}
