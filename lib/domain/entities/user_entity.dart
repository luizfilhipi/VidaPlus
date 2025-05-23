class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
  });
}
