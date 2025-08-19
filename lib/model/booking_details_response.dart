/// id : "651"
/// order_id : "794374654217"
/// cus_id : "309"
/// driver_id : "338"
/// asigned_driver : null
/// category_id : "114"
/// vehicle_id : "114"
/// rate : "6"
/// amount : "88"
/// total_amount : "88"
/// stop_charge : "0"
/// booking_date : "2025-08-10 17:32:04"
/// order_status : "delivered"
/// read_status : "new"
/// accept_time : "2025-08-10 18:22:44"
/// close_time : null
/// discount : "0"
/// discount_percentage : "0"
/// payment_type : "Online"
/// trn_id : null
/// pickup_lat : "26.8892941636895"
/// pickup_long : "75.91173570603132"
/// pickup_address : "A68, Sumel, Jaipur, India"
/// sender_name : "Mohan S"
/// sender_contact_number : "9266809133"
/// apartment_type : ""
/// drop_lat : "26.906233955536404"
/// drop_long : "75.81631477922201"
/// drop_address : "SMS HOSPITAL, Ashok Nagar, Jaipur, India"
/// receiver_name : "ff"
/// receiver_contact_number : "5699658888"
/// reason : null
/// additional_comment : null
/// picked_time : "2025-08-10 18:55:33"
/// delivery_time : "2025-08-10 18:55:40"
/// cancelled_time : null
/// start_trip : "yes"
/// add_date : "2025-08-10 17:32:04"
/// contact_number : "9266809133"
/// lat : "26.8892871"
/// long : "75.911688"
/// first_name : "Mohan"
/// last_name : "K"
/// gender : "male"
/// vehicle_name : "Diesel"
/// model : "2023"
/// rc_no : "gagahash"
/// weight : "500"
/// weight_type : "kgs"
/// category_name : "Two wheelers"
/// vehicle_img : "670bc024681b7-1728823328734.jpg"
/// id_proof_img : "6708b6dcc651e-1728624333430.jpg"
/// id_proof_back_img : "6708b6dd82bf5-1728624343954.jpg"
/// category_img : "66fe2c012aa80-bb.png"
/// driver_img : null
/// review : null
/// rating : null
/// all_drop_address : []

class BookingDetailsResponse {
  BookingDetailsResponse({
      String? id, 
      String? orderId, 
      String? cusId, 
      String? driverId, 
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
      String? acceptTime, 
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
      String? pickedTime, 
      String? deliveryTime, 
      dynamic cancelledTime, 
      String? startTrip, 
      String? addDate, 
      String? contactNumber, 
      String? lat, 
      String? long, 
      String? firstName, 
      String? lastName, 
      String? gender, 
      String? vehicleName, 
      String? model, 
      String? rcNo, 
      String? weight, 
      String? weightType, 
      String? categoryName, 
      String? vehicleImg, 
      String? idProofImg, 
      String? idProofBackImg, 
      String? categoryImg, 
      dynamic driverImg, 
      dynamic review, 
      dynamic rating, 
      List<dynamic>? allDropAddress,}){
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
    _pickedTime = pickedTime;
    _deliveryTime = deliveryTime;
    _cancelledTime = cancelledTime;
    _startTrip = startTrip;
    _addDate = addDate;
    _contactNumber = contactNumber;
    _lat = lat;
    _long = long;
    _firstName = firstName;
    _lastName = lastName;
    _gender = gender;
    _vehicleName = vehicleName;
    _model = model;
    _rcNo = rcNo;
    _weight = weight;
    _weightType = weightType;
    _categoryName = categoryName;
    _vehicleImg = vehicleImg;
    _idProofImg = idProofImg;
    _idProofBackImg = idProofBackImg;
    _categoryImg = categoryImg;
    _driverImg = driverImg;
    _review = review;
    _rating = rating;
    _allDropAddress = allDropAddress;
}

  BookingDetailsResponse.fromJson(dynamic json) {
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
    _orderStatus = json['order_status']??"";
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
    _pickedTime = json['picked_time'];
    _deliveryTime = json['delivery_time'];
    _cancelledTime = json['cancelled_time'];
    _startTrip = json['start_trip'];
    _addDate = json['add_date'];
    _contactNumber = json['contact_number'];
    _lat = json['lat'];
    _long = json['long'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _gender = json['gender'];
    _vehicleName = json['vehicle_name'];
    _model = json['model'];
    _rcNo = json['rc_no'];
    _weight = json['weight'];
    _weightType = json['weight_type'];
    _categoryName = json['category_name'];
    _vehicleImg = json['vehicle_img'];
    _idProofImg = json['id_proof_img'];
    _idProofBackImg = json['id_proof_back_img'];
    _categoryImg = json['category_img'];
    _driverImg = json['driver_img'];
    _review = json['review'];
    _rating = json['rating'];
    // if (json['all_drop_address'] != null) {
    //   _allDropAddress = [];
    //   json['all_drop_address'].forEach((v) {
    //     _allDropAddress?.add(Dynamic.fromJson(v));
    //   });
    // }
  }
  String? _id;
  String? _orderId;
  String? _cusId;
  String? _driverId;
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
  String? _acceptTime;
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
  String? _pickedTime;
  String? _deliveryTime;
  dynamic _cancelledTime;
  String? _startTrip;
  String? _addDate;
  String? _contactNumber;
  String? _lat;
  String? _long;
  String? _firstName;
  String? _lastName;
  String? _gender;
  String? _vehicleName;
  String? _model;
  String? _rcNo;
  String? _weight;
  String? _weightType;
  String? _categoryName;
  String? _vehicleImg;
  String? _idProofImg;
  String? _idProofBackImg;
  String? _categoryImg;
  dynamic _driverImg;
  dynamic _review;
  dynamic _rating;
  List<dynamic>? _allDropAddress;
BookingDetailsResponse copyWith({  String? id,
  String? orderId,
  String? cusId,
  String? driverId,
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
  String? acceptTime,
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
  String? pickedTime,
  String? deliveryTime,
  dynamic cancelledTime,
  String? startTrip,
  String? addDate,
  String? contactNumber,
  String? lat,
  String? long,
  String? firstName,
  String? lastName,
  String? gender,
  String? vehicleName,
  String? model,
  String? rcNo,
  String? weight,
  String? weightType,
  String? categoryName,
  String? vehicleImg,
  String? idProofImg,
  String? idProofBackImg,
  String? categoryImg,
  dynamic driverImg,
  dynamic review,
  dynamic rating,
  List<dynamic>? allDropAddress,
}) => BookingDetailsResponse(  id: id ?? _id,
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
  pickedTime: pickedTime ?? _pickedTime,
  deliveryTime: deliveryTime ?? _deliveryTime,
  cancelledTime: cancelledTime ?? _cancelledTime,
  startTrip: startTrip ?? _startTrip,
  addDate: addDate ?? _addDate,
  contactNumber: contactNumber ?? _contactNumber,
  lat: lat ?? _lat,
  long: long ?? _long,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  gender: gender ?? _gender,
  vehicleName: vehicleName ?? _vehicleName,
  model: model ?? _model,
  rcNo: rcNo ?? _rcNo,
  weight: weight ?? _weight,
  weightType: weightType ?? _weightType,
  categoryName: categoryName ?? _categoryName,
  vehicleImg: vehicleImg ?? _vehicleImg,
  idProofImg: idProofImg ?? _idProofImg,
  idProofBackImg: idProofBackImg ?? _idProofBackImg,
  categoryImg: categoryImg ?? _categoryImg,
  driverImg: driverImg ?? _driverImg,
  review: review ?? _review,
  rating: rating ?? _rating,
  allDropAddress: allDropAddress ?? _allDropAddress,
);
  String? get id => _id;
  String? get orderId => _orderId;
  String? get cusId => _cusId;
  String? get driverId => _driverId;
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
  String? get acceptTime => _acceptTime;
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
  String? get pickedTime => _pickedTime;
  String? get deliveryTime => _deliveryTime;
  dynamic get cancelledTime => _cancelledTime;
  String? get startTrip => _startTrip;
  String? get addDate => _addDate;
  String? get contactNumber => _contactNumber;
  String? get lat => _lat;
  String? get long => _long;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get gender => _gender;
  String? get vehicleName => _vehicleName;
  String? get model => _model;
  String? get rcNo => _rcNo;
  String? get weight => _weight;
  String? get weightType => _weightType;
  String? get categoryName => _categoryName;
  String? get vehicleImg => _vehicleImg;
  String? get idProofImg => _idProofImg;
  String? get idProofBackImg => _idProofBackImg;
  String? get categoryImg => _categoryImg;
  dynamic get driverImg => _driverImg;
  dynamic get review => _review;
  dynamic get rating => _rating;
  List<dynamic>? get allDropAddress => _allDropAddress;

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
    map['picked_time'] = _pickedTime;
    map['delivery_time'] = _deliveryTime;
    map['cancelled_time'] = _cancelledTime;
    map['start_trip'] = _startTrip;
    map['add_date'] = _addDate;
    map['contact_number'] = _contactNumber;
    map['lat'] = _lat;
    map['long'] = _long;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['gender'] = _gender;
    map['vehicle_name'] = _vehicleName;
    map['model'] = _model;
    map['rc_no'] = _rcNo;
    map['weight'] = _weight;
    map['weight_type'] = _weightType;
    map['category_name'] = _categoryName;
    map['vehicle_img'] = _vehicleImg;
    map['id_proof_img'] = _idProofImg;
    map['id_proof_back_img'] = _idProofBackImg;
    map['category_img'] = _categoryImg;
    map['driver_img'] = _driverImg;
    map['review'] = _review;
    map['rating'] = _rating;
    if (_allDropAddress != null) {
      map['all_drop_address'] = _allDropAddress?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}