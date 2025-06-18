import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:aplikasi_whatsapp/config/api.dart';
import 'package:aplikasi_whatsapp/models/message.dart';

class Chat {
  final int id;
  final String? name;
  final String? subtitle;
  final String? time;
  final String? badge;
  final List<Message>? message;

  Chat({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.time,
    required this.badge,
    required this.message,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? null,
      name: json['name'] ?? null,
      subtitle: json['subtitle'] ?? null,
      time: json['time'] ?? null,
      badge: json['badge'] ?? null,
      message: json['messages'] != null
          ? List<Message>.from(
              json['messages'].map((msg) => Message.fromJson(msg)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'time': time,
        'badge': badge,
        'message': message,
      };

  static Future<List<Chat>> fetch() async {
    final response = await http.get(
      Uri.parse("${ApiServices.baseUrl}/chats"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Chat.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<String> upload(FilePickerResult file) async {
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        file.files.first.bytes!,
        filename: "upload.jpg",
      ),
    });

    var res = await Dio().post(
      '${ApiServices.baseUrl}/file/upload',
      data: formData,
    );

    if (res.statusCode == 200) {
      return res.data['photo'];
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static Future<bool> send(Message message) async {
    final response = await http.post(
      Uri.parse("${ApiServices.baseUrl}/chats"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body.toString());
    }
  }
}

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: MyChat()),
  );
}

class MyChat extends StatefulWidget {
  const MyChat({super.key});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final TextEditingController chatController = TextEditingController();
  List<Chat> _chats = [];
  List<Message> messages = [];

  FilePickerResult? photo;

  _fetch() async {
    List<Chat> chats = await Chat.fetch();
    setState(() {
      _chats = chats;
      messages = _chats[0].message!;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: messages[index].photo != null
                      ? Image.network(messages[index].photo.toString())
                      : null,
                  title: Text(messages[index].content.toString()),
                  subtitle: Text(messages[index].time.toString()),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        photo = result;
                      });
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: chatController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      ),
                      if (photo != null)
                        Container(
                          height: 100,
                          child: Image.memory(
                            photo!.files.first.bytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: const CircularProgressIndicator(),
                      ),
                    );
                    try {
                      String? photoUrl =
                          photo != null ? await Chat.upload(photo!) : null;
                      await Chat.send(Message(
                        content: chatController.text,
                        user_id: "1",
                        chat_id: "1",
                        photo: photoUrl,
                        time: DateTime.now(),
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    } finally {
                      Navigator.pop(context);
                      chatController.clear();
                      setState(() {
                        photo = null;
                      });
                      _fetch();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
