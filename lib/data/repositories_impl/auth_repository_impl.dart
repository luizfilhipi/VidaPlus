import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<UserEntity> register(String email, String password) {
    return dataSource.register(email, password);
  }

  @override
  Future<void> logout() {
    return dataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return dataSource.getCurrentUser();
  }
}
