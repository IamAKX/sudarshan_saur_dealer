class Api {
  static const String baseUrl = 'https://13.51.238.100:8084';

  // static const String baseUrl = 'http://10.0.2.2:8084';

  static const String users = '$baseUrl/saur/dealers';
  static const String login = '$baseUrl/saur/dealers/authenticate';
  static const String requestWarranty = '$baseUrl/saur/warrantyRequests';
  static const String customers = '$baseUrl/saur/customers';
  static const String validateStockist = '$baseUrl/saur/stockists/crm/?';
  static const String getCustomerByMobile = '$baseUrl/saur/customers/mobileNo/';

  static const String getWarrantyByStockistCode = '$baseUrl/saur/sdw/crm/?';
  static const String allocateToDealer = '$baseUrl/saur/sdw/';
  static const String deviceDetailFromCrm =
      '$baseUrl/saur/warrantyDetails/crm/';
  static const String exernalWarranty = '$baseUrl/saur/warrantyDetails/crm/';

  static String buildOtpUrl(String phone, String otp) {
    return 'https://sms.voicesoft.in/vb/apikey.php?apikey=UaOLHBZP2GxUy3ZN&senderid=SSSPLM&number=$phone&unicode=2&message=Your%20OTP%20for%20phone%20verification%20on%20Sudarshan%20Saur%20Application%20is%20$otp';
  }


  static String buildAgreementUrl(String phone, String usertype, String id) {
    return 'https://sms.voicesoft.in/vb/apikey.php?apikey=UaOLHBZP2GxUy3ZN&senderid=SSSPLM&number=$phone&unicode=2&message=Welcome%20to%20Sudarshan%20Saur.%20Please%20download%20the%20agreement%20from%20%3A%20https%3A%2F%2F13.51.238.100%3A8084%2Fsudarshansaur%2Fagreement%2F$usertype%2F$id';
  }
}
