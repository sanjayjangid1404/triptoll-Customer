/// id : "8"
/// title : "Issue in application"
/// user_type : "driver"
/// status : "1"
/// add_date : "2024-10-11 12:15:13"
/// update_date : "2024-10-10 23:59:26"

class FaqDriverResponse {
  FaqDriverResponse({
    String? id,
    String? title,
    String? userType,
    String? status,
    String? addDate,
    String? updateDate,}){
    _id = id;
    _title = title;
    _userType = userType;
    _status = status;
    _addDate = addDate;
    _updateDate = updateDate;
  }

  FaqDriverResponse.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _userType = json['user_type'];
    _status = json['status'];
    _addDate = json['add_date'];
    _updateDate = json['update_date'];
  }
  String? _id;
  String? _title;
  String? _userType;
  String? _status;
  String? _addDate;
  String? _updateDate;
  FaqDriverResponse copyWith({  String? id,
    String? title,
    String? userType,
    String? status,
    String? addDate,
    String? updateDate,
  }) => FaqDriverResponse(  id: id ?? _id,
    title: title ?? _title,
    userType: userType ?? _userType,
    status: status ?? _status,
    addDate: addDate ?? _addDate,
    updateDate: updateDate ?? _updateDate,
  );
  String? get id => _id;
  String? get title => _title;
  String? get userType => _userType;
  String? get status => _status;
  String? get addDate => _addDate;
  String? get updateDate => _updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['user_type'] = _userType;
    map['status'] = _status;
    map['add_date'] = _addDate;
    map['update_date'] = _updateDate;
    return map;
  }

}