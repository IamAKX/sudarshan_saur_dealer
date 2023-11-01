import 'dart:convert';

import 'address_model.dart';

class UserModel {
  int? dealerId;
  String? dealerName;
  String? mobileNo;
  String? status;
  String? email;
  AddressModel? address;
  String? image;
  String? lastLogin;
  String? businessName;
  
  String? gstNumber;
  String? updatedOn;
  String? createdOn;
  String? stockistCode;
  String? stockistBusinessName;
  UserModel({
    this.dealerId,
    this.dealerName,
    this.mobileNo,
    this.status,
    this.email,
    this.address,
    this.image,
    this.lastLogin,
    this.businessName,
    this.gstNumber,
    this.updatedOn,
    this.createdOn,
    this.stockistCode,
    this.stockistBusinessName,
  });

  UserModel copyWith({
    int? dealerId,
    String? dealerName,
    String? mobileNo,
    String? status,
    String? email,
    AddressModel? address,
    String? image,
    String? lastLogin,
    String? businessName,
    String? gstNumber,
    String? updatedOn,
    String? createdOn,
    String? stockistCode,
    String? stockistBusinessName,
  }) {
    return UserModel(
      dealerId: dealerId ?? this.dealerId,
      dealerName: dealerName ?? this.dealerName,
      mobileNo: mobileNo ?? this.mobileNo,
      status: status ?? this.status,
      email: email ?? this.email,
      address: address ?? this.address,
      image: image ?? this.image,
      lastLogin: lastLogin ?? this.lastLogin,
      businessName: businessName ?? this.businessName,
      gstNumber: gstNumber ?? this.gstNumber,
      updatedOn: updatedOn ?? this.updatedOn,
      createdOn: createdOn ?? this.createdOn,
      stockistCode: stockistCode ?? this.stockistCode,
      stockistBusinessName: stockistBusinessName ?? this.stockistBusinessName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dealerId': dealerId,
      'dealerName': dealerName,
      'mobileNo': mobileNo,
      'status': status,
      'email': email,
      'address': address?.toMap(),
      'image': image,
      'lastLogin': lastLogin,
      'businessName': businessName,
      'gstNumber': gstNumber,
      'updatedOn': updatedOn,
      'createdOn': createdOn,
      'stockistCode': stockistCode,
      'stockistBusinessName': stockistBusinessName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      dealerId: map['dealerId']?.toInt(),
      dealerName: map['dealerName'],
      mobileNo: map['mobileNo'],
      status: map['status'],
      email: map['email'],
      address: map['address'] != null ? AddressModel.fromMap(map['address']) : null,
      image: map['image'],
      lastLogin: map['lastLogin'],
      businessName: map['businessName'],
      gstNumber: map['gstNumber'],
      updatedOn: map['updatedOn'],
      createdOn: map['createdOn'],
      stockistCode: map['stockistCode'],
      stockistBusinessName: map['stockistBusinessName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(dealerId: $dealerId, dealerName: $dealerName, mobileNo: $mobileNo, status: $status, email: $email, address: $address, image: $image, lastLogin: $lastLogin, businessName: $businessName, gstNumber: $gstNumber, updatedOn: $updatedOn, createdOn: $createdOn, stockistCode: $stockistCode, stockistBusinessName: $stockistBusinessName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.dealerId == dealerId &&
      other.dealerName == dealerName &&
      other.mobileNo == mobileNo &&
      other.status == status &&
      other.email == email &&
      other.address == address &&
      other.image == image &&
      other.lastLogin == lastLogin &&
      other.businessName == businessName &&
      other.gstNumber == gstNumber &&
      other.updatedOn == updatedOn &&
      other.createdOn == createdOn &&
      other.stockistCode == stockistCode &&
      other.stockistBusinessName == stockistBusinessName;
  }

  @override
  int get hashCode {
    return dealerId.hashCode ^
      dealerName.hashCode ^
      mobileNo.hashCode ^
      status.hashCode ^
      email.hashCode ^
      address.hashCode ^
      image.hashCode ^
      lastLogin.hashCode ^
      businessName.hashCode ^
      gstNumber.hashCode ^
      updatedOn.hashCode ^
      createdOn.hashCode ^
      stockistCode.hashCode ^
      stockistBusinessName.hashCode;
  }
}
