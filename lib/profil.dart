import 'package:flutter/material.dart';
import 'dashboard.dart'; 
import 'login.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFF5A94D), Color(0xFFF6D5A8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Halo, Wisatawan!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "wisatawan@email.com",
                      style: TextStyle(color: Color(0xFF6D6D6D), fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                Icon(Icons.flag, color: Color(0xFF2F2F2F), size: 28),
                SizedBox(width: 8),
                Text(
                  "Tujuan Aplikasi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: const Text(
                    "Aplikasi ini membantu wisatawan menjelajahi destinasi terbaik di Bali dengan informasi lengkap dan tampilan yang ramah pengguna.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F), height: 1.5),
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'images/logo.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "Galeri Wisata Bali",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  wisataImage("images/kuta.jpeg", "Pantai Kuta"),
                  wisataImage("images/ubud.jpg", "Ubud"),
                  wisataImage("images/tanahlot.jpg", "Tanah Lot"),
                  wisataImage("images/tegalalang.jpg", "Tegallalang"),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Lainnya",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.article, color: Color(0xFF2F2F2F)),
              title: const Text("Syarat dan Ketentuan"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Color(0xFF2F2F2F)),
              title: const Text("Kebijakan Privasi"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF2F2F2F)),
              title: const Text("Pengaturan"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFF2F2F2F)),
              title: const Text("Pusat Bantuan"),
              onTap: () {},
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                SizedBox(width: 8),
                Text(
                  "Developer",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                developerCard("images/adit.jpg", "Adit", "UI/UX Designer", "Adit bertugas merancang antarmuka pengguna aplikasi agar menarik dan mudah digunakan."),
                developerCard("images/rehan.jpg", "Rehan", "Flutter Developer", "Rehan fokus pada implementasi fitur menggunakan Flutter dengan performa optimal."),
                developerCard("images/prad.jpg", "Prad", "Content Writer", "Prad menulis konten informatif tentang destinasi wisata Bali."),
                developerCard("images/carlos.jpg", "Carlos", "Flutter Developer", "Carlos membantu membangun antarmuka aplikasi dan logika halaman."),
                developerCard("images/rangga.jpg", "Rangga", "Content Writer", "Rangga mengisi konten deskripsi dan narasi tentang budaya Bali."),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                socialImage("images/ig.jpeg"),
                socialImage("images/fb.png"),
                socialImage("images/yt.jpeg"),
                socialImage("images/x.jpeg"),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static Widget developerCard(String imagePath, String name, String role, String description) {
    IconData roleIcon;
    switch (role.toLowerCase()) {
      case "ui/ux designer":
        roleIcon = Icons.design_services;
        break;
      case "flutter developer":
        roleIcon = Icons.code;
        break;
      case "content writer":
        roleIcon = Icons.edit_note;
        break;
      default:
        roleIcon = Icons.person;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF6D5A8), Color(0xFFF5A94D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(roleIcon, size: 18, color: Color(0xFF2F2F2F)),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2F2F2F)),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF2F2F2F), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget socialImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {},
        child: Image.asset(
          assetPath,
          width: 32,
          height: 32,
        ),
      ),
    );
  }

  static Widget wisataImage(String path, String label) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
