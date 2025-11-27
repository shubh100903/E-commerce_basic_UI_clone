/// data/repositories/profile_repository.dart
/// Provides user profile details for presentation.

import '../models/user_profile_model.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  ProfileRepository(this._service);

  final ProfileService _service;

  Future<UserProfileModel> fetchProfile() => _service.fetchProfile();
}

