import 'package:flutter/material.dart';
import 'package:responsi/bloc/pasien_bloc.dart';
import 'package:responsi/model/pasien.dart';
import 'package:responsi/ui/pasien_form.dart';
import 'package:responsi/ui/pasien_page.dart';
import 'package:responsi/widget/success_dialog.dart';
import 'package:responsi/widget/warning_dialog.dart';

class PasienDetail extends StatefulWidget {
  Pasien? pasien;
  PasienDetail({Key? key, this.pasien}) : super(key: key);
  @override
  _PasienDetailState createState() => _PasienDetailState();
}

class _PasienDetailState extends State<PasienDetail> {
  final primaryGreen = const Color(0xFF4CAF50);
  final accentYellow = const Color(0xFFFFEB3B);
  final backgroundColor = const Color(0xFFF1F8E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Detail Pasien',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sans-serif',
          ),
        ),
        backgroundColor: primaryGreen,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryGreen.withOpacity(0.3),
              backgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nama Pasien: ${widget.pasien?.namapasien ?? 'Tidak diketahui'}",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sans-serif',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Gejala: ${widget.pasien?.symptom ?? 'Tidak ada data'}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontFamily: 'Sans-serif',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Tingkat Keparahan: ${widget.pasien?.severity ?? 'Tidak ada data'}",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: widget.pasien?.severity != null && widget.pasien!.severity! >= 8
                            ? Colors.red
                            : (widget.pasien?.severity != null && widget.pasien!.severity! >= 5
                                ? Colors.orange
                                : Colors.green),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sans-serif',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _tombolHapusEdit(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tombol Edit
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            "EDIT",
            style: TextStyle(
              fontFamily: 'Sans-serif',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PasienForm(
                  pasien: widget.pasien!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            "DELETE",
            style: TextStyle(
              fontFamily: 'Sans-serif',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

void confirmHapus() {
  if (widget.pasien?.id == null) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WarningDialog(
        description: "ID Pasien tidak ditemukan, tidak bisa menghapus.",
      ),
    );
    return;
  }

  AlertDialog alertDialog = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    backgroundColor: backgroundColor,
    content: const Text(
      "Yakin ingin menghapus data ini?",
      style: TextStyle(
        fontSize: 16.0,
        fontFamily: 'Sans-serif',
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Text(
          "Ya",
          style: TextStyle(
            fontFamily: 'Sans-serif',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          bool success = await PasienBloc.deletePasien(
            id: widget.pasien!.id!,
          );
          if (success) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => SuccessDialog(
                description: "Pasien berhasil dihapus",
                okClick: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const PasienPage(),
                    ),
                  );
                },
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => const WarningDialog(
                description: "Hapus gagal, silahkan coba lagi",
              ),
            );
          }
        },
      ),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          "Batal",
          style: TextStyle(
            fontFamily: 'Sans-serif',
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
  showDialog(builder: (context) => alertDialog, context: context);
  }
}
