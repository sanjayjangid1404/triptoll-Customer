/// message : "success"
/// data : [{"file_name":"67344631f08ca-cc.png","name":"Tata Ace","id":"112","number_of_category":"0"},{"file_name":"66fe2c012aa80-bb.png","name":"Two wheelers","id":"114","number_of_category":"0"},{"file_name":"66faa19d660ac-dd.png","name":"E Rickshaw","id":"125","number_of_category":"0"},{"file_name":"6721cb36a13ce-66fae6dc90999-1e0a19f9-1af5-4a6f-8f19-296fc8b3bba9-removebg-preview.png","name":"Pick UP","id":"124","number_of_category":"0"},{"file_name":"66fe2bf0886c3-AA.png","name":"EV / 3 Wheeler","id":"123","number_of_category":"0"}]
/// status : true

class CategoryTypeResponse {
  CategoryTypeResponse({
      String? message, 
      List<Data>? data, 
      bool? status,}){
    _message = message;
    _data = data;
    _status = status;
}

  CategoryTypeResponse.fromJson(dynamic json) {
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
CategoryTypeResponse copyWith({  String? message,
  List<Data>? data,
  bool? status,
}) => CategoryTypeResponse(  message: message ?? _message,
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

/// file_name : "67344631f08ca-cc.png"
/// name : "Tata Ace"
/// id : "112"
/// number_of_category : "0"

class Data {
  Data({
      String? fileName, 
      String? name, 
      String? id, 
      String? numberOfCategory,}){
    _fileName = fileName;
    _name = name;
    _id = id;
    _numberOfCategory = numberOfCategory;
}

  Data.fromJson(dynamic json) {
    _fileName = json['file_name'];
    _name = json['name'];
    _id = json['id'];
    _numberOfCategory = json['number_of_category'];
  }
  String? _fileName;
  String? _name;
  String? _id;
  String? _numberOfCategory;
Data copyWith({  String? fileName,
  String? name,
  String? id,
  String? numberOfCategory,
}) => Data(  fileName: fileName ?? _fileName,
  name: name ?? _name,
  id: id ?? _id,
  numberOfCategory: numberOfCategory ?? _numberOfCategory,
);
  String? get fileName => _fileName;
  String? get name => _name;
  String? get id => _id;
  String? get numberOfCategory => _numberOfCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file_name'] = _fileName;
    map['name'] = _name;
    map['id'] = _id;
    map['number_of_category'] = _numberOfCategory;
    return map;
  }

}