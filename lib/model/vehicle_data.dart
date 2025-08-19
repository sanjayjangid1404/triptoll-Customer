/// message : "success"
/// data : [{"id":"114","name":"Two wheelers","max_load":"20","load_unit":"kg","base_fare":"42.00","base_fare_upto":"2","rate1_per_km":"6.00","rate2_per_km":"7.00","rate3_per_km":"6.00","rate4_per_km":"7.00","extra_price":"15","file_name":"66fe2c012aa80-bb.png"},{"id":"125","name":"E Rickshaw","max_load":"250","load_unit":"kg","base_fare":"69.00","base_fare_upto":"2","rate1_per_km":"6.00","rate2_per_km":"7.00","rate3_per_km":"6.00","rate4_per_km":"7.00","extra_price":"15","file_name":"66faa19d660ac-dd.png"},{"id":"123","name":"EV / 3 Wheeler","max_load":"500","load_unit":"kg","base_fare":"242.00","base_fare_upto":"2","rate1_per_km":"14.00","rate2_per_km":"15.00","rate3_per_km":"14.00","rate4_per_km":"15.00","extra_price":"15","file_name":"66fe2bf0886c3-AA.png"},{"id":"112","name":"Tata Ace","max_load":"750","load_unit":"kg","base_fare":"325.00","base_fare_upto":"2","rate1_per_km":"18.00","rate2_per_km":"19.00","rate3_per_km":"18.00","rate4_per_km":"19.00","extra_price":"15","file_name":"67344631f08ca-cc.png"},{"id":"124","name":"Pick UP","max_load":"1000","load_unit":"kg","base_fare":"430.00","base_fare_upto":"2","rate1_per_km":"22.00","rate2_per_km":"23.00","rate3_per_km":"22.00","rate4_per_km":"23.00","extra_price":"15","file_name":"6721cb36a13ce-66fae6dc90999-1e0a19f9-1af5-4a6f-8f19-296fc8b3bba9-removebg-preview.png"}]
/// status : true

class VehicleData {
  VehicleData({
      String? message, 
      List<Data>? data, 
      bool? status,}){
    _message = message;
    _data = data;
    _status = status;
}

  VehicleData.fromJson(dynamic json) {
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _status = json['status'];
  }
  String? _message;
  List<Data>? _data;
  bool? _status;
VehicleData copyWith({  String? message,
  List<Data>? data,
  bool? status,
}) => VehicleData(  message: message ?? _message,
  data: data ?? _data,
  status: status ?? _status,
);
  String? get message => _message;
  List<Data>? get data => _data;
  bool? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    return map;
  }

}

/// id : "114"
/// name : "Two wheelers"
/// max_load : "20"
/// load_unit : "kg"
/// base_fare : "42.00"
/// base_fare_upto : "2"
/// rate1_per_km : "6.00"
/// rate2_per_km : "7.00"
/// rate3_per_km : "6.00"
/// rate4_per_km : "7.00"
/// extra_price : "15"
/// file_name : "66fe2c012aa80-bb.png"

class Data {
  Data({
      String? id, 
      String? name, 
      String? maxLoad, 
      String? loadUnit, 
      String? baseFare, 
      String? baseFareUpto, 
      String? rate1PerKm, 
      String? rate2PerKm, 
      String? rate3PerKm, 
      String? rate4PerKm, 
      String? extraPrice, 
      String? fileName,}){
    _id = id;
    _name = name;
    _maxLoad = maxLoad;
    _loadUnit = loadUnit;
    _baseFare = baseFare;
    _baseFareUpto = baseFareUpto;
    _rate1PerKm = rate1PerKm;
    _rate2PerKm = rate2PerKm;
    _rate3PerKm = rate3PerKm;
    _rate4PerKm = rate4PerKm;
    _extraPrice = extraPrice;
    _fileName = fileName;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _maxLoad = json['max_load'];
    _loadUnit = json['load_unit'];
    _baseFare = json['base_fare'];
    _baseFareUpto = json['base_fare_upto'];
    _rate1PerKm = json['rate1_per_km'];
    _rate2PerKm = json['rate2_per_km'];
    _rate3PerKm = json['rate3_per_km'];
    _rate4PerKm = json['rate4_per_km'];
    _extraPrice = json['extra_price'];
    _fileName = json['file_name'];
  }
  String? _id;
  String? _name;
  String? _maxLoad;
  String? _loadUnit;
  String? _baseFare;
  String? _baseFareUpto;
  String? _rate1PerKm;
  String? _rate2PerKm;
  String? _rate3PerKm;
  String? _rate4PerKm;
  String? _extraPrice;
  String? _fileName;
Data copyWith({  String? id,
  String? name,
  String? maxLoad,
  String? loadUnit,
  String? baseFare,
  String? baseFareUpto,
  String? rate1PerKm,
  String? rate2PerKm,
  String? rate3PerKm,
  String? rate4PerKm,
  String? extraPrice,
  String? fileName,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  maxLoad: maxLoad ?? _maxLoad,
  loadUnit: loadUnit ?? _loadUnit,
  baseFare: baseFare ?? _baseFare,
  baseFareUpto: baseFareUpto ?? _baseFareUpto,
  rate1PerKm: rate1PerKm ?? _rate1PerKm,
  rate2PerKm: rate2PerKm ?? _rate2PerKm,
  rate3PerKm: rate3PerKm ?? _rate3PerKm,
  rate4PerKm: rate4PerKm ?? _rate4PerKm,
  extraPrice: extraPrice ?? _extraPrice,
  fileName: fileName ?? _fileName,
);
  String? get id => _id;
  String? get name => _name;
  String? get maxLoad => _maxLoad;
  String? get loadUnit => _loadUnit;
  String? get baseFare => _baseFare;
  String? get baseFareUpto => _baseFareUpto;
  String? get rate1PerKm => _rate1PerKm;
  String? get rate2PerKm => _rate2PerKm;
  String? get rate3PerKm => _rate3PerKm;
  String? get rate4PerKm => _rate4PerKm;
  String? get extraPrice => _extraPrice;
  String? get fileName => _fileName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['max_load'] = _maxLoad;
    map['load_unit'] = _loadUnit;
    map['base_fare'] = _baseFare;
    map['base_fare_upto'] = _baseFareUpto;
    map['rate1_per_km'] = _rate1PerKm;
    map['rate2_per_km'] = _rate2PerKm;
    map['rate3_per_km'] = _rate3PerKm;
    map['rate4_per_km'] = _rate4PerKm;
    map['extra_price'] = _extraPrice;
    map['file_name'] = _fileName;
    return map;
  }

}