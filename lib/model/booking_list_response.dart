/// id : "679"
/// order_id : "443384085728"
/// cus_id : "309"
/// driver_id : null
/// asigned_driver : null
/// category_id : "114"
/// vehicle_id : "0"
/// rate : "7"
/// amount : "83"
/// total_amount : "83"
/// stop_charge : "0"
/// booking_date : "2025-08-12 11:36:47"
/// order_status : "new"
/// read_status : "new"
/// accept_time : null
/// close_time : null
/// discount : "0"
/// discount_percentage : "0"
/// payment_type : "Online"
/// trn_id : null
/// pickup_lat : "26.83709118058908"
/// pickup_long : "75.83391509950161"
/// pickup_address : "538, Durgapura, Jaipur, India"
/// sender_name : "Mohan S"
/// sender_contact_number : "9266809133"
/// apartment_type : ""
/// drop_lat : "26.906233955536404"
/// drop_long : "75.81631477922201"
/// drop_address : "SMS HOSPITAL, Ashok Nagar, Jaipur, India"
/// receiver_name : "dddd"
/// receiver_contact_number : "6566888888"
/// reason : null
/// additional_comment : null
/// start_trip : "no"
/// add_date : "2025-08-12 11:36:47"

class BookingListResponse {
  BookingListResponse({
      String? id, 
      String? orderId, 
      String? cusId, 
      dynamic driverId, 
      dynamic asignedDriver, 
      String? categoryId, 
      String? vehicleId, 
      String? rate, 
      String? amount, 
      String? totalAmount, 
      String? stopCharge, 
      String? bookingDate, 
      String? orderStatus, 
      String? readStatus, 
      dynamic acceptTime, 
      dynamic closeTime, 
      String? discount, 
      String? discountPercentage, 
      String? paymentType, 
      dynamic trnId, 
      String? pickupLat, 
      String? pickupLong, 
      String? pickupAddress, 
      String? senderName, 
      String? senderContactNumber, 
      String? apartmentType, 
      String? dropLat, 
      String? dropLong, 
      String? dropAddress, 
      String? receiverName, 
      String? receiverContactNumber, 
      dynamic reason, 
      dynamic additionalComment, 
      String? startTrip, 
      String? addDate,}){
    _id = id;
    _orderId = orderId;
    _cusId = cusId;
    _driverId = driverId;
    _asignedDriver = asignedDriver;
    _categoryId = categoryId;
    _vehicleId = vehicleId;
    _rate = rate;
    _amount = amount;
    _totalAmount = totalAmount;
    _stopCharge = stopCharge;
    _bookingDate = bookingDate;
    _orderStatus = orderStatus;
    _readStatus = readStatus;
    _acceptTime = acceptTime;
    _closeTime = closeTime;
    _discount = discount;
    _discountPercentage = discountPercentage;
    _paymentType = paymentType;
    _trnId = trnId;
    _pickupLat = pickupLat;
    _pickupLong = pickupLong;
    _pickupAddress = pickupAddress;
    _senderName = senderName;
    _senderContactNumber = senderContactNumber;
    _apartmentType = apartmentType;
    _dropLat = dropLat;
    _dropLong = dropLong;
    _dropAddress = dropAddress;
    _receiverName = receiverName;
    _receiverContactNumber = receiverContactNumber;
    _reason = reason;
    _additionalComment = additionalComment;
    _startTrip = startTrip;
    _addDate = addDate;
}

  BookingListResponse.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _cusId = json['cus_id'];
    _driverId = json['driver_id'];
    _asignedDriver = json['asigned_driver'];
    _categoryId = json['category_id'];
    _vehicleId = json['vehicle_id'];
    _rate = json['rate'];
    _amount = json['amount'];
    _totalAmount = json['total_amount'];
    _stopCharge = json['stop_charge'];
    _bookingDate = json['booking_date'];
    _orderStatus = json['order_status'];
    _readStatus = json['read_status'];
    _acceptTime = json['accept_time'];
    _closeTime = json['close_time'];
    _discount = json['discount'];
    _discountPercentage = json['discount_percentage'];
    _paymentType = json['payment_type'];
    _trnId = json['trn_id'];
    _pickupLat = json['pickup_lat'];
    _pickupLong = json['pickup_long'];
    _pickupAddress = json['pickup_address'];
    _senderName = json['sender_name'];
    _senderContactNumber = json['sender_contact_number'];
    _apartmentType = json['apartment_type'];
    _dropLat = json['drop_lat'];
    _dropLong = json['drop_long'];
    _dropAddress = json['drop_address'];
    _receiverName = json['receiver_name'];
    _receiverContactNumber = json['receiver_contact_number'];
    _reason = json['reason'];
    _additionalComment = json['additional_comment'];
    _startTrip = json['start_trip'];
    _addDate = json['add_date'];
  }
  String? _id;
  String? _orderId;
  String? _cusId;
  dynamic _driverId;
  dynamic _asignedDriver;
  String? _categoryId;
  String? _vehicleId;
  String? _rate;
  String? _amount;
  String? _totalAmount;
  String? _stopCharge;
  String? _bookingDate;
  String? _orderStatus;
  String? _readStatus;
  dynamic _acceptTime;
  dynamic _closeTime;
  String? _discount;
  String? _discountPercentage;
  String? _paymentType;
  dynamic _trnId;
  String? _pickupLat;
  String? _pickupLong;
  String? _pickupAddress;
  String? _senderName;
  String? _senderContactNumber;
  String? _apartmentType;
  String? _dropLat;
  String? _dropLong;
  String? _dropAddress;
  String? _receiverName;
  String? _receiverContactNumber;
  dynamic _reason;
  dynamic _additionalComment;
  String? _startTrip;
  String? _addDate;
BookingListResponse copyWith({  String? id,
  String? orderId,
  String? cusId,
  dynamic driverId,
  dynamic asignedDriver,
  String? categoryId,
  String? vehicleId,
  String? rate,
  String? amount,
  String? totalAmount,
  String? stopCharge,
  String? bookingDate,
  String? orderStatus,
  String? readStatus,
  dynamic acceptTime,
  dynamic closeTime,
  String? discount,
  String? discountPercentage,
  String? paymentType,
  dynamic trnId,
  String? pickupLat,
  String? pickupLong,
  String? pickupAddress,
  String? senderName,
  String? senderContactNumber,
  String? apartmentType,
  String? dropLat,
  String? dropLong,
  String? dropAddress,
  String? receiverName,
  String? receiverContactNumber,
  dynamic reason,
  dynamic additionalComment,
  String? startTrip,
  String? addDate,
}) => BookingListResponse(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  cusId: cusId ?? _cusId,
  driverId: driverId ?? _driverId,
  asignedDriver: asignedDriver ?? _asignedDriver,
  categoryId: categoryId ?? _categoryId,
  vehicleId: vehicleId ?? _vehicleId,
  rate: rate ?? _rate,
  amount: amount ?? _amount,
  totalAmount: totalAmount ?? _totalAmount,
  stopCharge: stopCharge ?? _stopCharge,
  bookingDate: bookingDate ?? _bookingDate,
  orderStatus: orderStatus ?? _orderStatus,
  readStatus: readStatus ?? _readStatus,
  acceptTime: acceptTime ?? _acceptTime,
  closeTime: closeTime ?? _closeTime,
  discount: discount ?? _discount,
  discountPercentage: discountPercentage ?? _discountPercentage,
  paymentType: paymentType ?? _paymentType,
  trnId: trnId ?? _trnId,
  pickupLat: pickupLat ?? _pickupLat,
  pickupLong: pickupLong ?? _pickupLong,
  pickupAddress: pickupAddress ?? _pickupAddress,
  senderName: senderName ?? _senderName,
  senderContactNumber: senderContactNumber ?? _senderContactNumber,
  apartmentType: apartmentType ?? _apartmentType,
  dropLat: dropLat ?? _dropLat,
  dropLong: dropLong ?? _dropLong,
  dropAddress: dropAddress ?? _dropAddress,
  receiverName: receiverName ?? _receiverName,
  receiverContactNumber: receiverContactNumber ?? _receiverContactNumber,
  reason: reason ?? _reason,
  additionalComment: additionalComment ?? _additionalComment,
  startTrip: startTrip ?? _startTrip,
  addDate: addDate ?? _addDate,
);
  String? get id => _id;
  String? get orderId => _orderId;
  String? get cusId => _cusId;
  dynamic get driverId => _driverId;
  dynamic get asignedDriver => _asignedDriver;
  String? get categoryId => _categoryId;
  String? get vehicleId => _vehicleId;
  String? get rate => _rate;
  String? get amount => _amount;
  String? get totalAmount => _totalAmount;
  String? get stopCharge => _stopCharge;
  String? get bookingDate => _bookingDate;
  String? get orderStatus => _orderStatus;
  String? get readStatus => _readStatus;
  dynamic get acceptTime => _acceptTime;
  dynamic get closeTime => _closeTime;
  String? get discount => _discount;
  String? get discountPercentage => _discountPercentage;
  String? get paymentType => _paymentType;
  dynamic get trnId => _trnId;
  String? get pickupLat => _pickupLat;
  String? get pickupLong => _pickupLong;
  String? get pickupAddress => _pickupAddress;
  String? get senderName => _senderName;
  String? get senderContactNumber => _senderContactNumber;
  String? get apartmentType => _apartmentType;
  String? get dropLat => _dropLat;
  String? get dropLong => _dropLong;
  String? get dropAddress => _dropAddress;
  String? get receiverName => _receiverName;
  String? get receiverContactNumber => _receiverContactNumber;
  dynamic get reason => _reason;
  dynamic get additionalComment => _additionalComment;
  String? get startTrip => _startTrip;
  String? get addDate => _addDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['cus_id'] = _cusId;
    map['driver_id'] = _driverId;
    map['asigned_driver'] = _asignedDriver;
    map['category_id'] = _categoryId;
    map['vehicle_id'] = _vehicleId;
    map['rate'] = _rate;
    map['amount'] = _amount;
    map['total_amount'] = _totalAmount;
    map['stop_charge'] = _stopCharge;
    map['booking_date'] = _bookingDate;
    map['order_status'] = _orderStatus;
    map['read_status'] = _readStatus;
    map['accept_time'] = _acceptTime;
    map['close_time'] = _closeTime;
    map['discount'] = _discount;
    map['discount_percentage'] = _discountPercentage;
    map['payment_type'] = _paymentType;
    map['trn_id'] = _trnId;
    map['pickup_lat'] = _pickupLat;
    map['pickup_long'] = _pickupLong;
    map['pickup_address'] = _pickupAddress;
    map['sender_name'] = _senderName;
    map['sender_contact_number'] = _senderContactNumber;
    map['apartment_type'] = _apartmentType;
    map['drop_lat'] = _dropLat;
    map['drop_long'] = _dropLong;
    map['drop_address'] = _dropAddress;
    map['receiver_name'] = _receiverName;
    map['receiver_contact_number'] = _receiverContactNumber;
    map['reason'] = _reason;
    map['additional_comment'] = _additionalComment;
    map['start_trip'] = _startTrip;
    map['add_date'] = _addDate;
    return map;
  }

}