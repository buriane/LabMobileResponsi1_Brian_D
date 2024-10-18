class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/';
  static const String registrasi = baseUrl + 'api/registrasi';
  static const String login = baseUrl + 'api/login';
  static const String listPasien = baseUrl + 'api/kesehatan/rekam_medis_pasien';
  static const String createPasien = baseUrl + 'api/kesehatan/rekam_medis_pasien';

  static String updatePasien(int id) {
    return baseUrl +'api/kesehatan/rekam_medis_pasien/' +id.toString() +'/update';
  }

  static String showPasien(int id) {
    return baseUrl + 'api/kesehatan/rekam_medis_pasien' + id.toString(); 
  }

  static String deletePasien(int id) {
    return baseUrl + 'api/kesehatan/rekam_medis_pasien/' + id.toString() + '/delete'; 
  }
}
