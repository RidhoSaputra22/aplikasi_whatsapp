import 'package:aplikasi_whatsapp/models/chat%20-%20copy.dart';
import 'package:aplikasi_whatsapp/theme/theme.dart';
import 'package:aplikasi_whatsapp/widget/chat_list.dart';
import 'package:aplikasi_whatsapp/widget/chat_screen.dart';
import 'package:aplikasi_whatsapp/widget/navigation_rail.dart';
import 'package:aplikasi_whatsapp/widget/sidebar.dart';
import 'package:flutter/material.dart';

class DesktopLayout extends StatefulWidget {
  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Web Clone',
      theme: lightTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            NavigationRailWidget(
              selectedIndex: selectedTab,
              onItemSelected: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
            ),
            Expanded(flex: 2, child: Sidebar()),
            Expanded(flex: 5, child: ChatScreen()),
          ],
        ),
      ),
    );
  }
}
