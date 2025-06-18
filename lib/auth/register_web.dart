import 'package:aplikasi_whatsapp/auth/widget/qr_page.dart';
import 'package:aplikasi_whatsapp/main.dart';
import 'package:aplikasi_whatsapp/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_mobile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WhatsAppLoginClone extends StatelessWidget {
  const WhatsAppLoginClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WA Web Login Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const LoginMobile();
          } else {
            return const PhoneRegisterPage();
          }
        },
      ),
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          if (ModalRoute.of(context)?.settings.name != '/loginMobile') {
            // Hindari navigasi berulang atau konflik
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/loginMobile'),
                  builder: (context) => const LoginMobile(),
                ),
              );
            });
          }
        }
        return child;
      },
    );
  }
}

// --------------------- PHONE LOGIN PAGE ---------------------
class PhoneRegisterPage extends StatefulWidget {
  const PhoneRegisterPage({super.key});

  @override
  State<PhoneRegisterPage> createState() => _PhoneRegisterPageState();
}

class _PhoneRegisterPageState extends State<PhoneRegisterPage> {
  String phoneNumber = '';
  String selectedCountry = 'Indonesia';
  bool _isHoveringLoginQR = false; // untuk deteksi hover

  final List<Map<String, String>> countries = [
    {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
  ];

  String getSelectedCountryCode() {
    return countries.firstWhere((c) => c['name'] == selectedCountry)['code']!;
  }

  @override
  Widget build(BuildContext context) {
    final Color greenWA = const Color(0xFF128C7E);
    final Color greenWABright = const Color(0xFF25D366); // hijau terang WA
    final BorderRadius borderRadius = BorderRadius.circular(30);
    final BorderSide blackBorderSide =
        const BorderSide(color: Colors.black, width: 1.0);

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF6EC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1000,
                height: 500,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Masukkan nomor telepon',
                      style: TextStyle(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pilih negara lalu masukkan nomor telepon Anda.',
                      style: TextStyle(fontSize: 19),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Dropdown dan TextField
                        SizedBox(
                          width: 300,
                          child: DropdownButtonFormField<String>(
                            value: selectedCountry,
                            items: countries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['name'],
                                child: Text(
                                    '${country['flag']} ${country['name']}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value!;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: blackBorderSide,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: blackBorderSide,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide:
                                    BorderSide(color: greenWA, width: 2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 8),
                                child: Text(
                                  getSelectedCountryCode(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: BorderSide(
                                  color: greenWA,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: blackBorderSide,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenWA,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => VerifyCodeScreen(
                                    phoneNumber: phoneNumber,
                                  )),
                        );
                      },
                      child: const Text('Lanjut'),
                    ),
                    const SizedBox(height: 16),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHoveringLoginQR = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHoveringLoginQR = false;
                        });
                      },
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 2),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: greenWABright,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Login dengan kode QR',
                                style: TextStyle(
                                  color: _isHoveringLoginQR
                                      ? greenWABright
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: _isHoveringLoginQR
                                  ? greenWABright
                                  : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const LockNotice(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------- CODE VERIFY PAGE ---------------------
class VerifyCodeScreen extends StatefulWidget {
  final String? phoneNumber;
  const VerifyCodeScreen({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final int codeLength = 8;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  bool _navigated = false;

  // Tambahkan dua variabel ini untuk hover effect
  bool _isHoveringHelp = false;
  bool _isHoveringLogin = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(codeLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) async {
    if (value.isNotEmpty && index < codeLength - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    bool allFilled =
        _controllers.every((controller) => controller.text.length == 1);

    if (allFilled && !_navigated) {
      _navigated = true;
      String enteredCode = _controllers.map((e) => e.text).join();
      print("Kode verifikasi: $enteredCode");

      final bool data =
          await AuthServices.login(widget.phoneNumber ?? "", enteredCode);

      if (data) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              isLogin: true,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kode verifikasi salah'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF6EF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                color: const Color(0xFFFAF6EF),
                child: Center(
                  child: Container(
                    width: 900,
                    padding: const EdgeInsets.all(55),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Masukkan kode di telepon',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            children: [
                              const TextSpan(text: 'Menautkan akun WhatsApp '),
                              TextSpan(
                                text: (widget.phoneNumber != null &&
                                        widget.phoneNumber!.isNotEmpty)
                                    ? widget.phoneNumber!
                                    : '+62 *-*-*',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const TextSpan(text: '('),
                              TextSpan(
                                text: 'edit',
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF008069),
                                ),
                              ),
                              const TextSpan(text: ')'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(codeLength + 1, (i) {
                              if (i == 4) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }

                              final index = i > 4 ? i - 1 : i;

                              return Container(
                                width: 40,
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 1,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[A-Za-z0-9]')),
                                    ],
                                    onChanged: (value) =>
                                        _onCodeChanged(value, index),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1. Buka WhatsApp di telepon Anda',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 9),
                              Text(
                                '2. Ketuk Menu \u22ee di Android, atau Pengaturan \u2699\ufe0f di iPhone',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 9),
                              Text(
                                '3. Ketuk Perangkat tertaut lalu Tautkan perangkat',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 9),
                              Text(
                                '4. Ketuk Tautkan dengan nomor telepon saja, lalu masukkan kode ini di telepon Anda',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 9)
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Bagian 'Perlu bantuan untuk memulai?' dengan hover
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isHoveringHelp = true),
                                onExit: (_) =>
                                    setState(() => _isHoveringHelp = false),
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Perlu bantuan untuk memulai?',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: _isHoveringHelp
                                              ? const Color(0xFF25D366)
                                              : const Color(0xFF162029),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Transform.translate(
                                        offset: const Offset(0, 1.5),
                                        child: Icon(
                                          Icons.north_east,
                                          size: 14,
                                          color: _isHoveringHelp
                                              ? const Color(0xFF25D366)
                                              : const Color(0xFF162029),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 2,
                                width: 210,
                                color: const Color(0xFF30BF36),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Bagian 'Login dengan kode QR' dengan hover
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _isHoveringLogin = true),
                              onExit: (_) =>
                                  setState(() => _isHoveringLogin = false),
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const QRPage()),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Login dengan kode QR',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _isHoveringLogin
                                            ? const Color(0xFF25D366)
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 16,
                                      color: _isHoveringLogin
                                          ? const Color(0xFF25D366)
                                          : Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              height: 2,
                              width: 156,
                              color: const Color(0xFF30BF36),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const LockNotice(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------- WIDGET TAMBAHAN: LOCK NOTICE ---------------------
class LockNotice extends StatelessWidget {
  const LockNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock, color: Colors.grey),
        SizedBox(width: 8),
        Text(
          'Pesan pribadi Anda terenkripsi secara end-to-end',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class UnderlineTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const UnderlineTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<UnderlineTextButton> createState() => _UnderlineTextButtonState();
}

class _UnderlineTextButtonState extends State<UnderlineTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isHovered ? const Color(0xFF25D366) : Colors.green,
                width: 1.5,
              ),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black, // Hitam pekat
            ),
          ),
        ),
      ),
    );
  }
}
