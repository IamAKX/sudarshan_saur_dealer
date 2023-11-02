import 'dart:convert';

import 'address_model.dart';

class CustomerModel {
  int? customerId;
  String? customerName;
  String? mobileNo;
  String? status;
  String? email;
  AddressModel? installationAddress;
  AddressModel? address;
  String? lastLogin;
  String? image;
  CustomerModel({
    this.customerId,
    this.customerName,
    this.mobileNo,
    this.status,
    this.email,
    this.installationAddress,
    this.address,
    this.lastLogin,
    this.image,
  });

  CustomerModel copyWith({
    int? customerId,
    String? customerName,
    String? mobileNo,
    String? status,
    String? email,
    AddressModel? installationAddress,
    AddressModel? address,
    String? lastLogin,
    String? image,
  }) {
    return CustomerModel(
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      mobileNo: mobileNo ?? this.mobileNo,
      status: status ?? this.status,
      email: email ?? this.email,
      installationAddress: installationAddress ?? this.installationAddress,
      address: address ?? this.address,
      lastLogin: lastLogin ?? this.lastLogin,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'mobileNo': mobileNo,
      'status': status,
      'email': email,
      'installationAddress': installationAddress?.toMap(),
      'address': address?.toMap(),
      'lastLogin': lastLogin,
      'image': image,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      customerId: map['customerId']?.toInt(),
      customerName: map['customerName'],
      mobileNo: map['mobileNo'],
      status: map['status'],
      email: map['email'],
      installationAddress: map['installationAddress'] != null
          ? AddressModel.fromMap(map['installationAddress'])
          : null,
      address:
          map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      lastLogin: map['lastLogin'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CustomerModel(customerId: $customerId, customerName: $customerName, mobileNo: $mobileNo, status: $status, email: $email, installationAddress: $installationAddress, address: $address, lastLogin: $lastLogin, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerModel &&
        other.customerId == customerId &&
        other.customerName == customerName &&
        other.mobileNo == mobileNo &&
        other.status == status &&
        other.email == email &&
        other.installationAddress == installationAddress &&
        other.address == address &&
        other.lastLogin == lastLogin &&
        other.image == image;
  }

  @override
  int get hashCode {
    return customerId.hashCode ^
        customerName.hashCode ^
        mobileNo.hashCode ^
        status.hashCode ^
        email.hashCode ^
        installationAddress.hashCode ^
        address.hashCode ^
        lastLogin.hashCode ^
        image.hashCode;
  }
}
