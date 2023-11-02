import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../user_model.dart';

class DealerListModel {
  List<UserModel>? data;
  DealerListModel({
    this.data,
  });

  DealerListModel copyWith({
    List<UserModel>? data,
  }) {
    return DealerListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory DealerListModel.fromMap(Map<String, dynamic> map) {
    return DealerListModel(
      data: map['data'] != null ? List<UserModel>.from(map['data']?.map((x) => UserModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DealerListModel.fromJson(String source) => DealerListModel.fromMap(json.decode(source));

  @override
  String toString() => 'DealerListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DealerListModel &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
