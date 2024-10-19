import 'dart:ffi';

class ParkinglotInfo {
  final int id;
  final String name;
  final String address;
  final int startHour;
  final int endHour;
  final int carChargeFeeWeek;
  final int carChargeFeeHoli;
  final int motoChargeFeeWeek;
  final int motoChargeFeeHoli;
  final double latitude;
  final double longitude;

  ParkinglotInfo(
    this.id,
    this.name,
    this.address,
    this.startHour,
    this.endHour,
    this.carChargeFeeWeek,
    this.carChargeFeeHoli,
    this.motoChargeFeeWeek,
    this.motoChargeFeeHoli,
    this.latitude,
    this.longitude,
  );

  ParkinglotInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        address = json['address'] as String,
        startHour = json['startHour'] as int,
        endHour = json['endHour'] as int,
        carChargeFeeWeek = json['carChargeFeeWeek'] as int,
        carChargeFeeHoli = json['carChargeFeeHoli'] as int,
        motoChargeFeeWeek = json['motoChargeFeeWeek'] as int,
        motoChargeFeeHoli = json['motoChargeFeeHoli'] as int,
        latitude = json['latitude'] as double,
        longitude = json['longitude'] as double;
}

class ParkinglotSpace {
  final int id;
  final int carAvail;
  final int carTotal;
  final int motoAvail;
  final int motoTotal;
  final String updateDate;
  final int updateDay;
  final String updateTime;
  final int parkinglot_id;

  ParkinglotSpace(
    this.id,
    this.carAvail,
    this.carTotal,
    this.motoAvail,
    this.motoTotal,
    this.updateDate,
    this.updateDay,
    this.updateTime,
    this.parkinglot_id,
  );

  ParkinglotSpace.fromJson(Map<String, dynamic> json)
      : this.id = json['id'] as int,
        this.carAvail = json['carAvail'] as int,
        this.carTotal = json['carTotal'] as int,
        this.motoAvail = json['motoAvail'] as int,
        this.motoTotal = json['motoTotal'] as int,
        this.updateDate = json['updateDate'] as String,
        this.updateDay = json['updateDay'] as int,
        this.updateTime = json['updateTime'] as String,
        this.parkinglot_id = json['parkinglot_id'] as int;
}
