class Api {
  static const String baseUrl = 'https://icrmonline.in:8084';
  // static const String baseUrl = 'http://10.0.2.2:8084';

  static const String users = '$baseUrl/saur/dealers';
  static const String login = '$baseUrl/saur/dealers/authenticate';
  static const String requestWarranty = '$baseUrl/saur/warrantyDetails';
  static const String customers = '$baseUrl/saur/customers';

  static String buildOtpUrl(String phone, String otp) {
    return 'https://sms.voicesoft.in/vb/apikey.php?apikey=UaOLHBZP2GxUy3ZN&senderid=SSSPLM&number=$phone&unicode=2&message=Your%20OTP%20for%20phone%20verification%20on%20Sudarshan%20Saur%20Application%20is%20$otp';
  }
}
