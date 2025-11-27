/// presentation/providers/profile_provider.dart
/// Maintains profile data and loading state.

import 'package:flutter/material.dart';

import '../../data/models/user_profile_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._repository);

  final ProfileRepository _repository;

  UserProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await _repository.fetchProfile();
    } catch (error) {
      _error = 'Profile unavailable. Please pull to refresh.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

