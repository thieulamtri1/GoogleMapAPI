// To parse this JSON data, do
//
//     final locationReal = locationRealFromJson(jsonString);

import 'dart:convert';

LocationReal locationRealFromJson(String str) => LocationReal.fromJson(json.decode(str));

String locationRealToJson(LocationReal data) => json.encode(data.toJson());

class LocationReal {
  LocationReal({
    this.code,
    this.status,
    this.data,
    this.paging,
  });

  int code;
  String status;
  List<Datum> data;
  Paging paging;

  factory LocationReal.fromJson(Map<String, dynamic> json) => LocationReal(
    code: json["code"],
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    paging: Paging.fromJson(json["paging"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "paging": paging.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.street,
    this.district,
    this.city,
    this.latitude,
    this.longtitude,
    this.createBy,
    this.createTime,
    this.status,
  });

  int id;
  String name;
  String street;
  String district;
  String city;
  String latitude;
  String longtitude;
  String createBy;
  DateTime createTime;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    street: json["street"],
    district: json["district"],
    city: json["city"],
    latitude: json["latitude"],
    longtitude: json["longtitude"],
    createBy: json["create_by"],
    createTime: DateTime.parse(json["create_time"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "street": street,
    "district": district,
    "city": city,
    "latitude": latitude,
    "longtitude": longtitude,
    "create_by": createBy,
    "create_time": "${createTime.year.toString().padLeft(4, '0')}-${createTime.month.toString().padLeft(2, '0')}-${createTime.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}

class Paging {
  Paging({
    this.page,
    this.totalPage,
    this.itemPerPage,
    this.totalItem,
  });

  int page;
  int totalPage;
  int itemPerPage;
  int totalItem;

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
    page: json["page"],
    totalPage: json["totalPage"],
    itemPerPage: json["itemPerPage"],
    totalItem: json["totalItem"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "totalPage": totalPage,
    "itemPerPage": itemPerPage,
    "totalItem": totalItem,
  };
}
