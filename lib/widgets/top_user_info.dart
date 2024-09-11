import 'package:catch_flutter/core/colors.dart';
import 'package:catch_flutter/core/text_theme.dart';
import 'package:catch_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopUserInfoWidget extends ConsumerWidget {
  const TopUserInfoWidget({
    super.key,
    required this.user,
    this.isMainScreen = true,
  });

  final dynamic user;
  final bool isMainScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Container(
      decoration: BoxDecoration(
        color: isMainScreen ? AppColors.blue.withOpacity(0.5) : AppColors.blue,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 115.h,
            backgroundImage: AssetImage(
                user?.profileImg ?? 'assets/images/03_main_user_char_01.png'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.nickname ?? '닉네임',
                  style: CustomTextStyle.p35w(context)
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      '구독 중',
                      style: CustomTextStyle.p30w(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '|',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const SizedBox(width: 5),
                    Text('플랜 A',
                        style: CustomTextStyle.p25w(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 380.w,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('30', style: CustomTextStyle.p80w(context)),
                        const SizedBox(width: 5),
                        Text('개', style: CustomTextStyle.p30w(context)),
                      ],
                    ),
                    Container(
                      width: 240.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          Text(
                            '01:30',
                            style: CustomTextStyle.p25w(context).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '남음',
                            style: CustomTextStyle.p25w(context).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/03_main_ball.png',
                    width: 238.w,
                    height: 179.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
