/// id : "650"
/// user_id : "338"
/// type : "driver"
/// wallet_amount : "5"
/// trn_type : "debit"
/// trn_id : null
/// payment_type : null
/// remark : "10% Amount of ORD-590 has been paid"
/// status : ""
/// payment_date : null
/// add_date : "2025-08-07 09:54:53"
/// update_date : "0000-00-00 00:00:00"

class WalletResponse {
  WalletResponse({
    String? id,
    String? userId,
    String? type,
    String? walletAmount,
    String? trnType,
    dynamic trnId,
    dynamic paymentType,
    String? remark,
    String? status,
    dynamic paymentDate,
    String? addDate,
    String? updateDate,}){
    _id = id;
    _userId = userId;
    _type = type;
    _walletAmount = walletAmount;
    _trnType = trnType;
    _trnId = trnId;
    _paymentType = paymentType;
    _remark = remark;
    _status = status;
    _paymentDate = paymentDate;
    _addDate = addDate;
    _updateDate = updateDate;
  }

  WalletResponse.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _type = json['type'];
    _walletAmount = json['wallet_amount'];
    _trnType = json['trn_type'];
    _trnId = json['trn_id'];
    _paymentType = json['payment_type'];
    _remark = json['remark'];
    _status = json['status'];
    _paymentDate = json['payment_date'];
    _addDate = json['add_date'];
    _updateDate = json['update_date'];
  }
  String? _id;
  String? _userId;
  String? _type;
  String? _walletAmount;
  String? _trnType;
  dynamic _trnId;
  dynamic _paymentType;
  String? _remark;
  String? _status;
  dynamic _paymentDate;
  String? _addDate;
  String? _updateDate;
  WalletResponse copyWith({  String? id,
    String? userId,
    String? type,
    String? walletAmount,
    String? trnType,
    dynamic trnId,
    dynamic paymentType,
    String? remark,
    String? status,
    dynamic paymentDate,
    String? addDate,
    String? updateDate,
  }) => WalletResponse(  id: id ?? _id,
    userId: userId ?? _userId,
    type: type ?? _type,
    walletAmount: walletAmount ?? _walletAmount,
    trnType: trnType ?? _trnType,
    trnId: trnId ?? _trnId,
    paymentType: paymentType ?? _paymentType,
    remark: remark ?? _remark,
    status: status ?? _status,
    paymentDate: paymentDate ?? _paymentDate,
    addDate: addDate ?? _addDate,
    updateDate: updateDate ?? _updateDate,
  );
  String? get id => _id;
  String? get userId => _userId;
  String? get type => _type;
  String? get walletAmount => _walletAmount;
  String? get trnType => _trnType;
  dynamic get trnId => _trnId;
  dynamic get paymentType => _paymentType;
  String? get remark => _remark;
  String? get status => _status;
  dynamic get paymentDate => _paymentDate;
  String? get addDate => _addDate;
  String? get updateDate => _updateDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['type'] = _type;
    map['wallet_amount'] = _walletAmount;
    map['trn_type'] = _trnType;
    map['trn_id'] = _trnId;
    map['payment_type'] = _paymentType;
    map['remark'] = _remark;
    map['status'] = _status;
    map['payment_date'] = _paymentDate;
    map['add_date'] = _addDate;
    map['update_date'] = _updateDate;
    return map;
  }

}