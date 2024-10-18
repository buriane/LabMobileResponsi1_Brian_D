class Pasien {
  int? id;
  String? namapasien;
  String? symptom;
  int? severity;
  Pasien({this.id, this.namapasien, this.symptom, this.severity});
  factory Pasien.fromJson(Map<String, dynamic> obj) {
    return Pasien(
        id: obj['id'],
        namapasien: obj['patient_name'],
        symptom: obj['symptom'],
        severity: obj['severity']);
  }
}
