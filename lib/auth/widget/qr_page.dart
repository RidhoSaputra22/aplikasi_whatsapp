import 'package:aplikasi_whatsapp/auth/login_web.dart';
import 'package:flutter/material.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  bool staySignedIn = true;

  // Tambahan: Deklarasi variabel hover
  bool _isHoveringHelp = false;
  bool _isHoveringLogin = false;
  bool _isHoveringRegister = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF6EC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints:
                    const BoxConstraints(maxWidth: 1000, maxHeight: 500),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kolom kiri: Teks
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Login ke WhatsApp Web',
                              style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Berkirim pesan secara privat dengan teman dan keluarga\nmenggunakan WhatsApp di browser Anda.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(height: 20),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. Buka WhatsApp di telepon Anda',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '2. Ketuk Menu \u22ee di Android, atau Pengaturan \u2699\ufe0f di iPhone',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '3. Ketuk Perangkat tertaut lalu Tautkan perangkat',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    '4. Arahkan telepon Anda di layar ini untuk memindai kode QR',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 12)
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
                                            builder: (context) =>
                                                const PhoneLoginPage(
                                                  mode: 'login',
                                                )),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Login dengan nomor telepon',
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
                                  width: 200,
                                  color: const Color(0xFF30BF36),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MouseRegion(
                                  onEnter: (_) => setState(
                                      () => _isHoveringRegister = true),
                                  onExit: (_) => setState(
                                      () => _isHoveringRegister = false),
                                  cursor: SystemMouseCursors.click,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PhoneLoginPage(
                                                  mode: 'register',
                                                )),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Register dengan nomor telepon',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: _isHoveringRegister
                                                ? const Color(0xFF25D366)
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.chevron_right,
                                          size: 16,
                                          color: _isHoveringRegister
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
                                  width: 200,
                                  color: const Color(0xFF30BF36),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Kolom kanan: QR + Checkbox
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // QR Code
                            Positioned(
                              top:
                                  90, // Ubah nilai ini untuk menggeser QR ke atas/bawah
                              left: 0,
                              right: 0,
                              child: SizedBox(
                                width: 240,
                                height: 240,
                                child: Image.network(
                                  'https://raw.githubusercontent.com/Rachel0404/Assets/b37c9b4ce177af9457bf078cd404a0302546c2cb/qr.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            // Checkbox di kiri bawah QR
                            Positioned(
                              top: 220 +
                                  120, // Top QR (40) + QR height (240) + margin bawah (sekitar 10)
                              left: 35,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: staySignedIn,
                                    onChanged: (value) {
                                      setState(() {
                                        staySignedIn = value!;
                                      });
                                    },
                                    activeColor: const Color(0xFF25D366),
                                  ),
                                  const Text(
                                    'Tetap masuk di browser ini',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
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
