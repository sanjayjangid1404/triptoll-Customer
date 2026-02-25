class GetReorderDataModel {
  dynamic id;
  dynamic orderId;
  dynamic cusId;
  dynamic driverId;
  dynamic categoryId;
  dynamic cityId;
  dynamic rate;
  dynamic amount;
  dynamic totalAmount;
  dynamic bookingDate;
  dynamic orderStatus;
  dynamic scheduleDate;
  dynamic scheduleTime;
  dynamic acceptTime;
  dynamic closeTime;
  dynamic paymentType;
  dynamic paymentStatus;
  dynamic trnId;
  dynamic pickupLat;
  dynamic pickupLong;
  dynamic pickupAddress;
  dynamic senderName;
  dynamic senderContactNumber;
  dynamic dropLat;
  dynamic dropLong;
  dynamic dropAddress;
  dynamic distance;
  dynamic expectedTime;
  dynamic receiverName;
  dynamic receiverContactNumber;
  dynamic reason;
  dynamic additionalComment;
  dynamic pickedTime;
  dynamic deliveryTime;
  dynamic cancelledTime;
  dynamic paymentTime;
  dynamic currentLat;
  dynamic currentLng;
  dynamic totalDistanceTravelled;
  dynamic startTrip;
  dynamic loadingDuration;
  dynamic loadingTime;
  dynamic loadingCharge;
  dynamic unloadingDuration;
  dynamic unloadingTime;
  dynamic unloadingCharge;
  dynamic addDate;
  bool? isFake;
  dynamic isSchedule;
  dynamic status;
  dynamic customerFirstName;
  dynamic customerLastName;
  dynamic customerContactNumber;
  dynamic driverFirstName;
  dynamic driverLastName;
  dynamic driverContactNumber;
  dynamic name;
  dynamic weight;
  dynamic weightType;
  dynamic model;
  dynamic vehicleNumber;
  dynamic vehicleType;
  Pickup? pickup;
  List<Dropoffs>? dropoffs;

  GetReorderDataModel(
      {this.id,
        this.orderId,
        this.cusId,
        this.driverId,
        this.categoryId,
        this.cityId,
        this.rate,
        this.amount,
        this.totalAmount,
        this.bookingDate,
        this.orderStatus,
        this.scheduleDate,
        this.scheduleTime,
        this.acceptTime,
        this.closeTime,
        this.paymentType,
        this.paymentStatus,
        this.trnId,
        this.pickupLat,
        this.pickupLong,
        this.pickupAddress,
        this.senderName,
        this.senderContactNumber,
        this.dropLat,
        this.dropLong,
        this.dropAddress,
        this.distance,
        this.expectedTime,
        this.receiverName,
        this.receiverContactNumber,
        this.reason,
        this.additionalComment,
        this.pickedTime,
        this.deliveryTime,
        this.cancelledTime,
        this.paymentTime,
        this.currentLat,
        this.currentLng,
        this.totalDistanceTravelled,
        this.startTrip,
        this.loadingDuration,
        this.loadingTime,
        this.loadingCharge,
        this.unloadingDuration,
        this.unloadingTime,
        this.unloadingCharge,
        this.addDate,
        this.isFake,
        this.isSchedule,
        this.status,
        this.customerFirstName,
        this.customerLastName,
        this.customerContactNumber,
        this.driverFirstName,
        this.driverLastName,
        this.driverContactNumber,
        this.name,
        this.weight,
        this.weightType,
        this.model,
        this.vehicleNumber,
        this.vehicleType,
        this.pickup,
        this.dropoffs});

  GetReorderDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    cusId = json['cus_id'];
    driverId = json['driver_id'];
    categoryId = json['category_id'];
    cityId = json['city_id'];
    rate = json['rate'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    bookingDate = json['booking_date'];
    orderStatus = json['order_status'];
    scheduleDate = json['schedule_date'];
    scheduleTime = json['schedule_time'];
    acceptTime = json['accept_time'];
    closeTime = json['close_time'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    trnId = json['trn_id'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    pickupAddress = json['pickup_address'];
    senderName = json['sender_name'];
    senderContactNumber = json['sender_contact_number'];
    dropLat = json['drop_lat'];
    dropLong = json['drop_long'];
    dropAddress = json['drop_address'];
    distance = json['distance'];
    expectedTime = json['expected_time'];
    receiverName = json['receiver_name'];
    receiverContactNumber = json['receiver_contact_number'];
    reason = json['reason'];
    additionalComment = json['additional_comment'];
    pickedTime = json['picked_time'];
    deliveryTime = json['delivery_time'];
    cancelledTime = json['cancelled_time'];
    paymentTime = json['payment_time'];
    currentLat = json['current_lat'];
    currentLng = json['current_lng'];
    totalDistanceTravelled = json['total_distance_travelled'];
    startTrip = json['start_trip'];
    loadingDuration = json['loading_duration'];
    loadingTime = json['loading_time'];
    loadingCharge = json['loading_charge'];
    unloadingDuration = json['unloading_duration'];
    unloadingTime = json['unloading_time'];
    unloadingCharge = json['unloading_charge'];
    addDate = json['add_date'];
    isFake = json['is_fake'];
    isSchedule = json['is_schedule'];
    status = json['status'];
    customerFirstName = json['customer_first_name'];
    customerLastName = json['customer_last_name'];
    customerContactNumber = json['customer_contact_number'];
    driverFirstName = json['driver_first_name'];
    driverLastName = json['driver_last_name'];
    driverContactNumber = json['driver_contact_number'];
    name = json['name'];
    weight = json['weight'];
    weightType = json['weight_type'];
    model = json['model'];
    vehicleNumber = json['vehicle_number'];
    vehicleType = json['vehicle_type'];
    pickup =
    json['pickup'] != null ? new Pickup.fromJson(json['pickup']) : null;
    if (json['dropoffs'] != null) {
      dropoffs = <Dropoffs>[];
      json['dropoffs'].forEach((v) {
        dropoffs!.add(new Dropoffs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['cus_id'] = this.cusId;
    data['driver_id'] = this.driverId;
    data['category_id'] = this.categoryId;
    data['city_id'] = this.cityId;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['total_amount'] = this.totalAmount;
    data['booking_date'] = this.bookingDate;
    data['order_status'] = this.orderStatus;
    data['schedule_date'] = this.scheduleDate;
    data['schedule_time'] = this.scheduleTime;
    data['accept_time'] = this.acceptTime;
    data['close_time'] = this.closeTime;
    data['payment_type'] = this.paymentType;
    data['payment_status'] = this.paymentStatus;
    data['trn_id'] = this.trnId;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['pickup_address'] = this.pickupAddress;
    data['sender_name'] = this.senderName;
    data['sender_contact_number'] = this.senderContactNumber;
    data['drop_lat'] = this.dropLat;
    data['drop_long'] = this.dropLong;
    data['drop_address'] = this.dropAddress;
    data['distance'] = this.distance;
    data['expected_time'] = this.expectedTime;
    data['receiver_name'] = this.receiverName;
    data['receiver_contact_number'] = this.receiverContactNumber;
    data['reason'] = this.reason;
    data['additional_comment'] = this.additionalComment;
    data['picked_time'] = this.pickedTime;
    data['delivery_time'] = this.deliveryTime;
    data['cancelled_time'] = this.cancelledTime;
    data['payment_time'] = this.paymentTime;
    data['current_lat'] = this.currentLat;
    data['current_lng'] = this.currentLng;
    data['total_distance_travelled'] = this.totalDistanceTravelled;
    data['start_trip'] = this.startTrip;
    data['loading_duration'] = this.loadingDuration;
    data['loading_time'] = this.loadingTime;
    data['loading_charge'] = this.loadingCharge;
    data['unloading_duration'] = this.unloadingDuration;
    data['unloading_time'] = this.unloadingTime;
    data['unloading_charge'] = this.unloadingCharge;
    data['add_date'] = this.addDate;
    data['is_fake'] = this.isFake;
    data['is_schedule'] = this.isSchedule;
    data['status'] = this.status;
    data['customer_first_name'] = this.customerFirstName;
    data['customer_last_name'] = this.customerLastName;
    data['customer_contact_number'] = this.customerContactNumber;
    data['driver_first_name'] = this.driverFirstName;
    data['driver_last_name'] = this.driverLastName;
    data['driver_contact_number'] = this.driverContactNumber;
    data['name'] = this.name;
    data['weight'] = this.weight;
    data['weight_type'] = this.weightType;
    data['model'] = this.model;
    data['vehicle_number'] = this.vehicleNumber;
    data['vehicle_type'] = this.vehicleType;
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.dropoffs != null) {
      data['dropoffs'] = this.dropoffs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pickup {
  dynamic locationId;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic name;
  dynamic contactNumber;
  dynamic status;
  dynamic loadingTime;
  dynamic loadingDuration;
  dynamic loadingCharge;

  Pickup(
      {this.locationId,
        this.lat,
        this.lng,
        this.address,
        this.name,
        this.contactNumber,
        this.status,
        this.loadingTime,
        this.loadingDuration,
        this.loadingCharge});

  Pickup.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    name = json['name'];
    contactNumber = json['contact_number'];
    status = json['status'];
    loadingTime = json['loading_time'];
    loadingDuration = json['loading_duration'];
    loadingCharge = json['loading_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['status'] = this.status;
    data['loading_time'] = this.loadingTime;
    data['loading_duration'] = this.loadingDuration;
    data['loading_charge'] = this.loadingCharge;
    return data;
  }
}

class Dropoffs {
  dynamic locationId;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic name;
  dynamic contactNumber;
  dynamic sequence;
  dynamic status;
  dynamic unloadingTime;
  dynamic unloadingDuration;
  dynamic unloadingCharge;

  Dropoffs(
      {this.locationId,
        this.lat,
        this.lng,
        this.address,
        this.name,
        this.contactNumber,
        this.sequence,
        this.status,
        this.unloadingTime,
        this.unloadingDuration,
        this.unloadingCharge});

  Dropoffs.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    lat = json['lat'];
    lng = json['lng'];
    address = json['address'];
    name = json['name'];
    contactNumber = json['contact_number'];
    sequence = json['sequence'];
    status = json['status'];
    unloadingTime = json['unloading_time'];
    unloadingDuration = json['unloading_duration'];
    unloadingCharge = json['unloading_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['address'] = this.address;
    data['name'] = this.name;
    data['contact_number'] = this.contactNumber;
    data['sequence'] = this.sequence;
    data['status'] = this.status;
    data['unloading_time'] = this.unloadingTime;
    data['unloading_duration'] = this.unloadingDuration;
    data['unloading_charge'] = this.unloadingCharge;
    return data;
  }
}
