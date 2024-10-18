import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/pasien.dart';

class PasienBloc {
  static Future<List<Pasien>> getPasiens() async {
    String apiUrl = ApiUrl.listPasien;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPasien = (jsonObj as Map<String, dynamic>)['data'];
    List<Pasien> pasiens = [];
    for (int i = 0; i < listPasien.length; i++) {
      pasiens.add(Pasien.fromJson(listPasien[i]));
    }
    return pasiens;
  }

  static Future addPasien({Pasien? pasien}) async {
    String apiUrl = ApiUrl.createPasien;

    var body = {
      "patient_name": pasien!.namapasien,
      "symptom": pasien.symptom,
      "severity": pasien.severity.toString()
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePasien({required Pasien pasien}) async {
    String apiUrl = ApiUrl.updatePasien(pasien.id!);
    print(apiUrl);

    var body = {
      "patient_name": pasien.namapasien,
      "symptom": pasien.symptom,
      "severity": pasien.severity.toString()
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePasien({int? id}) async {
    String apiUrl = ApiUrl.deletePasien(id!);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}