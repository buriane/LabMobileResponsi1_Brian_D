import 'package:flutter/material.dart';
import 'package:responsi/bloc/logout_bloc.dart';
import 'package:responsi/bloc/pasien_bloc.dart';
import 'package:responsi/model/pasien.dart';
import 'package:responsi/ui/login_page.dart';
import 'package:responsi/ui/pasien_detail.dart';
import 'package:responsi/ui/pasien_form.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({Key? key}) : super(key: key);
  @override
  _PasienPageState createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  final primaryGreen = const Color(0xFF4CAF50);
  final accentYellow = const Color(0xFFFFEB3B);
  final backgroundColor = const Color(0xFFF1F8E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'LIST PASIEN',
          style: TextStyle(
            fontFamily: 'Sans-serif',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryGreen,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: accentYellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.black87,
                ),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PasienForm()));
                },
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: backgroundColor,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryGreen, accentYellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Rekam Medis Pasien',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sans-serif',
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: primaryGreen),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: primaryGreen,
                    fontFamily: 'Sans-serif',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await LogoutBloc.logout().then((value) => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false)
                      });
                },
              )
            ],
          ),
        ),
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
        child: FutureBuilder<List>(
          future: PasienBloc.getPasiens(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListPasien(
                    list: snapshot.data,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class ListPasien extends StatelessWidget {
  final List? list;
  const ListPasien({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemPasien(
          pasien: list![i],
        );
      },
    );
  }
}

class ItemPasien extends StatelessWidget {
  final Pasien pasien;
  const ItemPasien({Key? key, required this.pasien}) : super(key: key);

  Color _getSeverityColor(int severity) {
    if (severity >= 8) return Colors.red;
    if (severity >= 5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasienDetail(
                pasien: pasien,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      pasien.namapasien!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sans-serif',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(pasien.severity!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tingkat Keparahan : ${pasien.severity}',
                      style: TextStyle(
                        color: _getSeverityColor(pasien.severity!),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        fontFamily: 'Sans-serif',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                pasien.symptom!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: 'Sans-serif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}