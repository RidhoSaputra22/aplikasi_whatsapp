import 'package:aplikasi_whatsapp/models/chat%20-%20copy.dart';
import 'package:aplikasi_whatsapp/widget/chat_list.dart';
import 'package:aplikasi_whatsapp/widget/chat_screen.dart';
import 'package:aplikasi_whatsapp/widget/glass_app_bar.dart';
import 'package:aplikasi_whatsapp/widget/glass_bottom_navigator.dart';
import 'package:flutter/material.dart';
import '../widget/chat_tile.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomGlassAppBar(
        leading: Container(
          padding: EdgeInsets.all(3),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            backgroundBlendMode: BlendMode.overlay,
            color: Colors.white.withOpacity(0.3),
          ),
          child: InkWell(
            onTap: () {},
            child: Icon(Icons.more_horiz),
          ),
        ),
        title: Expanded(
          child: Text(
            "Chat",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              backgroundBlendMode: BlendMode.overlay,
              color: Colors.white.withOpacity(0.9),
            ),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.camera_alt,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // backgroundBlendMode: BlendMode.overlay,
              color: Colors.green,
            ),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ChatList(
        chats: Chat.chats,
      ),
      bottomNavigationBar: CustomGlassBottomNavBar(
        selectedIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
