/// id : "39"
/// name : "Ahmedabad"
/// status : "1"
/// add_date : "2023-04-05 14:57:31"

class CityResponse {
  CityResponse({
    String? id,
    String? name,
    String? status,
    String? addDate,}){
    _id = id;
    _name = name;
    _status = status;
    _addDate = addDate;
  }

  CityResponse.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'];
    _addDate = json['add_date'];
  }
  String? _id;
  String? _name;
  String? _status;
  String? _addDate;
  CityResponse copyWith({  String? id,
    String? name,
    String? status,
    String? addDate,
  }) => CityResponse(  id: id ?? _id,
    name: name ?? _name,
    status: status ?? _status,
    addDate: addDate ?? _addDate,
  );
  String? get id => _id;
  String? get name => _name;
  String? get status => _status;
  String? get addDate => _addDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['status'] = _status;
    map['add_date'] = _addDate;
    return map;
  }

}