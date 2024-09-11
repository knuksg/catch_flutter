import 'package:catch_flutter/core/text_theme.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({required this.message, this.isUser = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: isUser
            ? CustomTextStyle.p35(context)
            : CustomTextStyle.p40(context),
      ),
    );
  }
}
