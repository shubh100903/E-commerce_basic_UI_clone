/// data/services/profile_service.dart
/// Fetches the user's profile and activity.

import '../models/user_profile_model.dart';
import 'api_client.dart';
import '../../core/constants/app_endpoints.dart';

class ProfileService {
  ProfileService(this._client);

  final ApiClient _client;

  Future<UserProfileModel> fetchProfile() async {
    final data = await _client.get(AppEndpoints.profile) as Map<String, dynamic>;
    return UserProfileModel.fromJson(data);
  }
}

