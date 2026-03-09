class GetLastFiveDropLocationsModel {
  bool? status;
  dynamic message;
  List<Data>? data;

  GetLastFiveDropLocationsModel({this.status, this.message, this.data});

  GetLastFiveDropLocationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic bookingId;
  dynamic address;
  dynamic receiverName;
  dynamic receiverContactNumber;
  dynamic lat;
  dynamic lng;
  dynamic completionTime;

  Data(
      {this.id,
        this.bookingId,
        this.address,
        this.receiverName,
        this.receiverContactNumber,
        this.lat,
        this.lng,
        this.completionTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    address = json['address'];
    receiverName = json['receiver_name'];
    receiverContactNumber = json['receiver_contact_number'];
    lat = json['lat'];
    lng = json['lng'];
    completionTime = json['completion_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['address'] = this.address;
    data['receiver_name'] = this.receiverName;
    data['receiver_contact_number'] = this.receiverContactNumber;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['completion_time'] = this.completionTime;
    return data;
  }
}
