/// id : "6"
/// user_type : "customer"
/// title : "Are parking fees and tolls included by the ticket price?"
/// description : "Only the transportation fees are displayed on the app. The fare displayed does not include any other fees, such as tolls, parking, road taxes, or any other incidentals."
/// status : "1"
/// add_date : "2025-01-04 11:02:14"
/// update_date : "0000-00-00 00:00:00"

class FaqModel {
  FaqModel({
      String? id, 
      String? userType, 
      String? title, 
      String? description, 
      String? status, 
      String? addDate, 
      String? updateDate,}){
    _id = id;
    _userType = userType;
    _title = title;
    _description = description;
    _status = status;
    _addDate = addDate;
    _updateDate = updateDate;
}

  FaqModel.fromJson(dynamic json) {
    _id = json['id'];
    _userType = json['user_type'];
    _title = json['title'];
    _description = json['description'];
    _status = json['status'];
    _addDate = json['add_date'];
    _updateDate = json['update_date'];
  }
  String? _id;
  String? _userType;
  String? _title;
  String? _description;
  String? _status;
  String? _addDate;
  String? _updateDate;
FaqModel copyWith({  String? id,
  String? userType,
  String? title,
  String? description,
  String? status,
  String? addDate,
  String? updateDate,
}) => FaqModel(  id: id ?? _id,
  userType: userType ?? _userType,
  title: title ?? _title,
  description: description ?? _description,
  status: status ?? _status,
  addDate: addDate ?? _addDate,
  updateDate: updateDate ?? _updateDate,
);
  String? get id => _id;
  String? get userType => _userType;
  String? get title => _title;
  String? get description => _description;
  String? get status => _status;
  String? get addDate => _addDate;
  String? get updateDate => _updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_type'] = _userType;
    map['title'] = _title;
    map['description'] = _description;
    map['status'] = _status;
    map['add_date'] = _addDate;
    map['update_date'] = _updateDate;
    return map;
  }

}