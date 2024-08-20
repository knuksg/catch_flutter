import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart'; // 변경된 메인 화면 임포트

class SplashLoginScreen extends ConsumerWidget {
  const SplashLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final screenSize = MediaQuery.of(context).size;

    // 로그인 상태가 변경되면 메인 화면으로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen()), // 메인 화면으로 변경
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double logoSize = screenSize.width * 0.6;
          double catImageSize = screenSize.width * 0.4;

          if (screenSize.width < 600) {
            logoSize = screenSize.width * 0.5;
            catImageSize = screenSize.width * 0.3;
          }

          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/01_title_logo.png',
                      width: logoSize,
                      height: logoSize,
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/01_title_cat.png',
                      width: catImageSize,
                      height: catImageSize,
                    ),
                  ],
                ),
              ),
              if (user == null)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(authProvider.notifier)
                            .signInWithGoogle();
                      },
                      child: const Text('Sign in with Google'),
                    ),
                  ),
                )
              else
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(20),
                          child: const Text(
                            '로그인 처리 중',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
