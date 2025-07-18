import 'package:flutter/material.dart';

class ReservationFormPage extends StatefulWidget {
  final String namaWisata;
  const ReservationFormPage({Key? key, required this.namaWisata})
    : super(key: key);

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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

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
              Semantics(
                label: 'Nama Lengkap, wajib diisi',
                hint: 'Masukkan nama sesuai identitas',
                textField: true,
                child: TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Nama harus diisi'
                              : null,
                ),
              ),
              const SizedBox(height: 16),

              // Tanggal Kunjungan
              Semantics(
                button: true,
                label: 'Tanggal kunjungan',
                value: _formatDate(_selectedDate),
                hint: 'Tap untuk memilih tanggal kunjungan',
                child: InputDecorator(
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
                          color:
                              _selectedDate == null
                                  ? Colors.grey
                                  : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jam Kedatangan
              Semantics(
                button: true,
                label: 'Jam kedatangan',
                value: _formatTime(_selectedTime),
                hint: 'Tap untuk memilih jam kedatangan',
                child: InputDecorator(
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
                          color:
                              _selectedTime == null
                                  ? Colors.grey
                                  : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Jumlah Orang
              Semantics(
                label: 'Jumlah orang',
                hint:
                    'Tombol minus dan plus untuk mengurangi atau menambah jumlah peserta',
                value: _jumlahOrang.toString(),
                increasedValue: (_jumlahOrang + 1).toString(),
                decreasedValue: (_jumlahOrang - 1).toString(),
                child: Row(
                  children: [
                    const Text('Jumlah Orang:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 18),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: 'Kurangi jumlah orang',
                      onPressed: () {
                        if (_jumlahOrang > 1) setState(() => _jumlahOrang--);
                      },
                    ),
                    Text('$_jumlahOrang', style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      tooltip: 'Tambah jumlah orang',
                      onPressed: () {
                        setState(() => _jumlahOrang++);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Catatan
              Semantics(
                label: 'Catatan tambahan, opsional',
                hint: 'Isi jika ada permintaan khusus',
                textField: true,
                child: TextFormField(
                  controller: _catatanController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (opsional)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  minLines: 2,
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Submit
              Semantics(
                button: true,
                label: 'Kirim Reservasi',
                hint: 'Tekan untuk mengirim formulir reservasi',
                child: ElevatedButton.icon(
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
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Reservasi Berhasil!'),
                              content: const Text(
                                'Terima kasih, reservasi Anda sudah kami terima. Kami akan menghubungi Anda selanjutnya.',
                              ),
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
                          const SnackBar(
                            content: Text('Tanggal & jam wajib diisi!'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6D6D6D)),
          ),
        ],
      ),
    );
  }
}
