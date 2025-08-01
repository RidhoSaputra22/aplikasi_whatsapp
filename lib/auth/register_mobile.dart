import 'package:aplikasi_whatsapp/auth/widget/qr_page.dart';
import 'package:aplikasi_whatsapp/main.dart';
import 'package:flutter/material.dart';
import 'login_web.dart'; // pastikan file ini ada
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResponsiveWrapperr extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapperr({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          if (ModalRoute.of(context)?.settings.name != '/QRLoginPage') {
            // Hindari navigasi berulang atau konflik
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/QRLoginPage'),
                  builder: (context) => const QRPage(),
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

// APP UTAMA
class RegisterMobile extends StatelessWidget {
  const RegisterMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111B21),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'ComicNeue'),
        ),
      ),
      home: const RegisterScreen(),
    );
  }
}

// HALAMAN LOGIN
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapperr(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://raw.githubusercontent.com/Rachel0404/Assets/b37c9b4ce177af9457bf078cd404a0302546c2cb/login.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Selamat datang di WhatsApp',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                      children: [
                        TextSpan(text: 'Baca '),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            // decoration: TextDecoration.underline,  // Hapus atau komentar ini
                          ),
                        ),
                        TextSpan(
                            text:
                                ' kami. Ketuk "Setuju dan\n lanjutkan" untuk menerima '),
                        TextSpan(
                          text: 'Ketentuan Layanan.',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            // decoration: TextDecoration.underline,  // Hapus atau komentar ini juga
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.language, color: Colors.green, size: 20),
                        SizedBox(width: 6),
                        Text('Bahasa Indonesia',
                            style:
                                TextStyle(color: Colors.green, fontSize: 10)),
                        Icon(Icons.expand_more, color: Colors.green, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PhoneNumberScreen()),
                        );
                      },
                      child: const Text(
                        'Setuju dan lanjutkan',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  final List<String> countries = ['Indonesia', 'Malaysia', 'Singapura'];
  String selectedCountry = 'Indonesia';

  void _selectCountry() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111B21),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView(
          children: countries.map((country) {
            return ListTile(
              title: Text(
                country,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  selectedCountry = country;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> savePhoneNumber() async {
    final url = Uri.parse(
        'http://192.168.1.7/wa_api/save_phone.php'); // Ganti IP sesuai IP PC kamu

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'country': selectedCountry,
          'phone': phoneController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success']) {
        print('Nomor berhasil disimpan atau sudah ada di database');
      } else {
        print('Gagal menyimpan: ${data['message']}');
      }
    } catch (e) {
      print('Error saat menyimpan nomor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapperr(
      child: Scaffold(
        backgroundColor: const Color(0xFF111B21),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111B21),
          elevation: 0,
          title: Text('Regist'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'penautan',
                    child: Text('Tautkan sebagai perangkat pendamping')),
                const PopupMenuItem(value: 'bantuan', child: Text('Bantuan')),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Masukkan nomor telepon Anda',
                  style: TextStyle(
                      fontSize: 23,
                      fontFamily: 'ComicNeue',
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'WhatsApp perlu memverifikasi nomor telepon Anda.\n Biaya operator mungkin berlaku. ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Berapa nomor\n telepon saya?',
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Baris "Indonesia" + dropdown panah
                GestureDetector(
                  onTap: _selectCountry,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            selectedCountry,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_drop_down,
                            color: Colors.green, size: 24),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.green, thickness: 1),

                // Input nomor telepon
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.85,
                    child: Row(
                      children: [
                        const Text('+62',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: 'Nomor telepon',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(color: Colors.green, thickness: 1),
                const SizedBox(height: 40),

                // Tombol lanjut
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      await savePhoneNumber(); // Simpan nomor (jika belum ada)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VerificationCodeScreen()),
                      );
                    },
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    for (final controller in _controllers) {
      controller.addListener(_checkCode);
    }
  }

  void _checkCode() {
    String code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      // Simulasi verifikasi berhasil, arahkan ke home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => MyHomePage(
                  isLogin: true,
                )),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapperr(
      child: Scaffold(
        backgroundColor: const Color(0xFF111B21),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111B21),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'penautan',
                  child: Text('Tautkan sebagai perangkat pendamping'),
                ),
                const PopupMenuItem(
                  value: 'bantuan',
                  child: Text('Bantuan'),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Memverifikasi nomor Anda',
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'ComicNeue',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'ComicNeue',
                      color: Colors.white70,
                    ),
                    children: [
                      TextSpan(
                          text:
                              'Menunggu untuk mendeteksi secara otomatis kode 6\n digit yang dikirim melalui SMS ke '),
                      TextSpan(
                        text: '+62 *-*-*. \n',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Nomor salah?',
                        style: TextStyle(color: Colors.lightBlueAccent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 3
                            ? 24.0
                            : 6.0, // Jarak besar antar grup 3-3
                        right: 6.0,
                      ),
                      child: SizedBox(
                        width: 15, // Ukuran kotak input diperbesar
                        child: TextField(
                          controller: _controllers[index],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15, // Ukuran huruf diperbesar
                            color: Colors.white, // Warna huruf putih
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 60),
                const Text(
                  'Tidak menerima kode?',
                  style: TextStyle(color: Colors.green, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
