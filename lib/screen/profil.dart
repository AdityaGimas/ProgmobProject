import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/page_manager.dart';
import '../routes/app_router_delegate.dart';

class ProfilPage extends StatefulWidget {
  final PageManager pageManager;

  const ProfilPage({super.key, required this.pageManager});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  File? _savedImage;
  File? _pickedImage;
  Uint8List? _webPickedImageBytes;
  Uint8List? _webSavedImageBytes;

  bool _hasLoadedImage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSavedImagePath();
  }

  Future<void> _loadSavedImagePath() async {
  final prefs = await SharedPreferences.getInstance();
  final imagePath = prefs.getString('savedImagePath');
  if (imagePath != null) {
    final imageFile = File(imagePath);
    if (await imageFile.exists()) {
      setState(() {
        _savedImage = imageFile;
      });
    } else {
      setState(() {
        _savedImage = null;
      });
    }
  } else {
    setState(() {
      _savedImage = null;
    });
  }
}


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webPickedImageBytes = bytes;
        });
      } else {
        setState(() {
          _pickedImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (kIsWeb && _webPickedImageBytes != null) {
      setState(() {
        _webSavedImageBytes = _webPickedImageBytes;
        _webPickedImageBytes = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto tersimpan sementara (web platform)")),
      );
    } else if (!kIsWeb && _pickedImage != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_pickedImage!.path);
      final savedFile = await _pickedImage!.copy('${appDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedImagePath', savedFile.path);


      setState(() {
        _savedImage = savedFile;
        _pickedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto berhasil disimpan ke lokal")),
      );
    }
  }

  void _showProfileMenu() async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: const [
        PopupMenuItem(value: 'change', child: Text('Ganti Foto Profil')),
      ],
    );

    if (selected == 'view') {
      widget.pageManager.goTo(AppPage.viewProfilePicture, arguments: _savedImage);
    } else if (selected == 'change') {
      _pickImage();
    }
  }

  ImageProvider<Object> _getCurrentProfileImage() {
    if (kIsWeb && _webSavedImageBytes != null) {
      return MemoryImage(_webSavedImageBytes!);
    } else if (!kIsWeb && _savedImage != null) {
      return FileImage(_savedImage!);
    } else {
      return const AssetImage('images/logo.png');
    }
  }

  ImageProvider<Object>? _getPreviewImage() {
    if (kIsWeb && _webPickedImageBytes != null) {
      return MemoryImage(_webPickedImageBytes!);
    } else if (!kIsWeb && _pickedImage != null) {
      return FileImage(_pickedImage!);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewImage = _getPreviewImage();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => widget.pageManager.goTo(AppPage.dashboard),
        ),
        backgroundColor: const Color(0xFFF5A94D),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _showProfileMenu,
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: _getCurrentProfileImage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Halo, Wisatawan!",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF2F2F2F))),
                    SizedBox(height: 4),
                    Text("wisatawan@email.com",
                        style: TextStyle(color: Color(0xFF6D6D6D), fontSize: 14)),
                  ],
                ),
              ],
            ),
            if (previewImage != null) ...[
              const SizedBox(height: 24),
              const Text("Preview Foto Baru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CircleAvatar(radius: 40, backgroundImage: previewImage),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.upload),
                label: const Text("Upload Foto"),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5A94D)),
              ),
            ],
            const SizedBox(height: 32),
            buildSectionTitle(Icons.flag, "Tujuan Aplikasi"),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    "Aplikasi ini membantu wisatawan menjelajahi destinasi terbaik di Bali dengan informasi lengkap dan tampilan yang ramah pengguna.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF2F2F2F), height: 1.5),
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('images/logo.png', width: 60, height: 60, fit: BoxFit.cover),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text("Galeri Wisata Bali", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            const Text("Lainnya", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            buildListTile(Icons.article, "Syarat dan Ketentuan"),
            buildListTile(Icons.privacy_tip, "Kebijakan Privasi"),
            buildListTile(Icons.settings, "Pengaturan"),
            buildListTile(Icons.help_outline, "Pusat Bantuan"),
            const SizedBox(height: 32),
            const Text("Developer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            developerCard("images/adit.jpg", "Adit", "UI/UX Designer", "Adit bertugas merancang antarmuka pengguna aplikasi agar menarik dan mudah digunakan."),
            developerCard("images/rehan.jpg", "Rehan", "Flutter Developer", "Rehan fokus pada implementasi fitur menggunakan Flutter dengan performa optimal."),
            developerCard("images/prad.jpg", "Prad", "Content Writer", "Prad menulis konten informatif tentang destinasi wisata Bali."),
            developerCard("images/carlos.jpg", "Carlos", "Flutter Developer", "Carlos membantu membangun antarmuka aplikasi dan logika halaman."),
            developerCard("images/rangga.jpg", "Rangga", "Content Writer", "Rangga mengisi konten deskripsi dan narasi tentang budaya Bali."),
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
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2F2F2F), size: 28),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F))),
      ],
    );
  }

  Widget buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2F2F2F)),
      title: Text(title),
      onTap: () {},
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
        gradient: const LinearGradient(colors: [Color(0xFFF6D5A8), Color(0xFFF5A94D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: CircleAvatar(radius: 28, backgroundImage: AssetImage(imagePath)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(roleIcon, size: 18, color: const Color(0xFF2F2F2F)),
                    const SizedBox(width: 6),
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F2F2F))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(role, style: const TextStyle(fontSize: 14, color: Color(0xFF2F2F2F))),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 13, color: Color(0xFF2F2F2F), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget wisataImage(String path, String label) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
        ),
        child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  static Widget socialImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(onTap: () {}, child: Image.asset(assetPath, width: 32, height: 32)),
      );
}
}