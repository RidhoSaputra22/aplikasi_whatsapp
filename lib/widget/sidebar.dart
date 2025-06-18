import 'package:aplikasi_whatsapp/models/chat%20-%20copy.dart';
import 'package:aplikasi_whatsapp/widget/chat_list.dart';
import 'package:aplikasi_whatsapp/widget/search_bar.dart';
import 'package:aplikasi_whatsapp/widget/sidebar_header.dart';
import 'package:aplikasi_whatsapp/widget/tab_bar.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SidebarHeader(),
          SearchBarWidget(),
          TabBarWidget(),
          Expanded(child: ChatList(chats: Chat.chats)),
        ],
      ),
    );
  }
}
