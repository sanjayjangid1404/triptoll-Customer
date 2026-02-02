class MyOrdersModel {
  bool? status;
  List<Data>? orders;

  MyOrdersModel({this.status, this.orders});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      orders = <Data>[];
      json['data'].forEach((v) {
        orders!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    if (orders != null) {
      data['data'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic orderId;
  dynamic cusId;
  dynamic driverId;
  dynamic categoryId;
  dynamic rate;
  dynamic amount;
  dynamic totalAmount;
  dynamic bookingDate;
  dynamic orderStatus;
  dynamic acceptTime;
  dynamic closeTime;
  dynamic paymentType;
  dynamic paymentStatus;
  dynamic trnId;
  dynamic startTrip;
  dynamic addDate;
  Pickup? pickup;
  List<Dropoffs>? dropoffs;

  Data(
      {this.id,
        this.orderId,
        this.cusId,
        this.driverId,
        this.categoryId,
        this.rate,
        this.amount,
        this.totalAmount,
        this.bookingDate,
        this.orderStatus,
        this.acceptTime,
        this.closeTime,
        this.paymentType,
        this.paymentStatus,
        this.trnId,
        this.startTrip,
        this.addDate,
        this.pickup,
        this.dropoffs});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    cusId = json['cus_id'];
    driverId = json['driver_id'];
    categoryId = json['category_id'];
    rate = json['rate'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    bookingDate = json['booking_date'];
    orderStatus = json['order_status'];
    acceptTime = json['accept_time'];
    closeTime = json['close_time'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    trnId = json['trn_id'];
    startTrip = json['start_trip'];
    addDate = json['add_date'];
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
    data['id'] = id;
    data['order_id'] = orderId;
    data['cus_id'] = cusId;
    data['driver_id'] = driverId;
    data['category_id'] = categoryId;
    data['rate'] = rate;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['booking_date'] = bookingDate;
    data['order_status'] = orderStatus;
    data['accept_time'] = acceptTime;
    data['close_time'] = closeTime;
    data['payment_type'] = paymentType;
    data['payment_status'] = paymentStatus;
    data['trn_id'] = trnId;
    data['start_trip'] = startTrip;
    data['add_date'] = addDate;
    if (pickup != null) {
      data['pickup'] = pickup!.toJson();
    }
    if (dropoffs != null) {
      data['dropoffs'] = dropoffs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pickup {
  dynamic locationId;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic distanceToNext;
  dynamic expectedTimeToNext;
  dynamic completionTime;
  dynamic loadingDuration;
  dynamic loadingTime;
  dynamic loadingCharge;

  Pickup(
      {this.locationId,
        this.address,
        this.lat,
        this.lng,
        this.distanceToNext,
        this.expectedTimeToNext,
        this.completionTime,
        this.loadingDuration,
        this.loadingTime,
        this.loadingCharge});

  Pickup.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    distanceToNext = json['distance_to_next'];
    expectedTimeToNext = json['expected_time_to_next'];
    completionTime = json['completion_time'];
    loadingDuration = json['loading_duration'];
    loadingTime = json['loading_time'];
    loadingCharge = json['loading_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = locationId;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['distance_to_next'] = distanceToNext;
    data['expected_time_to_next'] = expectedTimeToNext;
    data['completion_time'] = completionTime;
    data['loading_duration'] = loadingDuration;
    data['loading_time'] = loadingTime;
    data['loading_charge'] = loadingCharge;
    return data;
  }
}

class Dropoffs {
  dynamic locationId;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic name;
  dynamic contactNumber;
  dynamic sequence;
  dynamic distanceToNext;
  dynamic expectedTimeToNext;
  dynamic completionTime;
  dynamic unloadingDuration;
  dynamic unloadingTime;
  dynamic unloadingCharge;

  Dropoffs(
      {this.locationId,
        this.address,
        this.lat,
        this.lng,
        this.name,
        this.contactNumber,
        this.sequence,
        this.distanceToNext,
        this.expectedTimeToNext,
        this.completionTime,
        this.unloadingDuration,
        this.unloadingTime,
        this.unloadingCharge});

  Dropoffs.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    name = json['name'];
    contactNumber = json['contact_number'];
    sequence = json['sequence'];
    distanceToNext = json['distance_to_next'];
    expectedTimeToNext = json['expected_time_to_next'];
    completionTime = json['completion_time'];
    unloadingDuration = json['unloading_duration'];
    unloadingTime = json['unloading_time'];
    unloadingCharge = json['unloading_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = locationId;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['name'] = name;
    data['contact_number'] = contactNumber;
    data['sequence'] = sequence;
    data['distance_to_next'] = distanceToNext;
    data['expected_time_to_next'] = expectedTimeToNext;
    data['completion_time'] = completionTime;
    data['unloading_duration'] = unloadingDuration;
    data['unloading_time'] = unloadingTime;
    data['unloading_charge'] = unloadingCharge;
    return data;
  }
}
