/// data/models/user_profile_model.dart
/// Captures essential information for the profile screen.

class UserProfileModel {
  UserProfileModel({
    required this.id,
    required this.fullName,
    required this.avatarUrl,
    required this.email,
    required this.tier,
    required this.ordersCount,
  });

  final String id;
  final String fullName;
  final String avatarUrl;
  final String email;
  final String tier;
  final int ordersCount;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        id: json['id']?.toString() ?? '',
        fullName: json['fullName'] ?? '',
        avatarUrl: json['avatar'] ?? '',
        email: json['email'] ?? '',
        tier: json['tier'] ?? 'Member',
        ordersCount: json['ordersCount'] ?? 0,
      );
}

