import 'package:flutter/material.dart';

class ReservationFormPage extends StatefulWidget {
  final String namaWisata;
  const ReservationFormPage({Key? key, required this.namaWisata}) : super(key: key);

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _jumlahOrang = 1;
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Fungsi sederhana untuk format tanggal: dd-mm-yyyy
  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  // Fungsi sederhana untuk format waktu: HH:mm
  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Pilih jam';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservasi - ${widget.namaWisata}'),
        backgroundColor: const Color(0xFFF5A94D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Pemesan
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 16),

              // Tanggal Kunjungan
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Kunjungan',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: _pickDate,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _formatDate(_selectedDate),
                      style: TextStyle(
                        color: _selectedDate == null ? Colors.grey : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jam Kedatangan
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Jam Kedatangan',
                  border: OutlineInputBorder(),
                ),
                child: InkWell(
                  onTap: _pickTime,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _formatTime(_selectedTime),
                      style: TextStyle(
                        color: _selectedTime == null ? Colors.grey : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jumlah Orang
              Row(
                children: [
                  const Text('Jumlah Orang:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 18),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (_jumlahOrang > 1) setState(() => _jumlahOrang--);
                    },
                  ),
                  Text('$_jumlahOrang', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() => _jumlahOrang++);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Catatan
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Tombol Submit
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A94D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'Kirim Reservasi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedDate != null &&
                      _selectedTime != null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Reservasi Berhasil!'),
                        content: const Text('Terima kasih, reservasi Anda sudah kami terima. Kami akan menghubungi Anda selanjutnya.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    if (_selectedDate == null || _selectedTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tanggal & jam wajib diisi!')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
