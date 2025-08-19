/// status : true
/// driver_details : {"id":"338","uniq_id":"BkEWc","owner_id":null,"category_id":"123","weight":"4","vehicle_id":"323","referral_code":"msid9","executive_code":null,"referral_price":null,"username":"","password":"4297f44b13955235245b2497399d7a93","model":"2023","rc_no":"gagahash","vehicle_number":"hr11n6565","vehicle_type":"Diesel","first_name":"Mohan","last_name":"K","email":"msduhan111@gmail.com","countryCode":null,"contact_number":"9266809133","gender":"male","address":"","lat":"26.8370575","long":"75.8339151","description":"","city_id":"61","bank_name":"sbi","account_no":"121345494","ifsc_code":"fafagag","upi_id":"8319365289@YBL","trn_id":null,"commission":"10","status":"1","wallet_amount":"-383","registration_fees":"21","category_fees":"21","payment_status":"paid","adhar_no":"1234567879","pan_no":"svhahaaha","license_no":"gshagsga","insurance":"5453434","kyc":"complete","running_order":"yes","add_date":"2024-10-11 08:19:25","update_date":"2025-07-30 12:43:41","login_status":"online","online_time":"2025-08-06 04:32:00","login_hours":"487356","last_login_on":"2025-08-06 04:32:00","read_status":"read","user_status":"login","weight_value":"500","weight_type":"kgs","category_name":"EV / 3 Wheeler"}

class BookingdriverResponse {
  BookingdriverResponse({
      bool? status, 
      DriverDetails? driverDetails,}){
    _status = status;
    _driverDetails = driverDetails;
}

  BookingdriverResponse.fromJson(dynamic json) {
    _status = json['status'];
    _driverDetails = json['driver_details'] != null ? DriverDetails.fromJson(json['driver_details']) : null;
  }
  bool? _status;
  DriverDetails? _driverDetails;
BookingdriverResponse copyWith({  bool? status,
  DriverDetails? driverDetails,
}) => BookingdriverResponse(  status: status ?? _status,
  driverDetails: driverDetails ?? _driverDetails,
);
  bool? get status => _status;
  DriverDetails? get driverDetails => _driverDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_driverDetails != null) {
      map['driver_details'] = _driverDetails?.toJson();
    }
    return map;
  }

}

/// id : "338"
/// uniq_id : "BkEWc"
/// owner_id : null
/// category_id : "123"
/// weight : "4"
/// vehicle_id : "323"
/// referral_code : "msid9"
/// executive_code : null
/// referral_price : null
/// username : ""
/// password : "4297f44b13955235245b2497399d7a93"
/// model : "2023"
/// rc_no : "gagahash"
/// vehicle_number : "hr11n6565"
/// vehicle_type : "Diesel"
/// first_name : "Mohan"
/// last_name : "K"
/// email : "msduhan111@gmail.com"
/// countryCode : null
/// contact_number : "9266809133"
/// gender : "male"
/// address : ""
/// lat : "26.8370575"
/// long : "75.8339151"
/// description : ""
/// city_id : "61"
/// bank_name : "sbi"
/// account_no : "121345494"
/// ifsc_code : "fafagag"
/// upi_id : "8319365289@YBL"
/// trn_id : null
/// commission : "10"
/// status : "1"
/// wallet_amount : "-383"
/// registration_fees : "21"
/// category_fees : "21"
/// payment_status : "paid"
/// adhar_no : "1234567879"
/// pan_no : "svhahaaha"
/// license_no : "gshagsga"
/// insurance : "5453434"
/// kyc : "complete"
/// running_order : "yes"
/// add_date : "2024-10-11 08:19:25"
/// update_date : "2025-07-30 12:43:41"
/// login_status : "online"
/// online_time : "2025-08-06 04:32:00"
/// login_hours : "487356"
/// last_login_on : "2025-08-06 04:32:00"
/// read_status : "read"
/// user_status : "login"
/// weight_value : "500"
/// weight_type : "kgs"
/// category_name : "EV / 3 Wheeler"

class DriverDetails {
  DriverDetails({
      String? id, 
      String? uniqId, 
      dynamic ownerId, 
      String? categoryId, 
      String? weight, 
      String? vehicleId, 
      String? referralCode, 
      dynamic executiveCode, 
      dynamic referralPrice, 
      String? username, 
      String? password, 
      String? model, 
      String? rcNo, 
      String? vehicleNumber, 
      String? vehicleType, 
      String? firstName, 
      String? lastName, 
      String? email, 
      dynamic countryCode, 
      String? contactNumber, 
      String? gender, 
      String? address, 
      String? lat, 
      String? long, 
      String? description, 
      String? cityId, 
      String? bankName, 
      String? accountNo, 
      String? ifscCode, 
      String? upiId, 
      dynamic trnId, 
      String? commission, 
      String? status, 
      String? walletAmount, 
      String? registrationFees, 
      String? categoryFees, 
      String? paymentStatus, 
      String? adharNo, 
      String? panNo, 
      String? licenseNo, 
      String? insurance, 
      String? kyc, 
      String? runningOrder, 
      String? addDate, 
      String? updateDate, 
      String? loginStatus, 
      String? onlineTime, 
      String? loginHours, 
      String? lastLoginOn, 
      String? readStatus, 
      String? userStatus, 
      String? weightValue, 
      String? weightType, 
      String? categoryName,}){
    _id = id;
    _uniqId = uniqId;
    _ownerId = ownerId;
    _categoryId = categoryId;
    _weight = weight;
    _vehicleId = vehicleId;
    _referralCode = referralCode;
    _executiveCode = executiveCode;
    _referralPrice = referralPrice;
    _username = username;
    _password = password;
    _model = model;
    _rcNo = rcNo;
    _vehicleNumber = vehicleNumber;
    _vehicleType = vehicleType;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _countryCode = countryCode;
    _contactNumber = contactNumber;
    _gender = gender;
    _address = address;
    _lat = lat;
    _long = long;
    _description = description;
    _cityId = cityId;
    _bankName = bankName;
    _accountNo = accountNo;
    _ifscCode = ifscCode;
    _upiId = upiId;
    _trnId = trnId;
    _commission = commission;
    _status = status;
    _walletAmount = walletAmount;
    _registrationFees = registrationFees;
    _categoryFees = categoryFees;
    _paymentStatus = paymentStatus;
    _adharNo = adharNo;
    _panNo = panNo;
    _licenseNo = licenseNo;
    _insurance = insurance;
    _kyc = kyc;
    _runningOrder = runningOrder;
    _addDate = addDate;
    _updateDate = updateDate;
    _loginStatus = loginStatus;
    _onlineTime = onlineTime;
    _loginHours = loginHours;
    _lastLoginOn = lastLoginOn;
    _readStatus = readStatus;
    _userStatus = userStatus;
    _weightValue = weightValue;
    _weightType = weightType;
    _categoryName = categoryName;
}

  DriverDetails.fromJson(dynamic json) {
    _id = json['id'];
    _uniqId = json['uniq_id'];
    _ownerId = json['owner_id'];
    _categoryId = json['category_id'];
    _weight = json['weight'];
    _vehicleId = json['vehicle_id'];
    _referralCode = json['referral_code'];
    _executiveCode = json['executive_code'];
    _referralPrice = json['referral_price'];
    _username = json['username'];
    _password = json['password'];
    _model = json['model'];
    _rcNo = json['rc_no'];
    _vehicleNumber = json['vehicle_number'];
    _vehicleType = json['vehicle_type'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _countryCode = json['countryCode'];
    _contactNumber = json['contact_number'];
    _gender = json['gender'];
    _address = json['address'];
    _lat = json['lat'];
    _long = json['long'];
    _description = json['description'];
    _cityId = json['city_id'];
    _bankName = json['bank_name'];
    _accountNo = json['account_no'];
    _ifscCode = json['ifsc_code'];
    _upiId = json['upi_id'];
    _trnId = json['trn_id'];
    _commission = json['commission'];
    _status = json['status'];
    _walletAmount = json['wallet_amount'];
    _registrationFees = json['registration_fees'];
    _categoryFees = json['category_fees'];
    _paymentStatus = json['payment_status'];
    _adharNo = json['adhar_no'];
    _panNo = json['pan_no'];
    _licenseNo = json['license_no'];
    _insurance = json['insurance'];
    _kyc = json['kyc'];
    _runningOrder = json['running_order'];
    _addDate = json['add_date'];
    _updateDate = json['update_date'];
    _loginStatus = json['login_status'];
    _onlineTime = json['online_time'];
    _loginHours = json['login_hours'];
    _lastLoginOn = json['last_login_on'];
    _readStatus = json['read_status'];
    _userStatus = json['user_status'];
    _weightValue = json['weight_value'];
    _weightType = json['weight_type'];
    _categoryName = json['category_name'];
  }
  String? _id;
  String? _uniqId;
  dynamic _ownerId;
  String? _categoryId;
  String? _weight;
  String? _vehicleId;
  String? _referralCode;
  dynamic _executiveCode;
  dynamic _referralPrice;
  String? _username;
  String? _password;
  String? _model;
  String? _rcNo;
  String? _vehicleNumber;
  String? _vehicleType;
  String? _firstName;
  String? _lastName;
  String? _email;
  dynamic _countryCode;
  String? _contactNumber;
  String? _gender;
  String? _address;
  String? _lat;
  String? _long;
  String? _description;
  String? _cityId;
  String? _bankName;
  String? _accountNo;
  String? _ifscCode;
  String? _upiId;
  dynamic _trnId;
  String? _commission;
  String? _status;
  String? _walletAmount;
  String? _registrationFees;
  String? _categoryFees;
  String? _paymentStatus;
  String? _adharNo;
  String? _panNo;
  String? _licenseNo;
  String? _insurance;
  String? _kyc;
  String? _runningOrder;
  String? _addDate;
  String? _updateDate;
  String? _loginStatus;
  String? _onlineTime;
  String? _loginHours;
  String? _lastLoginOn;
  String? _readStatus;
  String? _userStatus;
  String? _weightValue;
  String? _weightType;
  String? _categoryName;
DriverDetails copyWith({  String? id,
  String? uniqId,
  dynamic ownerId,
  String? categoryId,
  String? weight,
  String? vehicleId,
  String? referralCode,
  dynamic executiveCode,
  dynamic referralPrice,
  String? username,
  String? password,
  String? model,
  String? rcNo,
  String? vehicleNumber,
  String? vehicleType,
  String? firstName,
  String? lastName,
  String? email,
  dynamic countryCode,
  String? contactNumber,
  String? gender,
  String? address,
  String? lat,
  String? long,
  String? description,
  String? cityId,
  String? bankName,
  String? accountNo,
  String? ifscCode,
  String? upiId,
  dynamic trnId,
  String? commission,
  String? status,
  String? walletAmount,
  String? registrationFees,
  String? categoryFees,
  String? paymentStatus,
  String? adharNo,
  String? panNo,
  String? licenseNo,
  String? insurance,
  String? kyc,
  String? runningOrder,
  String? addDate,
  String? updateDate,
  String? loginStatus,
  String? onlineTime,
  String? loginHours,
  String? lastLoginOn,
  String? readStatus,
  String? userStatus,
  String? weightValue,
  String? weightType,
  String? categoryName,
}) => DriverDetails(  id: id ?? _id,
  uniqId: uniqId ?? _uniqId,
  ownerId: ownerId ?? _ownerId,
  categoryId: categoryId ?? _categoryId,
  weight: weight ?? _weight,
  vehicleId: vehicleId ?? _vehicleId,
  referralCode: referralCode ?? _referralCode,
  executiveCode: executiveCode ?? _executiveCode,
  referralPrice: referralPrice ?? _referralPrice,
  username: username ?? _username,
  password: password ?? _password,
  model: model ?? _model,
  rcNo: rcNo ?? _rcNo,
  vehicleNumber: vehicleNumber ?? _vehicleNumber,
  vehicleType: vehicleType ?? _vehicleType,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  countryCode: countryCode ?? _countryCode,
  contactNumber: contactNumber ?? _contactNumber,
  gender: gender ?? _gender,
  address: address ?? _address,
  lat: lat ?? _lat,
  long: long ?? _long,
  description: description ?? _description,
  cityId: cityId ?? _cityId,
  bankName: bankName ?? _bankName,
  accountNo: accountNo ?? _accountNo,
  ifscCode: ifscCode ?? _ifscCode,
  upiId: upiId ?? _upiId,
  trnId: trnId ?? _trnId,
  commission: commission ?? _commission,
  status: status ?? _status,
  walletAmount: walletAmount ?? _walletAmount,
  registrationFees: registrationFees ?? _registrationFees,
  categoryFees: categoryFees ?? _categoryFees,
  paymentStatus: paymentStatus ?? _paymentStatus,
  adharNo: adharNo ?? _adharNo,
  panNo: panNo ?? _panNo,
  licenseNo: licenseNo ?? _licenseNo,
  insurance: insurance ?? _insurance,
  kyc: kyc ?? _kyc,
  runningOrder: runningOrder ?? _runningOrder,
  addDate: addDate ?? _addDate,
  updateDate: updateDate ?? _updateDate,
  loginStatus: loginStatus ?? _loginStatus,
  onlineTime: onlineTime ?? _onlineTime,
  loginHours: loginHours ?? _loginHours,
  lastLoginOn: lastLoginOn ?? _lastLoginOn,
  readStatus: readStatus ?? _readStatus,
  userStatus: userStatus ?? _userStatus,
  weightValue: weightValue ?? _weightValue,
  weightType: weightType ?? _weightType,
  categoryName: categoryName ?? _categoryName,
);
  String? get id => _id;
  String? get uniqId => _uniqId;
  dynamic get ownerId => _ownerId;
  String? get categoryId => _categoryId;
  String? get weight => _weight;
  String? get vehicleId => _vehicleId;
  String? get referralCode => _referralCode;
  dynamic get executiveCode => _executiveCode;
  dynamic get referralPrice => _referralPrice;
  String? get username => _username;
  String? get password => _password;
  String? get model => _model;
  String? get rcNo => _rcNo;
  String? get vehicleNumber => _vehicleNumber;
  String? get vehicleType => _vehicleType;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  dynamic get countryCode => _countryCode;
  String? get contactNumber => _contactNumber;
  String? get gender => _gender;
  String? get address => _address;
  String? get lat => _lat;
  String? get long => _long;
  String? get description => _description;
  String? get cityId => _cityId;
  String? get bankName => _bankName;
  String? get accountNo => _accountNo;
  String? get ifscCode => _ifscCode;
  String? get upiId => _upiId;
  dynamic get trnId => _trnId;
  String? get commission => _commission;
  String? get status => _status;
  String? get walletAmount => _walletAmount;
  String? get registrationFees => _registrationFees;
  String? get categoryFees => _categoryFees;
  String? get paymentStatus => _paymentStatus;
  String? get adharNo => _adharNo;
  String? get panNo => _panNo;
  String? get licenseNo => _licenseNo;
  String? get insurance => _insurance;
  String? get kyc => _kyc;
  String? get runningOrder => _runningOrder;
  String? get addDate => _addDate;
  String? get updateDate => _updateDate;
  String? get loginStatus => _loginStatus;
  String? get onlineTime => _onlineTime;
  String? get loginHours => _loginHours;
  String? get lastLoginOn => _lastLoginOn;
  String? get readStatus => _readStatus;
  String? get userStatus => _userStatus;
  String? get weightValue => _weightValue;
  String? get weightType => _weightType;
  String? get categoryName => _categoryName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uniq_id'] = _uniqId;
    map['owner_id'] = _ownerId;
    map['category_id'] = _categoryId;
    map['weight'] = _weight;
    map['vehicle_id'] = _vehicleId;
    map['referral_code'] = _referralCode;
    map['executive_code'] = _executiveCode;
    map['referral_price'] = _referralPrice;
    map['username'] = _username;
    map['password'] = _password;
    map['model'] = _model;
    map['rc_no'] = _rcNo;
    map['vehicle_number'] = _vehicleNumber;
    map['vehicle_type'] = _vehicleType;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['countryCode'] = _countryCode;
    map['contact_number'] = _contactNumber;
    map['gender'] = _gender;
    map['address'] = _address;
    map['lat'] = _lat;
    map['long'] = _long;
    map['description'] = _description;
    map['city_id'] = _cityId;
    map['bank_name'] = _bankName;
    map['account_no'] = _accountNo;
    map['ifsc_code'] = _ifscCode;
    map['upi_id'] = _upiId;
    map['trn_id'] = _trnId;
    map['commission'] = _commission;
    map['status'] = _status;
    map['wallet_amount'] = _walletAmount;
    map['registration_fees'] = _registrationFees;
    map['category_fees'] = _categoryFees;
    map['payment_status'] = _paymentStatus;
    map['adhar_no'] = _adharNo;
    map['pan_no'] = _panNo;
    map['license_no'] = _licenseNo;
    map['insurance'] = _insurance;
    map['kyc'] = _kyc;
    map['running_order'] = _runningOrder;
    map['add_date'] = _addDate;
    map['update_date'] = _updateDate;
    map['login_status'] = _loginStatus;
    map['online_time'] = _onlineTime;
    map['login_hours'] = _loginHours;
    map['last_login_on'] = _lastLoginOn;
    map['read_status'] = _readStatus;
    map['user_status'] = _userStatus;
    map['weight_value'] = _weightValue;
    map['weight_type'] = _weightType;
    map['category_name'] = _categoryName;
    return map;
  }

}