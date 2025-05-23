import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'auth_datasource.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserModel> register(String email, String password) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user!;
    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(id: user.uid, email: user.email ?? '');
  }
}
