import 'package:responsi/bloc/pasien_bloc.dart';
import 'package:responsi/ui/pasien_page.dart';
import 'package:responsi/widget/warning_dialog.dart';
import 'package:flutter/material.dart';
import '/model/pasien.dart';

class PasienForm extends StatefulWidget {
  Pasien? pasien;
  PasienForm({Key? key, this.pasien}) : super(key: key);

  @override
  _PasienFormState createState() => _PasienFormState();
}

class _PasienFormState extends State<PasienForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PASIEN";
  String tombolSubmit = "SIMPAN";
  final _patientNameTextboxController = TextEditingController();
  final _symptomTextboxController = TextEditingController();
  final _severityTextboxController = TextEditingController();

  final primaryGreen = const Color(0xFF4CAF50);
  final accentYellow = const Color(0xFFFFEB3B);
  final backgroundColor = const Color(0xFFF1F8E9);

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pasien != null) {
      setState(() {
        judul = "UBAH PASIEN";
        tombolSubmit = "UBAH";
        _patientNameTextboxController.text = widget.pasien!.namapasien!;
        _symptomTextboxController.text = widget.pasien!.symptom!;
        _severityTextboxController.text = widget.pasien!.severity.toString();
      });
    } else {
      judul = "TAMBAH PASIEN";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Nama Pasien",
                    controller: _patientNameTextboxController,
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama Pasien harus diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Gejala",
                    controller: _symptomTextboxController,
                    prefixIcon: Icons.medical_information,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Gejala harus diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Tingkat Keparahan",
                    controller: _severityTextboxController,
                    prefixIcon: Icons.warning_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Tingkat Keparahan harus diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  _buttonSubmit(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController? controller,
    required String? Function(String?) validator,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        style: const TextStyle(fontFamily: 'Sans-serif'),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: primaryGreen,
            fontFamily: 'Sans-serif',
          ),
          prefixIcon: Icon(prefixIcon, color: primaryGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
      ),
    );
  }

  Widget _buttonSubmit() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, accentYellow],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Sans-serif',
            color: Colors.white,
          ),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.pasien != null) {
                ubah();
              } else {
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });
    Pasien createPasien = Pasien(id: null);
    createPasien.namapasien = _patientNameTextboxController.text;
    createPasien.symptom = _symptomTextboxController.text;
    createPasien.severity = int.parse(_severityTextboxController.text);
    PasienBloc.addPasien(pasien: createPasien).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const PasienPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });
    Pasien updatePasien = Pasien(id: widget.pasien!.id!);
    updatePasien.namapasien = _patientNameTextboxController.text;
    updatePasien.symptom = _symptomTextboxController.text;
    updatePasien.severity = int.parse(_severityTextboxController.text);
    PasienBloc.updatePasien(pasien: updatePasien).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const PasienPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}