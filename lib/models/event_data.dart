class Event {
  final String location;
  final String title;
  final String description;
  final String date;
  final List<String> imageUrls;

  Event({
    required this.location,
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrls,
  });
}

final List<Event> events = [
  // Pura Tanah Lot
  Event(
    location: 'Tanah Lot',
    title: 'Odalan Tanah Lot',
    description: 'Hari raya keagamaan Bali dengan upacara besar di area pura.',
    date: 'Setiap 210 hari (berdasarkan kalender Bali)',
    imageUrls: ['images/tanahlot3.jpg', 'images/tanahlot2.jpg'],
  ),
  Event(
    location: 'Tanah Lot',
    title: 'Tari Kecak Sunset',
    description: 'Pertunjukan tari Kecak saat matahari terbenam.',
    date: 'Setiap Sabtu dan Minggu',
    imageUrls: ['images/kecak1.jpeg', 'images/kecak2.jpeg'],
  ),
  Event(
    location: 'Tanah Lot',
    title: 'Pameran Seni dan Kerajinan',
    description: 'Pameran hasil karya seni lokal di sekitar Tanah Lot.',
    date: 'Minggu ke-3 setiap bulan',
    imageUrls: ['images/seni1.jpg', 'images/seni2.jpg'],
  ),

  // Pantai Kuta
  Event(
    location: 'Pantai Kuta',
    title: 'Festival Layang-Layang Bali',
    description: 'Event tahunan dengan berbagai jenis layangan tradisional.',
    date: 'Juli - Agustus setiap tahun',
    imageUrls: ['images/kite1.jpeg', 'images/kite2.JPG'],
  ),
  Event(
    location: 'Pantai Kuta',
    title: 'Beach Clean-up Day',
    description: 'Kegiatan gotong-royong membersihkan pantai bersama komunitas.',
    date: 'Setiap minggu pertama setiap bulan',
    imageUrls: ['images/cleanup1.jpg', 'images/cleanup2.JPG'],
  ),
  Event(
    location: 'Pantai Kuta',
    title: 'Kuta Carnival',
    description: 'Konser kecil musik lokal di tepi pantai saat sunset.',
    date: 'Sabtu sore',
    imageUrls: ['images/carnival.jpg', 'images/carnival1.JPG'],
  ),

  // Ubud, Gianyar
  Event(
    location: 'Ubud',
    title: 'Ubud Writers & Readers Festival',
    description: 'Festival sastra internasional tahunan di pusat budaya Ubud.',
    date: 'Oktober setiap tahun',
    imageUrls: ['images/uwrf1.jpeg', 'images/uwrf2.jpeg'],
  ),
  Event(
    location: 'Ubud',
    title: 'Festival Topeng & Wayang',
    description: 'Pertunjukan seni budaya lokal seperti tari topeng dan wayang.',
    date: 'Juni setiap tahun',
    imageUrls: ['images/wayang1.jpeg', 'images/wayang2.jpeg'],
  ),
  Event(
    location: 'Ubud',
    title: 'Pasar Seni Rakyat',
    description: 'Pameran makanan lokal, kerajinan tangan dan kesenian.',
    date: 'Setiap hari Minggu',
    imageUrls: ['images/pasar1.jpeg', 'images/pasar2.jpeg'],
  ),

  // Pura Ulun Danu Batur
  Event(
    location: 'Ulun Danu Beratan',
    title: 'Piodalan Agung',
    description: 'Upacara sakral keagamaan dengan prosesi dan sesajen khas Bali.',
    date: 'Setiap 210 hari menurut kalender Bali',
    imageUrls: ['images/ulundanu1.jpg', 'images/ulundanu2.jpg'],
  ),
  Event(
    location: 'Ulun Danu Beratan',
    title: 'Prosesi Melasti',
    description: 'Upacara pembersihan simbolik menuju Danau Batur menjelang Nyepi.',
    date: 'Menjelang Hari Raya Nyepi',
    imageUrls: ['images/melasti1.jpeg', 'images/melasti2.jpeg'],
  ),
  Event(
    location: 'Ulun Danu Beratan',
    title: 'Festival Danau Batur',
    description: 'Festival budaya dan keindahan alam di tepi Danau Batur.',
    date: 'Mei - Juni',
    imageUrls: ['images/festivaldanau1.jpeg', 'images/festivaldanau2.jpeg'],
  ),

  // Kelingking Beach
  Event(
    location: 'Pantai Kelingking',
    title: 'Konservasi Penyu & Laut',
    description: 'Kegiatan edukasi dan pelepasan tukik untuk wisatawan.',
    date: 'Tiap musim bertelur (Mei - Agustus)',
    imageUrls: ['images/penyu1.jpeg', 'images/penyu2.jpeg'],
  ),
  Event(
    location: 'Pantai Kelingking',
    title: 'Upacara Segara',
    description: 'Upacara adat Bali untuk penghormatan kepada laut.',
    date: 'Bulan Purnama',
    imageUrls: ['images/segara1.jpeg', 'images/segara2.jpeg'],
  ),
  Event(
    location: 'Pantai Kelingking',
    title: 'Snorkeling Bersih Laut',
    description: 'Kegiatan snorkel sambil membersihkan sampah laut.',
    date: 'Setiap minggu kedua',
    imageUrls: ['images/snorkel1.jpeg', 'images/snorkel2.jpeg'],
  ),

  // GWK
  Event(
    location: 'Garuda Wisnu Kencana',
    title: 'Tari Barong dan Keris',
    description: 'Pertunjukan harian di amphitheater GWK Cultural Park.',
    date: 'Setiap hari pukul 17.00 WITA',
    imageUrls: ['images/barong1.jpeg', 'images/barong2.jpeg'],
  ),
  Event(
    location: 'Garuda Wisnu Kencana',
    title: 'Festival Budaya Nusantara',
    description: 'Pagelaran budaya dari berbagai daerah di Indonesia.',
    date: 'Agustus setiap tahun',
    imageUrls: ['images/nusantara1.jpeg', 'images/nusantara2.jpeg'],
  ),
  Event(
    location: 'Garuda Wisnu Kencana',
    title: 'Pameran Patung dan Relief',
    description: 'Pameran seni patung dari berbagai seniman lokal.',
    date: 'April dan November',
    imageUrls: ['images/relief1.jpeg', 'images/relief2.jpeg'],
  ),

  // Tegalalang
  Event(
    location: 'Sawah Terasering Tegalalang',
    title: 'Festival Panen Raya',
    description: 'Kegiatan panen raya dan atraksi budaya pertanian tradisional.',
    date: 'Maret dan Oktober',
    imageUrls: ['images/panen1.jpg', 'images/panen2.jpeg'],
  ),
  Event(
    location: 'Sawah Terasering Tegalalang',
    title: 'Workshop Subak',
    description: 'Edukasi sistem irigasi khas Bali dan peran petani lokal.',
    date: 'Setiap akhir pekan',
    imageUrls: ['images/subak1.jpg', 'images/subak2.jpeg'],
  ),
  Event(
    location: 'Sawah Terasering Tegalalang',
    title: 'Trekking & Budaya Sawah',
    description: 'Trekking sawah ditemani guide lokal dan penjelasan budaya.',
    date: 'Setiap hari pukul 08.00 WITA',
    imageUrls: ['images/trekking1.jpg', 'images/trekking2.jpg'],
  ),
];
