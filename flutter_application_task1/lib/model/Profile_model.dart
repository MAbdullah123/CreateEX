class Profile {
  final String id;
  final String phoneNumber;
  final String name;
  final String email;
  final String profilePicture;

  Profile({
    required this.id,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["_id"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      profilePicture: json["profilePicture"] ?? '',
    );
  }
}
