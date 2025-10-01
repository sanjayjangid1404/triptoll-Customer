/// status : true
/// has_exceeded_limit : false
/// message : "User has 2 or fewer pending tickets."

class CheckTicketLimitModel {
  CheckTicketLimitModel({
      bool? status, 
      bool? hasExceededLimit, 
      String? message,}){
    _status = status;
    _hasExceededLimit = hasExceededLimit;
    _message = message;
}

  CheckTicketLimitModel.fromJson(dynamic json) {
    _status = json['status'];
    _hasExceededLimit = json['has_exceeded_limit'];
    _message = json['message'];
  }
  bool? _status;
  bool? _hasExceededLimit;
  String? _message;
CheckTicketLimitModel copyWith({  bool? status,
  bool? hasExceededLimit,
  String? message,
}) => CheckTicketLimitModel(  status: status ?? _status,
  hasExceededLimit: hasExceededLimit ?? _hasExceededLimit,
  message: message ?? _message,
);
  bool? get status => _status;
  bool? get hasExceededLimit => _hasExceededLimit;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['has_exceeded_limit'] = _hasExceededLimit;
    map['message'] = _message;
    return map;
  }

}