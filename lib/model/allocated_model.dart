import 'dart:convert';

import 'package:saur_dealer/model/stockist_model.dart';
import 'package:saur_dealer/model/warranty_request_model.dart';

class AllocatedModel {
  StockistModel? stockists;
  String? warrantySerialNo;
  WarrantyRequestModel? warrantyRequests;
  AllocatedModel({
    this.stockists,
    this.warrantySerialNo,
    this.warrantyRequests,
  });

  AllocatedModel copyWith({
    StockistModel? stockists,
    String? warrantySerialNo,
    WarrantyRequestModel? warrantyRequests,
  }) {
    return AllocatedModel(
      stockists: stockists ?? this.stockists,
      warrantySerialNo: warrantySerialNo ?? this.warrantySerialNo,
      warrantyRequests: warrantyRequests ?? this.warrantyRequests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stockists': stockists?.toMap(),
      'warrantySerialNo': warrantySerialNo,
      'warrantyRequests': warrantyRequests?.toMap(),
    };
  }

  factory AllocatedModel.fromMap(Map<String, dynamic> map) {
    return AllocatedModel(
      stockists: map['stockists'] != null ? StockistModel.fromMap(map['stockists']) : null,
      warrantySerialNo: map['warrantySerialNo'],
      warrantyRequests: map['warrantyRequests'] != null ? WarrantyRequestModel.fromMap(map['warrantyRequests']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllocatedModel.fromJson(String source) => AllocatedModel.fromMap(json.decode(source));

  @override
  String toString() => 'AllocatedModel(stockists: $stockists, warrantySerialNo: $warrantySerialNo, warrantyRequests: $warrantyRequests)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AllocatedModel &&
      other.stockists == stockists &&
      other.warrantySerialNo == warrantySerialNo &&
      other.warrantyRequests == warrantyRequests;
  }

  @override
  int get hashCode => stockists.hashCode ^ warrantySerialNo.hashCode ^ warrantyRequests.hashCode;
}
