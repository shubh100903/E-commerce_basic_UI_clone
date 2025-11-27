/// presentation/screens/profile/profile_screen.dart
/// Displays user bio, tier, and order history summaries.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/profile_provider.dart';
import '../../providers/navigation_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final navigation = context.watch<NavigationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: navigation.goHome,
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.profile == null
              ? Center(
                  child: Text(
                    provider.error ?? 'Profile unavailable.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(provider.profile!.avatarUrl),
                          ),
                          const SizedBox(width: AppSizes.lg),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.profile!.fullName,
                                  style: Theme.of(context).textTheme.titleLarge),
                              Text(provider.profile!.email,
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: AppSizes.xl),
                      Container(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Membership', style: TextStyle(color: AppColors.textSecondary)),
                                  Text(provider.profile!.tier, style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Orders', style: TextStyle(color: AppColors.textSecondary)),
                                  Text('${provider.profile!.ordersCount}',
                                      style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),
                      Text(AppStrings.orderHistory, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: AppSizes.lg),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                            leading: const Icon(Icons.local_shipping_outlined),
                            title: Text('Order #00${index + 1}'),
                            subtitle: const Text('Delivered • Track details'),
                            trailing: Text('\$${(120 + index * 30).toStringAsFixed(0)}'),
                          ),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: provider.profile!.ordersCount.clamp(1, 6),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}

