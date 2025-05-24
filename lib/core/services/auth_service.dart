import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../errors/validation_exception.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<UserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
      );
    });
  }

  Future<UserEntity> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw ValidationException('Erro ao fazer login');

      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw ValidationException(_getErrorMessage(e.code));
    }
  }

  Future<UserEntity> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw ValidationException('Erro ao criar conta');

      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw ValidationException(_getErrorMessage(e.code));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
    );
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email inválido';
      case 'user-disabled':
        return 'Usuário desativado';
      case 'user-not-found':
        return 'Usuário não encontrado';
      case 'wrong-password':
        return 'Senha incorreta';
      case 'email-already-in-use':
        return 'Email já está em uso';
      case 'operation-not-allowed':
        return 'Operação não permitida';
      case 'weak-password':
        return 'Senha muito fraca';
      default:
        return 'Erro de autenticação';
    }
  }
}
