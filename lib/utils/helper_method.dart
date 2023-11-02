import 'dart:math';

import '../model/address_model.dart';

String getShortMessageByStatus(String status) {
  switch (status) {
    case 'PENDING':
      return 'Request in review';
    case 'APPROVED':
      return 'Request is approved';
    case 'DECLINED':
      return 'Request is rejected';
    default:
      return 'Request is ${status.toLowerCase()}';
  }
}

String getDetailedMessageByStatus(String status) {
  switch (status) {
    case 'PENDING':
      return 'Your request is under validation, you will be notified in 24 hours';
    case 'APPROVED':
      return 'Your guarantee card is generated. You get download or get it on email or whatsapp.';
    case 'DECLINED':
      return 'Your request is rejected by admin';
    default:
      return 'Request is ${status.toLowerCase()}';
  }
}

String prepareAddress(AddressModel? address) {
  return '';
  // '${address?.addressLine1}, ${address?.addressLine2}, ${address?.city}, ${address?.state} - ${address?.zipCode}';
}

String getOTPCode() {
  return (Random().nextInt(900000) + 100000).toString();
}

bool isValidPhoneNumber(String number) {
  if (number.length != 10) return false;
  try {
    int.parse(number);
  } catch (e) {
    return false;
  }
  return true;
}

bool isValidZipcode(String number) {
  if (number.length != 6) return false;
  try {
    int.parse(number);
  } catch (e) {
    return false;
  }
  return true;
}

bool isValidSerialNumber(String number) {
  if (number.length != 6) return false;
  try {
    int.parse(number);
  } catch (e) {
    return false;
  }
  return true;
}
