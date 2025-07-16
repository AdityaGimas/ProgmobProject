import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profil.dart';
import 'detail_tanahlot.dart';
import 'detail_pantaikuta.dart';
import 'detail_ubud.dart';
import 'detail_ulundanuberatan.dart';
import 'detail_kelingking.dart';
import 'detail_gwk.dart';
import 'detail_tegalalang.dart';
import '../models/detailwisatamodel.dart';
import 'rekomendasi_page.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nature Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9E8D9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF5A94D)),
        useMaterial3: true,
        fontFamily: 'Sans',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _destinationController = PageController(viewportFraction: 0.9);
  final PageController _culinaryController = PageController(viewportFraction: 0.9);
  final PageController _hotelController = PageController(viewportFraction: 0.9);

  // list dummy data destinasi
  final List<String> allDestinations = [
    'Borobudur Temple',
    'Raja Ampat',
    'Bali Beach',
    'Sate Padang',
    'Rendang',
    'Pempek Palembang',
    'Hotel Bali',
    'Resort Lombok',
    'Vila Ubud'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final headerHeight = height * 0.65;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: headerHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            "images/gwk.jpeg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFF9E8D9).withOpacity(0.95),
                                  const Color(0xFFF9E8D9).withOpacity(0.85),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const ProfilPage()),
                                      );
                                    },
                                    child: Row(
                                      children: const [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage("images/user.png"),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'User',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2F2F2F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.grid_view, color: Color(0xFF2F2F2F)),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const RekomendasiPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 101),
                              Row(
                                children: [
                                  Image.asset(
                                    'images/logo2.png',
                                    width: 280,
                                    height: 150,
                                  ),
                                ],
                              ),
                              const Text(
                                "If you like to travel, this is your app! Here you\ncan travel without hassle and enjoy it!\nThere's also accomodation and culinary reccomendation!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4B4B4B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              buildSection(
                "Destinasi Wisata",
                "Temukan beragam destinasi indah di Bali, mulai dari pantai eksotis hingga pura bersejarah, semua dalam genggaman.",
                _destinationController,
                [
                DestinationCard(
                  title: "Garuda Wisnu Kencana",
                  imagePath: "images/gwk.jpeg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Garuda Wisnu Kencana",
                      lokasi: "Ungasan, Badung, Bali",
                      gambar: "images/gwk.jpeg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailGWKPage(wisata: wisata),
                      ),
                    );
                  },
                ),
                DestinationCard(
                  title: "Pantai Kelingking",
                  imagePath: "images/kelingking2.jpg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Pantai Kelingking",
                      lokasi: "Nusa Penida",
                      gambar: "images/kelingking.jpg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailKelingkingPage(wisata: wisata),
                      ),
                    );
                  },
                ),
                DestinationCard(
                  title: "Pantai Kuta",
                  imagePath: "images/kuta.jpg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Pantai Kuta",
                      lokasi: "Badung",
                      gambar: "images/kuta.jpg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPantaiKutaPage(wisata: wisata),
                      ),
                    );
                  },
                ),
                DestinationCard(
                  title: "Tanah Lot",
                  imagePath: "images/tanahlot.jpg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Tanah Lot",
                      lokasi: "Tabanan",
                      gambar: "images/tanahlot.jpg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTanahLotPage(wisata: wisata),
                      ),
                    );
                  },
                ),
                DestinationCard(
                  title: "Sawah Terasering Tegalalang",
                  imagePath: "images/tegalalang.jpg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Sawah Terasering Tegalalang",
                      lokasi: "Gianyar",
                      gambar: "images/tegalalang.jpg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTegalalangPage(wisata: wisata),
                      ),
                    );
                  },
                ),
                DestinationCard(
                  title: "Ubud",
                  imagePath: "images/ubud.jpg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Ubud",
                      lokasi: "Gianyar",
                      gambar: "images/ubud.jpg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailUbudPage(wisata: wisata),
                      ),
                    );
                  },
                ),
                DestinationCard(
                  title: "Ulundanu Beratan",
                  imagePath: "images/ulundanu.jpg",
                  onTap: () {
                    final wisata = Wisata(
                      nama: "Ulun Danu Beratan",
                      lokasi: "Nusa Penida",
                      gambar: "images/ulundanu.jpg",
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailUlunDanuBeratanPage(wisata: wisata),
                      ),
                    );
                  },
                ),
              ]
              ),
              const SizedBox(height: 32),
              buildSection(
                "Kuliner",
                "Nikmati kelezatan kuliner khas Indonesia yang menggugah selera, dari makanan tradisional hingga hidangan modern. Akses laman kuliner lewat opsi rekomendasi!",
                _culinaryController,
                const [
                  DestinationCard(title: "Warung Sari Rasa", imagePath: "images/food1.jpeg"),
                  DestinationCard(title: "Cafe Santai", imagePath: "images/food2.jpeg"),
                ],
              ),
              const SizedBox(height: 32),
              buildSection(
                "Penginapan",
                "Beragam pilihan penginapan nyaman, mulai dari hotel mewah hingga vila eksklusif untuk pengalaman tak terlupakan. Akses laman penginapan lewat opsi rekomendasi!",
                _hotelController,
                const [
                  DestinationCard(title: "Hotel Sejahtera", imagePath: "images/hotel1.jpeg"),
                  DestinationCard(title: "Pondok Indah", imagePath: "images/hotel2.jpeg"),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFF9E8D9),
          currentIndex: 0,
          selectedItemColor: const Color(0xFFF5A94D),
          unselectedItemColor: const Color(0xFF6D6D6D),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) async {
            if (index == 1) {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Keluar Aplikasi"),
                  content: const Text("Apakah kamu yakin ingin keluar dari aplikasi?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Keluar"),
                    ),
                  ],
                ),
              );

              if (shouldExit == true) {
                if (Platform.isAndroid || Platform.isIOS) {
                  SystemNavigator.pop(); // Android/iOS
                } else {
                  exit(0); // Windows, macOS, Linux
                }
              }
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.power_settings_new), label: ""),
          ],
        ),
    );
  }

  Widget buildSection(String title, String description, PageController controller, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2F2F),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B4B4B),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: PageView(
            controller: controller,
            children: cards,
          ),
        ),
      ],
    );
  }

}

class DestinationCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback? onTap;

  const DestinationCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.flag, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "Bali",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // >>> HAPUS BAGIAN INI UNTUK MENGHILANGKAN TOMBOL PANAH <<<
    // const Positioned(
    //   bottom: 16,
    //   right: 16,
    //   child: CircleAvatar(
    //     backgroundColor: Color(0xFFF5A94D),
    //     child: Icon(Icons.arrow_forward, color: Colors.white),
    //   ),
    // )
            ],
          ),
        ),
      ),
    );
  }
}
