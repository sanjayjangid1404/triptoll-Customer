/// message : "success"
/// data : [{"id":"319","coming_soon":"no","vehicle_name":"TATA ACE","model":"diesel 2020 model","file_name":"66f3aaccbccb6-66e56ae915129-44-removebg-preview.png","weight_id":"3","weight":"750","type":"kgs","basic_fare":"325","extra_price":"15","rc_no":"5874563","rate":"18"}]
/// status : true

class SubCategoryVehicle {
  SubCategoryVehicle({
      String? message, 
      List<Data>? data, 
      bool? status,}){
    _message = message;
    _data = data;
    _status = status;
}

  SubCategoryVehicle.fromJson(dynamic json) {
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
SubCategoryVehicle copyWith({  String? message,
  List<Data>? data,
  bool? status,
}) => SubCategoryVehicle(  message: message ?? _message,
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

/// id : "319"
/// coming_soon : "no"
/// vehicle_name : "TATA ACE"
/// model : "diesel 2020 model"
/// file_name : "66f3aaccbccb6-66e56ae915129-44-removebg-preview.png"
/// weight_id : "3"
/// weight : "750"
/// type : "kgs"
/// basic_fare : "325"
/// extra_price : "15"
/// rc_no : "5874563"
/// rate : "18"

class Data {
  Data({
      String? id, 
      String? comingSoon, 
      String? vehicleName, 
      String? model, 
      String? fileName, 
      String? weightId, 
      String? weight, 
      String? type, 
      String? basicFare, 
      String? extraPrice, 
      String? rcNo, 
      String? rate,}){
    _id = id;
    _comingSoon = comingSoon;
    _vehicleName = vehicleName;
    _model = model;
    _fileName = fileName;
    _weightId = weightId;
    _weight = weight;
    _type = type;
    _basicFare = basicFare;
    _extraPrice = extraPrice;
    _rcNo = rcNo;
    _rate = rate;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _comingSoon = json['coming_soon'];
    _vehicleName = json['vehicle_name'];
    _model = json['model'];
    _fileName = json['file_name'];
    _weightId = json['weight_id'];
    _weight = json['weight'];
    _type = json['type'];
    _basicFare = json['basic_fare'];
    _extraPrice = json['extra_price'];
    _rcNo = json['rc_no'];
    _rate = json['rate'];
  }
  String? _id;
  String? _comingSoon;
  String? _vehicleName;
  String? _model;
  String? _fileName;
  String? _weightId;
  String? _weight;
  String? _type;
  String? _basicFare;
  String? _extraPrice;
  String? _rcNo;
  String? _rate;
Data copyWith({  String? id,
  String? comingSoon,
  String? vehicleName,
  String? model,
  String? fileName,
  String? weightId,
  String? weight,
  String? type,
  String? basicFare,
  String? extraPrice,
  String? rcNo,
  String? rate,
}) => Data(  id: id ?? _id,
  comingSoon: comingSoon ?? _comingSoon,
  vehicleName: vehicleName ?? _vehicleName,
  model: model ?? _model,
  fileName: fileName ?? _fileName,
  weightId: weightId ?? _weightId,
  weight: weight ?? _weight,
  type: type ?? _type,
  basicFare: basicFare ?? _basicFare,
  extraPrice: extraPrice ?? _extraPrice,
  rcNo: rcNo ?? _rcNo,
  rate: rate ?? _rate,
);
  String? get id => _id;
  String? get comingSoon => _comingSoon;
  String? get vehicleName => _vehicleName;
  String? get model => _model;
  String? get fileName => _fileName;
  String? get weightId => _weightId;
  String? get weight => _weight;
  String? get type => _type;
  String? get basicFare => _basicFare;
  String? get extraPrice => _extraPrice;
  String? get rcNo => _rcNo;
  String? get rate => _rate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['coming_soon'] = _comingSoon;
    map['vehicle_name'] = _vehicleName;
    map['model'] = _model;
    map['file_name'] = _fileName;
    map['weight_id'] = _weightId;
    map['weight'] = _weight;
    map['type'] = _type;
    map['basic_fare'] = _basicFare;
    map['extra_price'] = _extraPrice;
    map['rc_no'] = _rcNo;
    map['rate'] = _rate;
    return map;
  }

}