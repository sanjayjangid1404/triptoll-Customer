/// status : true
/// notifications : [{"id":"13","user_type":"Driver","city_id":"62","vehicle_category":"112","message":"Get 100 Rs wallet amount on each referral. To know more get in touch with out support team.","add_date":"2025-10-17 15:12:44"}]

class NotificationHistoryModel {
  NotificationHistoryModel({
    bool? status,
    List<Notifications>? notifications,}){
    _status = status;
    _notifications = notifications;
  }

  NotificationHistoryModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['notifications'] != null) {
      _notifications = [];
      json['notifications'].forEach((v) {
        _notifications?.add(Notifications.fromJson(v));
      });
    }
  }
  bool? _status;
  List<Notifications>? _notifications;
  NotificationHistoryModel copyWith({  bool? status,
    List<Notifications>? notifications,
  }) => NotificationHistoryModel(  status: status ?? _status,
    notifications: notifications ?? _notifications,
  );
  bool? get status => _status;
  List<Notifications>? get notifications => _notifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_notifications != null) {
      map['notifications'] = _notifications?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "13"
/// user_type : "Driver"
/// city_id : "62"
/// vehicle_category : "112"
/// message : "Get 100 Rs wallet amount on each referral. To know more get in touch with out support team."
/// add_date : "2025-10-17 15:12:44"

class Notifications {
  Notifications({
    String? id,
    String? userType,
    String? cityId,
    String? vehicleCategory,
    String? message,
    String? addDate,}){
    _id = id;
    _userType = userType;
    _cityId = cityId;
    _vehicleCategory = vehicleCategory;
    _message = message;
    _addDate = addDate;
  }

  Notifications.fromJson(dynamic json) {
    _id = json['id'];
    _userType = json['user_type'];
    _cityId = json['city_id'];
    _vehicleCategory = json['vehicle_category'];
    _message = json['message'];
    _addDate = json['add_date'];
  }
  String? _id;
  String? _userType;
  String? _cityId;
  String? _vehicleCategory;
  String? _message;
  String? _addDate;
  Notifications copyWith({  String? id,
    String? userType,
    String? cityId,
    String? vehicleCategory,
    String? message,
    String? addDate,
  }) => Notifications(  id: id ?? _id,
    userType: userType ?? _userType,
    cityId: cityId ?? _cityId,
    vehicleCategory: vehicleCategory ?? _vehicleCategory,
    message: message ?? _message,
    addDate: addDate ?? _addDate,
  );
  String? get id => _id;
  String? get userType => _userType;
  String? get cityId => _cityId;
  String? get vehicleCategory => _vehicleCategory;
  String? get message => _message;
  String? get addDate => _addDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_type'] = _userType;
    map['city_id'] = _cityId;
    map['vehicle_category'] = _vehicleCategory;
    map['message'] = _message;
    map['add_date'] = _addDate;
    return map;
  }

}