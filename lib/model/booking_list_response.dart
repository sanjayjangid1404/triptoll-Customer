/// message : "Running Orders"
/// status : true
/// orders : [{"id":"1499","order_id":"122833527249","cus_id":"803","driver_id":"338","category_id":"112","city_id":null,"rate":"39.00","amount":"669.00","total_amount":"669.40","booking_date":"2025-10-28 13:43:23","order_status":"delivered","accept_time":"2025-10-28 13:43:37","close_time":null,"payment_type":"Online","payment_status":"pending","trn_id":null,"pickup_lat":null,"pickup_long":null,"pickup_address":"","sender_name":null,"sender_contact_number":null,"drop_lat":null,"drop_long":null,"drop_address":"","distance":"10.18","expected_time":"25m","receiver_name":null,"receiver_contact_number":null,"reason":null,"additional_comment":null,"picked_time":null,"delivery_time":null,"cancelled_time":null,"payment_time":null,"current_lat":null,"current_lng":null,"total_distance_travelled":null,"start_trip":"no","loading_duration":null,"loading_time":null,"loading_charge":null,"unloading_duration":null,"unloading_time":null,"unloading_charge":null,"add_date":"2025-10-28 13:43:23","is_fake":"0","status":null,"assigned_driver_id":"338","weight":null,"vehicle_id":null,"model":"2023","vehicle_number":"hr11n6565","vehicle_type":"Diesel","first_name":"Mohan","last_name":"K","contact_number":"9266809133","fcm_token":"cV5jEgP1SpOmJ0yrdyO77C:APA91bFk-ejuF9KVi_3l_jpdop8IZ94u2-i-OqpHNv_3UeHcphylqCNbUkJJJBYl-D7utw9PH4iPKIjqSEanQl5obNIXwfAvT6hFBM3_WhfnW3My14obXqY","pickup":{"location_id":"1936","lat":"26.837063657425","lng":"75.833927504718","address":"538, Durgapura, Jaipur, India","name":"Himpreet Singh","contact_number":"8619394870","status":"loaded","loading_time":"2025-10-28 13:43:50","loading_duration":"3","loading_charge":"0.00"},"dropoffs":[{"location_id":"1937","lat":"26.894843665034","lng":"75.786504372954","address":"68, Malviya Nagar, Jaipur, India","name":"Himpreet Singh","contact_number":"8619394875","sequence":"2","status":"completed","unloading_time":"2025-10-28 13:47:26","unloading_duration":"1","unloading_charge":"0.00"}]}]

class BookingListResponse {
  BookingListResponse({
      dynamic message, 
      bool? status, 
      List<Orders>? orders,}){
    _message = message;
    _status = status;
    _orders = orders;
}

  BookingListResponse.fromJson(dynamic json) {
    _message = json['message'];
    _status = json['status'];
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders?.add(Orders.fromJson(v));
      });
    }
  }
  dynamic _message;
  bool? _status;
  List<Orders>? _orders;
BookingListResponse copyWith({  dynamic message,
  bool? status,
  List<Orders>? orders,
}) => BookingListResponse(  message: message ?? _message,
  status: status ?? _status,
  orders: orders ?? _orders,
);
  dynamic get message => _message;
  bool? get status => _status;
  List<Orders>? get orders => _orders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['status'] = _status;
    if (_orders != null) {
      map['orders'] = _orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1499"
/// order_id : "122833527249"
/// cus_id : "803"
/// driver_id : "338"
/// category_id : "112"
/// city_id : null
/// rate : "39.00"
/// amount : "669.00"
/// total_amount : "669.40"
/// booking_date : "2025-10-28 13:43:23"
/// order_status : "delivered"
/// accept_time : "2025-10-28 13:43:37"
/// close_time : null
/// payment_type : "Online"
/// payment_status : "pending"
/// trn_id : null
/// pickup_lat : null
/// pickup_long : null
/// pickup_address : ""
/// sender_name : null
/// sender_contact_number : null
/// drop_lat : null
/// drop_long : null
/// drop_address : ""
/// distance : "10.18"
/// expected_time : "25m"
/// receiver_name : null
/// receiver_contact_number : null
/// reason : null
/// additional_comment : null
/// picked_time : null
/// delivery_time : null
/// cancelled_time : null
/// payment_time : null
/// current_lat : null
/// current_lng : null
/// total_distance_travelled : null
/// start_trip : "no"
/// loading_duration : null
/// loading_time : null
/// loading_charge : null
/// unloading_duration : null
/// unloading_time : null
/// unloading_charge : null
/// add_date : "2025-10-28 13:43:23"
/// is_fake : "0"
/// status : null
/// assigned_driver_id : "338"
/// weight : null
/// vehicle_id : null
/// model : "2023"
/// vehicle_number : "hr11n6565"
/// vehicle_type : "Diesel"
/// first_name : "Mohan"
/// last_name : "K"
/// contact_number : "9266809133"
/// fcm_token : "cV5jEgP1SpOmJ0yrdyO77C:APA91bFk-ejuF9KVi_3l_jpdop8IZ94u2-i-OqpHNv_3UeHcphylqCNbUkJJJBYl-D7utw9PH4iPKIjqSEanQl5obNIXwfAvT6hFBM3_WhfnW3My14obXqY"
/// pickup : {"location_id":"1936","lat":"26.837063657425","lng":"75.833927504718","address":"538, Durgapura, Jaipur, India","name":"Himpreet Singh","contact_number":"8619394870","status":"loaded","loading_time":"2025-10-28 13:43:50","loading_duration":"3","loading_charge":"0.00"}
/// dropoffs : [{"location_id":"1937","lat":"26.894843665034","lng":"75.786504372954","address":"68, Malviya Nagar, Jaipur, India","name":"Himpreet Singh","contact_number":"8619394875","sequence":"2","status":"completed","unloading_time":"2025-10-28 13:47:26","unloading_duration":"1","unloading_charge":"0.00"}]

class Orders {
  Orders({
      dynamic id, 
      dynamic orderId, 
      dynamic cusId, 
      dynamic driverId, 
      dynamic categoryId, 
      dynamic cityId, 
      dynamic rate, 
      dynamic amount, 
      dynamic totalAmount, 
      dynamic bookingDate, 
      dynamic orderStatus, 
      dynamic acceptTime, 
      dynamic closeTime, 
      dynamic paymentType, 
      dynamic paymentStatus, 
      dynamic trnId, 
      dynamic pickupLat, 
      dynamic pickupLong, 
      dynamic pickupAddress, 
      dynamic vehicleCategory,
      dynamic senderName,
      dynamic senderContactNumber, 
      dynamic dropLat, 
      dynamic dropLong, 
      dynamic dropAddress, 
      dynamic distance, 
      dynamic expectedTime, 
      dynamic receiverName, 
      dynamic receiverContactNumber, 
      dynamic reason, 
      dynamic additionalComment, 
      dynamic pickedTime, 
      dynamic deliveryTime, 
      dynamic cancelledTime, 
      dynamic paymentTime, 
      dynamic currentLat, 
      dynamic currentLng, 
      dynamic totalDistanceTravelled, 
      dynamic startTrip, 
      dynamic loadingDuration, 
      dynamic loadingTime, 
      dynamic loadingCharge, 
      dynamic unloadingDuration, 
      dynamic unloadingTime, 
      dynamic unloadingCharge, 
      dynamic addDate, 
      dynamic isFake, 
      dynamic status, 
      dynamic assignedDriverId, 
      dynamic weight, 
      dynamic vehicleId, 
      dynamic model, 
      dynamic vehicleNumber, 
      dynamic vehicleType, 
      dynamic firstName, 
      dynamic lastName, 
      dynamic pickupOtp,
      dynamic contactNumber,
      dynamic fcmToken, 
      Pickup? pickup, 
      List<Dropoffs>? dropoffs,}){
    _id = id;
    _orderId = orderId;
    _cusId = cusId;
    _driverId = driverId;
    _categoryId = categoryId;
    _cityId = cityId;
    _rate = rate;
    _amount = amount;
    _totalAmount = totalAmount;
    _bookingDate = bookingDate;
    _orderStatus = orderStatus;
    _acceptTime = acceptTime;
    _closeTime = closeTime;
    _paymentType = paymentType;
    _paymentType = paymentType;
    _paymentStatus = paymentStatus;
    _trnId = trnId;
    _pickupLat = pickupLat;
    _pickupLong = pickupLong;
    _pickupAddress = pickupAddress;
    _vehicleCategory = vehicleCategory;
    _senderName = senderName;
    _senderContactNumber = senderContactNumber;
    _dropLat = dropLat;
    _dropLong = dropLong;
    _dropAddress = dropAddress;
    _distance = distance;
    _expectedTime = expectedTime;
    _receiverName = receiverName;
    _receiverContactNumber = receiverContactNumber;
    _reason = reason;
    _additionalComment = additionalComment;
    _pickedTime = pickedTime;
    _deliveryTime = deliveryTime;
    _cancelledTime = cancelledTime;
    _paymentTime = paymentTime;
    _currentLat = currentLat;
    _currentLng = currentLng;
    _totalDistanceTravelled = totalDistanceTravelled;
    _startTrip = startTrip;
    _loadingDuration = loadingDuration;
    _loadingTime = loadingTime;
    _loadingCharge = loadingCharge;
    _unloadingDuration = unloadingDuration;
    _unloadingTime = unloadingTime;
    _unloadingCharge = unloadingCharge;
    _addDate = addDate;
    _isFake = isFake;
    _status = status;
    _assignedDriverId = assignedDriverId;
    _weight = weight;
    _vehicleId = vehicleId;
    _model = model;
    _vehicleNumber = vehicleNumber;
    _vehicleType = vehicleType;
    _pickupOtp = pickupOtp;
    _firstName = firstName;
    _lastName = lastName;
    _contactNumber = contactNumber;
    _fcmToken = fcmToken;
    _pickup = pickup;
    _dropoffs = dropoffs;
}

  Orders.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _cusId = json['cus_id'];
    _driverId = json['driver_id'];
    _categoryId = json['category_id'];
    _cityId = json['city_id'];
    _rate = json['rate'];
    _amount = json['amount'];
    _totalAmount = json['total_amount'];
    _bookingDate = json['booking_date'];
    _orderStatus = json['order_status'];
    _acceptTime = json['accept_time'];
    _closeTime = json['close_time'];
    _paymentType = json['payment_type'];
    _paymentStatus = json['payment_status'];
    _trnId = json['trn_id'];
    _pickupLat = json['pickup_lat'];
    _pickupLong = json['pickup_long'];
    _pickupAddress = json['pickup_address'];
    _vehicleCategory = json['vehicle_category'];
    _senderName = json['sender_name'];
    _senderContactNumber = json['sender_contact_number'];
    _dropLat = json['drop_lat'];
    _dropLong = json['drop_long'];
    _dropAddress = json['drop_address'];
    _distance = json['distance'];
    _expectedTime = json['expected_time'];
    _receiverName = json['receiver_name'];
    _receiverContactNumber = json['receiver_contact_number'];
    _reason = json['reason'];
    _additionalComment = json['additional_comment'];
    _pickedTime = json['picked_time'];
    _deliveryTime = json['delivery_time'];
    _cancelledTime = json['cancelled_time'];
    _paymentTime = json['payment_time'];
    _currentLat = json['current_lat'];
    _currentLng = json['current_lng'];
    _totalDistanceTravelled = json['total_distance_travelled'];
    _startTrip = json['start_trip'];
    _loadingDuration = json['loading_duration'];
    _loadingTime = json['loading_time'];
    _loadingCharge = json['loading_charge'];
    _unloadingDuration = json['unloading_duration'];
    _unloadingTime = json['unloading_time'];
    _unloadingCharge = json['unloading_charge'];
    _addDate = json['add_date'];
    _isFake = json['is_fake'];
    _status = json['status'];
    _assignedDriverId = json['assigned_driver_id'];
    _weight = json['weight'];
    _vehicleId = json['vehicle_id'];
    _model = json['model'];
    _vehicleNumber = json['vehicle_number'];
    _vehicleType = json['vehicle_type'];
    _pickupOtp = json['pickup_otp'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _contactNumber = json['contact_number'];
    _fcmToken = json['fcm_token'];
    _pickup = json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null;
    if (json['dropoffs'] != null) {
      _dropoffs = [];
      json['dropoffs'].forEach((v) {
        _dropoffs?.add(Dropoffs.fromJson(v));
      });
    }
  }
  dynamic _id;
  dynamic _orderId;
  dynamic _cusId;
  dynamic _driverId;
  dynamic _categoryId;
  dynamic _cityId;
  dynamic _rate;
  dynamic _amount;
  dynamic _totalAmount;
  dynamic _bookingDate;
  dynamic _orderStatus;
  dynamic _acceptTime;
  dynamic _closeTime;
  dynamic _paymentType;
  dynamic _paymentStatus;
  dynamic _trnId;
  dynamic _pickupLat;
  dynamic _pickupLong;
  dynamic _pickupAddress;
  dynamic _vehicleCategory;
  dynamic _senderName;
  dynamic _senderContactNumber;
  dynamic _dropLat;
  dynamic _dropLong;
  dynamic _dropAddress;
  dynamic _distance;
  dynamic _expectedTime;
  dynamic _receiverName;
  dynamic _receiverContactNumber;
  dynamic _reason;
  dynamic _additionalComment;
  dynamic _pickedTime;
  dynamic _deliveryTime;
  dynamic _cancelledTime;
  dynamic _paymentTime;
  dynamic _currentLat;
  dynamic _currentLng;
  dynamic _totalDistanceTravelled;
  dynamic _startTrip;
  dynamic _loadingDuration;
  dynamic _loadingTime;
  dynamic _loadingCharge;
  dynamic _unloadingDuration;
  dynamic _unloadingTime;
  dynamic _unloadingCharge;
  dynamic _addDate;
  dynamic _isFake;
  dynamic _status;
  dynamic _assignedDriverId;
  dynamic _weight;
  dynamic _vehicleId;
  dynamic _model;
  dynamic _vehicleNumber;
  dynamic _vehicleType;
  dynamic _pickupOtp;
  dynamic _firstName;
  dynamic _lastName;
  dynamic _contactNumber;
  dynamic _fcmToken;
  Pickup? _pickup;
  List<Dropoffs>? _dropoffs;
Orders copyWith({  dynamic id,
  dynamic orderId,
  dynamic cusId,
  dynamic driverId,
  dynamic categoryId,
  dynamic cityId,
  dynamic rate,
  dynamic amount,
  dynamic totalAmount,
  dynamic bookingDate,
  dynamic orderStatus,
  dynamic acceptTime,
  dynamic closeTime,
  dynamic paymentType,
  dynamic paymentStatus,
  dynamic trnId,
  dynamic pickupLat,
  dynamic pickupLong,
  dynamic pickupAddress,
  dynamic vehicleCategory,
  dynamic senderName,
  dynamic senderContactNumber,
  dynamic dropLat,
  dynamic dropLong,
  dynamic dropAddress,
  dynamic distance,
  dynamic expectedTime,
  dynamic receiverName,
  dynamic receiverContactNumber,
  dynamic reason,
  dynamic additionalComment,
  dynamic pickedTime,
  dynamic deliveryTime,
  dynamic cancelledTime,
  dynamic paymentTime,
  dynamic currentLat,
  dynamic currentLng,
  dynamic totalDistanceTravelled,
  dynamic startTrip,
  dynamic loadingDuration,
  dynamic loadingTime,
  dynamic loadingCharge,
  dynamic unloadingDuration,
  dynamic unloadingTime,
  dynamic unloadingCharge,
  dynamic addDate,
  dynamic isFake,
  dynamic status,
  dynamic assignedDriverId,
  dynamic weight,
  dynamic vehicleId,
  dynamic model,
  dynamic vehicleNumber,
  dynamic vehicleType,
  dynamic pickupOtp,
  dynamic firstName,
  dynamic lastName,
  dynamic contactNumber,
  dynamic fcmToken,
  Pickup? pickup,
  List<Dropoffs>? dropoffs,
}) => Orders(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  cusId: cusId ?? _cusId,
  driverId: driverId ?? _driverId,
  categoryId: categoryId ?? _categoryId,
  cityId: cityId ?? _cityId,
  rate: rate ?? _rate,
  amount: amount ?? _amount,
  totalAmount: totalAmount ?? _totalAmount,
  bookingDate: bookingDate ?? _bookingDate,
  orderStatus: orderStatus ?? _orderStatus,
  acceptTime: acceptTime ?? _acceptTime,
  closeTime: closeTime ?? _closeTime,
  paymentType: paymentType ?? _paymentType,
  paymentStatus: paymentStatus ?? _paymentStatus,
  trnId: trnId ?? _trnId,
  pickupLat: pickupLat ?? _pickupLat,
  pickupLong: pickupLong ?? _pickupLong,
  pickupAddress: pickupAddress ?? _pickupAddress,
  vehicleCategory: vehicleCategory ?? _vehicleCategory,
  senderName: senderName ?? _senderName,
  senderContactNumber: senderContactNumber ?? _senderContactNumber,
  dropLat: dropLat ?? _dropLat,
  dropLong: dropLong ?? _dropLong,
  dropAddress: dropAddress ?? _dropAddress,
  distance: distance ?? _distance,
  expectedTime: expectedTime ?? _expectedTime,
  receiverName: receiverName ?? _receiverName,
  receiverContactNumber: receiverContactNumber ?? _receiverContactNumber,
  reason: reason ?? _reason,
  additionalComment: additionalComment ?? _additionalComment,
  pickedTime: pickedTime ?? _pickedTime,
  deliveryTime: deliveryTime ?? _deliveryTime,
  cancelledTime: cancelledTime ?? _cancelledTime,
  paymentTime: paymentTime ?? _paymentTime,
  currentLat: currentLat ?? _currentLat,
  currentLng: currentLng ?? _currentLng,
  totalDistanceTravelled: totalDistanceTravelled ?? _totalDistanceTravelled,
  startTrip: startTrip ?? _startTrip,
  loadingDuration: loadingDuration ?? _loadingDuration,
  loadingTime: loadingTime ?? _loadingTime,
  loadingCharge: loadingCharge ?? _loadingCharge,
  unloadingDuration: unloadingDuration ?? _unloadingDuration,
  unloadingTime: unloadingTime ?? _unloadingTime,
  unloadingCharge: unloadingCharge ?? _unloadingCharge,
  addDate: addDate ?? _addDate,
  isFake: isFake ?? _isFake,
  status: status ?? _status,
  assignedDriverId: assignedDriverId ?? _assignedDriverId,
  weight: weight ?? _weight,
  vehicleId: vehicleId ?? _vehicleId,
  model: model ?? _model,
  vehicleNumber: vehicleNumber ?? _vehicleNumber,
  vehicleType: vehicleType ?? _vehicleType,
  pickupOtp: pickupOtp ?? _pickupOtp,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  contactNumber: contactNumber ?? _contactNumber,
  fcmToken: fcmToken ?? _fcmToken,
  pickup: pickup ?? _pickup,
  dropoffs: dropoffs ?? _dropoffs,
);
  dynamic get id => _id;
  dynamic get orderId => _orderId;
  dynamic get cusId => _cusId;
  dynamic get driverId => _driverId;
  dynamic get categoryId => _categoryId;
  dynamic get cityId => _cityId;
  dynamic get rate => _rate;
  dynamic get amount => _amount;
  dynamic get totalAmount => _totalAmount;
  dynamic get bookingDate => _bookingDate;
  dynamic get orderStatus => _orderStatus;
  dynamic get acceptTime => _acceptTime;
  dynamic get closeTime => _closeTime;
  dynamic get paymentType => _paymentType;
  dynamic get paymentStatus => _paymentStatus;
  dynamic get trnId => _trnId;
  dynamic get pickupLat => _pickupLat;
  dynamic get pickupLong => _pickupLong;
  dynamic get pickupAddress => _pickupAddress;
  dynamic get vehicleCategory => _vehicleCategory;
  dynamic get senderName => _senderName;
  dynamic get senderContactNumber => _senderContactNumber;
  dynamic get dropLat => _dropLat;
  dynamic get dropLong => _dropLong;
  dynamic get dropAddress => _dropAddress;
  dynamic get distance => _distance;
  dynamic get expectedTime => _expectedTime;
  dynamic get receiverName => _receiverName;
  dynamic get receiverContactNumber => _receiverContactNumber;
  dynamic get reason => _reason;
  dynamic get additionalComment => _additionalComment;
  dynamic get pickedTime => _pickedTime;
  dynamic get deliveryTime => _deliveryTime;
  dynamic get cancelledTime => _cancelledTime;
  dynamic get paymentTime => _paymentTime;
  dynamic get currentLat => _currentLat;
  dynamic get currentLng => _currentLng;
  dynamic get totalDistanceTravelled => _totalDistanceTravelled;
  dynamic get startTrip => _startTrip;
  dynamic get loadingDuration => _loadingDuration;
  dynamic get loadingTime => _loadingTime;
  dynamic get loadingCharge => _loadingCharge;
  dynamic get unloadingDuration => _unloadingDuration;
  dynamic get unloadingTime => _unloadingTime;
  dynamic get unloadingCharge => _unloadingCharge;
  dynamic get addDate => _addDate;
  dynamic get isFake => _isFake;
  dynamic get status => _status;
  dynamic get assignedDriverId => _assignedDriverId;
  dynamic get weight => _weight;
  dynamic get vehicleId => _vehicleId;
  dynamic get model => _model;
  dynamic get vehicleNumber => _vehicleNumber;
  dynamic get vehicleType => _vehicleType;
  dynamic get pickupOtp => _pickupOtp;
  dynamic get firstName => _firstName;
  dynamic get lastName => _lastName;
  dynamic get contactNumber => _contactNumber;
  dynamic get fcmToken => _fcmToken;
  Pickup? get pickup => _pickup;
  List<Dropoffs>? get dropoffs => _dropoffs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['cus_id'] = _cusId;
    map['driver_id'] = _driverId;
    map['category_id'] = _categoryId;
    map['city_id'] = _cityId;
    map['rate'] = _rate;
    map['amount'] = _amount;
    map['total_amount'] = _totalAmount;
    map['booking_date'] = _bookingDate;
    map['order_status'] = _orderStatus;
    map['accept_time'] = _acceptTime;
    map['close_time'] = _closeTime;
    map['payment_type'] = _paymentType;
    map['payment_status'] = _paymentStatus;
    map['trn_id'] = _trnId;
    map['pickup_lat'] = _pickupLat;
    map['pickup_long'] = _pickupLong;
    map['pickup_address'] = _pickupAddress;
    map['sender_name'] = _senderName;
    map['sender_contact_number'] = _senderContactNumber;
    map['drop_lat'] = _dropLat;
    map['drop_long'] = _dropLong;
    map['drop_address'] = _dropAddress;
    map['distance'] = _distance;
    map['expected_time'] = _expectedTime;
    map['receiver_name'] = _receiverName;
    map['receiver_contact_number'] = _receiverContactNumber;
    map['reason'] = _reason;
    map['additional_comment'] = _additionalComment;
    map['picked_time'] = _pickedTime;
    map['delivery_time'] = _deliveryTime;
    map['cancelled_time'] = _cancelledTime;
    map['payment_time'] = _paymentTime;
    map['current_lat'] = _currentLat;
    map['current_lng'] = _currentLng;
    map['total_distance_travelled'] = _totalDistanceTravelled;
    map['start_trip'] = _startTrip;
    map['loading_duration'] = _loadingDuration;
    map['loading_time'] = _loadingTime;
    map['loading_charge'] = _loadingCharge;
    map['unloading_duration'] = _unloadingDuration;
    map['unloading_time'] = _unloadingTime;
    map['unloading_charge'] = _unloadingCharge;
    map['add_date'] = _addDate;
    map['is_fake'] = _isFake;
    map['status'] = _status;
    map['assigned_driver_id'] = _assignedDriverId;
    map['weight'] = _weight;
    map['vehicle_id'] = _vehicleId;
    map['model'] = _model;
    map['vehicle_number'] = _vehicleNumber;
    map['vehicle_type'] = _vehicleType;
    map['pickup_otp'] = _pickupOtp;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['contact_number'] = _contactNumber;
    map['fcm_token'] = _fcmToken;
    if (_pickup != null) {
      map['pickup'] = _pickup?.toJson();
    }
    if (_dropoffs != null) {
      map['dropoffs'] = _dropoffs?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// location_id : "1937"
/// lat : "26.894843665034"
/// lng : "75.786504372954"
/// address : "68, Malviya Nagar, Jaipur, India"
/// name : "Himpreet Singh"
/// contact_number : "8619394875"
/// sequence : "2"
/// status : "completed"
/// unloading_time : "2025-10-28 13:47:26"
/// unloading_duration : "1"
/// unloading_charge : "0.00"

class Dropoffs {
  Dropoffs({
      dynamic locationId, 
      dynamic lat, 
      dynamic lng, 
      dynamic address, 
      dynamic name, 
      dynamic contactNumber, 
      dynamic sequence, 
      dynamic status, 
      dynamic unloadingTime, 
      dynamic unloadingDuration, 
      dynamic unloadingCharge,}){
    _locationId = locationId;
    _lat = lat;
    _lng = lng;
    _address = address;
    _name = name;
    _contactNumber = contactNumber;
    _sequence = sequence;
    _status = status;
    _unloadingTime = unloadingTime;
    _unloadingDuration = unloadingDuration;
    _unloadingCharge = unloadingCharge;
}

  Dropoffs.fromJson(dynamic json) {
    _locationId = json['location_id'];
    _lat = json['lat'];
    _lng = json['lng'];
    _address = json['address'];
    _name = json['name'];
    _contactNumber = json['contact_number'];
    _sequence = json['sequence'];
    _status = json['status'];
    _unloadingTime = json['unloading_time'];
    _unloadingDuration = json['unloading_duration'];
    _unloadingCharge = json['unloading_charge'];
  }
  dynamic _locationId;
  dynamic _lat;
  dynamic _lng;
  dynamic _address;
  dynamic _name;
  dynamic _contactNumber;
  dynamic _sequence;
  dynamic _status;
  dynamic _unloadingTime;
  dynamic _unloadingDuration;
  dynamic _unloadingCharge;
Dropoffs copyWith({  dynamic locationId,
  dynamic lat,
  dynamic lng,
  dynamic address,
  dynamic name,
  dynamic contactNumber,
  dynamic sequence,
  dynamic status,
  dynamic unloadingTime,
  dynamic unloadingDuration,
  dynamic unloadingCharge,
}) => Dropoffs(  locationId: locationId ?? _locationId,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  address: address ?? _address,
  name: name ?? _name,
  contactNumber: contactNumber ?? _contactNumber,
  sequence: sequence ?? _sequence,
  status: status ?? _status,
  unloadingTime: unloadingTime ?? _unloadingTime,
  unloadingDuration: unloadingDuration ?? _unloadingDuration,
  unloadingCharge: unloadingCharge ?? _unloadingCharge,
);
  dynamic get locationId => _locationId;
  dynamic get lat => _lat;
  dynamic get lng => _lng;
  dynamic get address => _address;
  dynamic get name => _name;
  dynamic get contactNumber => _contactNumber;
  dynamic get sequence => _sequence;
  dynamic get status => _status;
  dynamic get unloadingTime => _unloadingTime;
  dynamic get unloadingDuration => _unloadingDuration;
  dynamic get unloadingCharge => _unloadingCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_id'] = _locationId;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['address'] = _address;
    map['name'] = _name;
    map['contact_number'] = _contactNumber;
    map['sequence'] = _sequence;
    map['status'] = _status;
    map['unloading_time'] = _unloadingTime;
    map['unloading_duration'] = _unloadingDuration;
    map['unloading_charge'] = _unloadingCharge;
    return map;
  }

}

/// location_id : "1936"
/// lat : "26.837063657425"
/// lng : "75.833927504718"
/// address : "538, Durgapura, Jaipur, India"
/// name : "Himpreet Singh"
/// contact_number : "8619394870"
/// status : "loaded"
/// loading_time : "2025-10-28 13:43:50"
/// loading_duration : "3"
/// loading_charge : "0.00"

class Pickup {
  Pickup({
      dynamic locationId, 
      dynamic lat, 
      dynamic lng, 
      dynamic address, 
      dynamic name, 
      dynamic contactNumber, 
      dynamic status, 
      dynamic loadingTime, 
      dynamic loadingDuration, 
      dynamic loadingCharge,}){
    _locationId = locationId;
    _lat = lat;
    _lng = lng;
    _address = address;
    _name = name;
    _contactNumber = contactNumber;
    _status = status;
    _loadingTime = loadingTime;
    _loadingDuration = loadingDuration;
    _loadingCharge = loadingCharge;
}

  Pickup.fromJson(dynamic json) {
    _locationId = json['location_id'];
    _lat = json['lat'];
    _lng = json['lng'];
    _address = json['address'];
    _name = json['name'];
    _contactNumber = json['contact_number'];
    _status = json['status'];
    _loadingTime = json['loading_time'];
    _loadingDuration = json['loading_duration'];
    _loadingCharge = json['loading_charge'];
  }
  dynamic _locationId;
  dynamic _lat;
  dynamic _lng;
  dynamic _address;
  dynamic _name;
  dynamic _contactNumber;
  dynamic _status;
  dynamic _loadingTime;
  dynamic _loadingDuration;
  dynamic _loadingCharge;
Pickup copyWith({  dynamic locationId,
  dynamic lat,
  dynamic lng,
  dynamic address,
  dynamic name,
  dynamic contactNumber,
  dynamic status,
  dynamic loadingTime,
  dynamic loadingDuration,
  dynamic loadingCharge,
}) => Pickup(  locationId: locationId ?? _locationId,
  lat: lat ?? _lat,
  lng: lng ?? _lng,
  address: address ?? _address,
  name: name ?? _name,
  contactNumber: contactNumber ?? _contactNumber,
  status: status ?? _status,
  loadingTime: loadingTime ?? _loadingTime,
  loadingDuration: loadingDuration ?? _loadingDuration,
  loadingCharge: loadingCharge ?? _loadingCharge,
);
  dynamic get locationId => _locationId;
  dynamic get lat => _lat;
  dynamic get lng => _lng;
  dynamic get address => _address;
  dynamic get name => _name;
  dynamic get contactNumber => _contactNumber;
  dynamic get status => _status;
  dynamic get loadingTime => _loadingTime;
  dynamic get loadingDuration => _loadingDuration;
  dynamic get loadingCharge => _loadingCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_id'] = _locationId;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['address'] = _address;
    map['name'] = _name;
    map['contact_number'] = _contactNumber;
    map['status'] = _status;
    map['loading_time'] = _loadingTime;
    map['loading_duration'] = _loadingDuration;
    map['loading_charge'] = _loadingCharge;
    return map;
  }

}