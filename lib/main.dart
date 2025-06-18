import 'package:aplikasi_whatsapp/layouts/desktop_layout.dart';
import 'package:aplikasi_whatsapp/layouts/mobile_layout.dart';
import 'package:aplikasi_whatsapp/theme/theme.dart';
import 'package:aplikasi_whatsapp/auth/login_web.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const WhatsAppClone());
}

class WhatsAppClone extends StatelessWidget {
  const WhatsAppClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme(),
      home: MyHomePage(
        isLogin: false,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final isLogin;
  const MyHomePage({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return MobileLayout();
              } else {
                return DesktopLayout();
              }
            },
          )
        : WhatsAppLoginClone();
  }
}
