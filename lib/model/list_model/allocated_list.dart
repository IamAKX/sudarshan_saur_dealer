import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../allocated_model.dart';

class AllocatedList {
  List<AllocatedModel>? data;
  AllocatedList({
    this.data,
  });

  AllocatedList copyWith({
    List<AllocatedModel>? data,
  }) {
    return AllocatedList(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory AllocatedList.fromMap(Map<String, dynamic> map) {
    return AllocatedList(
      data: map['data'] != null
          ? List<AllocatedModel>.from(
              map['data']?.map((x) => AllocatedModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AllocatedList.fromJson(String source) =>
      AllocatedList.fromMap(json.decode(source));

  @override
  String toString() => 'AllocatedList(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllocatedList && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
