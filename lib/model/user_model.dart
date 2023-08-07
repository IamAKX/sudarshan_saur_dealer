import 'dart:convert';

import 'address_model.dart';

class UserModel {
  int? dealerId;
  String? dealerName;
  String? password;
  String? mobileNo;
  String? status;
  String? email;
  AddressModel? address;
  String? image;
  String? lastLogin;
  String? businessName;
  String? businessAddress;
  String? gstNumber;
  String? updatedOn;
  String? createdOn;
  UserModel({
    this.dealerId,
    this.dealerName,
    this.password,
    this.mobileNo,
    this.status,
    this.email,
    this.address,
    this.image,
    this.lastLogin,
    this.businessName,
    this.businessAddress,
    this.gstNumber,
    this.updatedOn,
    this.createdOn,
  });

  UserModel copyWith({
    int? dealerId,
    String? dealerName,
    String? password,
    String? mobileNo,
    String? status,
    String? email,
    AddressModel? address,
    String? image,
    String? lastLogin,
    String? businessName,
    String? businessAddress,
    String? gstNumber,
    String? updatedOn,
    String? createdOn,
  }) {
    return UserModel(
      dealerId: dealerId ?? this.dealerId,
      dealerName: dealerName ?? this.dealerName,
      password: password ?? this.password,
      mobileNo: mobileNo ?? this.mobileNo,
      status: status ?? this.status,
      email: email ?? this.email,
      address: address ?? this.address,
      image: image ?? this.image,
      lastLogin: lastLogin ?? this.lastLogin,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      gstNumber: gstNumber ?? this.gstNumber,
      updatedOn: updatedOn ?? this.updatedOn,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dealerId': dealerId,
      'dealerName': dealerName,
      'password': password,
      'mobileNo': mobileNo,
      'status': status,
      'email': email,
      'address': address?.toMap(),
      'image': image,
      'lastLogin': lastLogin,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'gstNumber': gstNumber,
      'updatedOn': updatedOn,
      'createdOn': createdOn,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      dealerId: map['dealerId']?.toInt(),
      dealerName: map['dealerName'],
      password: map['password'],
      mobileNo: map['mobileNo'],
      status: map['status'],
      email: map['email'],
      address:
          map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      image: map['image'],
      lastLogin: map['lastLogin'],
      businessName: map['businessName'],
      businessAddress: map['businessAddress'],
      gstNumber: map['gstNumber'],
      updatedOn: map['updatedOn'],
      createdOn: map['createdOn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(dealerId: $dealerId, dealerName: $dealerName, password: $password, mobileNo: $mobileNo, status: $status, email: $email, address: $address, image: $image, lastLogin: $lastLogin, businessName: $businessName, businessAddress: $businessAddress, gstNumber: $gstNumber, updatedOn: $updatedOn, createdOn: $createdOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.dealerId == dealerId &&
        other.dealerName == dealerName &&
        other.password == password &&
        other.mobileNo == mobileNo &&
        other.status == status &&
        other.email == email &&
        other.address == address &&
        other.image == image &&
        other.lastLogin == lastLogin &&
        other.businessName == businessName &&
        other.businessAddress == businessAddress &&
        other.gstNumber == gstNumber &&
        other.updatedOn == updatedOn &&
        other.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return dealerId.hashCode ^
        dealerName.hashCode ^
        password.hashCode ^
        mobileNo.hashCode ^
        status.hashCode ^
        email.hashCode ^
        address.hashCode ^
        image.hashCode ^
        lastLogin.hashCode ^
        businessName.hashCode ^
        businessAddress.hashCode ^
        gstNumber.hashCode ^
        updatedOn.hashCode ^
        createdOn.hashCode;
  }
}
