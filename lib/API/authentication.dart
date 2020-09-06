import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qutub_dashboard/common.dart';
import 'package:qutub_dashboard/models/userModel.dart';

//loginUser
Future<UserModel> loginUser({String userName, String password}) async {
  String email = userName + Common.domainName;

  UserCredential result = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);

  return UserModel(email: result.user.email, userToken: result.user.uid);
}

Future<dynamic> registerUser({String userName, String password}) async {
  String email = userName + Common.domainName;
  UserCredential result = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
  var v = await addUserFirestore(
      UserModel(email: result.user.email, userToken: result.user.uid));

  if (v == true) {
    return v;
  }
}

Future<dynamic> addUserFirestore(UserModel user) async {
  var status;
  await FirebaseFirestore.instance
      .collection('dashboard_users')
      .doc(user.userToken)
      .set(user.toMap())
      .then((value) {
    status = true;
  });
  return status;
}

//CheckUserLogin
Future<dynamic> checkUserLoggedIn() async {
  User user =  FirebaseAuth.instance.currentUser;
  if (user == null) {
    return false;
  }
  return UserModel(email: user.email, userToken: user.uid);
}

//userLogout
Future<dynamic> logoutUser() async {
  var status;
  await FirebaseAuth.instance.signOut().then((value) => status = true);

  return status;
}
