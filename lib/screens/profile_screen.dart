import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'splash_login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user.displayName}'),
                  Text('Email: ${user.email}'),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SplashLoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              )
            : const Text('No user logged in'),
      ),
    );
  }
}
