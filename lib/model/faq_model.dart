/// id : "1"
/// title : "Issue with Driver"
/// user_type : "customer"
/// status : "1"
/// add_date : "2024-10-07 20:42:46"
/// update_date : "2024-10-06 00:41:19"

class FaqModel {
  FaqModel({
      dynamic id, 
      dynamic title, 
      dynamic userType, 
      dynamic status, 
      dynamic addDate, 
      dynamic updateDate,}){
    _id = id;
    _title = title;
    _userType = userType;
    _status = status;
    _addDate = addDate;
    _updateDate = updateDate;
}

  FaqModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _userType = json['user_type'];
    _status = json['status'];
    _addDate = json['add_date'];
    _updateDate = json['update_date'];
  }
  dynamic _id;
  dynamic _title;
  dynamic _userType;
  dynamic _status;
  dynamic _addDate;
  dynamic _updateDate;
FaqModel copyWith({  dynamic id,
  dynamic title,
  dynamic userType,
  dynamic status,
  dynamic addDate,
  dynamic updateDate,
}) => FaqModel(  id: id ?? _id,
  title: title ?? _title,
  userType: userType ?? _userType,
  status: status ?? _status,
  addDate: addDate ?? _addDate,
  updateDate: updateDate ?? _updateDate,
);
  dynamic get id => _id;
  dynamic get title => _title;
  dynamic get userType => _userType;
  dynamic get status => _status;
  dynamic get addDate => _addDate;
  dynamic get updateDate => _updateDate;

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