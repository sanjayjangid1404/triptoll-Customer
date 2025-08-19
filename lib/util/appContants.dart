
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triptoll/controller/authController.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appColors.dart';
import 'appImage.dart';

class AppContants
{
  static String appName = "TripToll";
  static String token = "Auth Token";
  static String link = "Auth Token";
  static String faceId = "Face Id";
  static String rupessSystem = "₹";
  static String userPassword = "User Password";
  static String userDeviceID = "User Device Token";
  static const String cartList = 'canteen_cart_list';
  static String userID = "User ID";
  static String userName = "User Name";
  static String userEmail = "User Email";
  static String userPhone = "User Phone";
  static String notification = "Notification ID";
  // static String baseURl = "https://apitest.crossroadhelpline.in/api/"; 
  // static String baseURl = "https://dev.triptoll.in/api/";
  static String baseURl = "https://triptoll.in/app-admin/api/";
  // static String imageURL = "https://dev.triptoll.in/";
  static String imageURL = "https://triptoll.in/app-admin/";
  static String loginUrl = "Customer/login";
  static String getAllCategory = "home/getAllCategory";
  static String checkPaymentURL = "Booking/checkPayment";
  static String sendDriverOTPURL = "Customer/customerSignupOTP";
  static String createCustomerURL = "Customer/customerCreate";
  static String forgetPasswordURL = "User/forgotPasswordOTP";
  static String updatePasswordURL = "User/updatePassword";
  static String cancelOrderURL = "Booking/orderCancelled";
  static String saveBookingURl = "Booking/saveBooking";
  static String orderPaymentURL = "Booking/orderPayment";
  static String notifyDriverURL = "Booking/notifyDrivers";
  static String getAllVehicle = "home/getAllCategory";
  static String getAllBookingURL = "Booking/getAllBooking";
  static String runningBookingURL = "Booking/check_running_order_customer";
  static String getBookingDetails = "Booking/getBookingDetail";
  static String driverDetailsURL = "Driver/getDriverDetails";
  static String categoryVehicleURL = "home/getVehicleByCategoryId/";
  static String verifyOtpURl = "verify-otp";
  static String myComplaintURl = "get-my-complaints";
  static String getMyReferral = "get-my-referral-code";
  static String userMembership = "user-membership-details";
  static String userProfileURL = "get-latest-user-profile";
  static String userUpdateProfileUrl = "update-user-profile";
  static String updateProfileURl = "profile-update";
  static String referralEarning = "get-referral-earning-details";
  static String getFamilyAddedVehiclesURL = "get-family-added-vehicles";
  static String getOwnReferrals = "get-own-referrals?status=PAID&page=1&size=10";
  static String getFaultName = "get-fault-name";
  static String getSubFaultName = "get-sub-fault-name";
  static String getRemarkURl = "get-remark";
  static String crateNewRemark = "create-new-remark";
  static String addComplainURl = "register-complaint-by-user";
  static String sowRegisterComplain = "sow-register-complaint-by-user";
  static String sowMemberShipCard = "sow-user-membership-details";
  static String getPackagesURL = "get-packages";
  static String prcMemberURL = "prc-member-activation";
  static String prcUpgradePackage = "prc-upgrade-package";
  static String payNowURL = "pay-now";
  static String prcQuickHelp = "prc-quick-rsa-help";
  static String checkPaymentStatus = "check-payment-status";
  static String promoCodeCheckURL = "prc-apply-prome-code-referral-code";
  static String getMakerURL = "get-maker-model?vehicle_type=Four_Wheeler";
  static String getModelURL = "get-model?vehicle_type=FOUR_WHEELER&maker_name=";
  static String paytmMID = "pEhuoh06789111182793";
  static String paytmToken = "b321952990ed47ce99dadca2684a54091723097676896";
  static String reviewURLLink = "https://g.page/r/CWdRrns2HdWhEAE/review";
  static const String POPPINS = "Poppins";
  static const String OPEN_SANS = "OpenSans";
  static const String SKIP = "Skip";
  static const String NEXT = "Next";
  static const String SLIDER_HEADING_1 = "Fast & Secure Payments";
  static const String SLIDER_HEADING_2 = "Recharge & Pay Bills in Seconds";
  static const String SLIDER_HEADING_3 = "Shop Smart & Earn Rewards";
  static const String SLIDER_DESC = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ultricies, erat vitae porta consequat.";
  static const String SLIDER_DESC1 = "Pay instantly using UPI, wallet, debit/credit cards, and more. Your transactions are safe with bank-grade security.";
  static const String SLIDER_DESC2 = "Mobile recharge, DTH, electricity, gas — everything you need in one place.";
  static const String SLIDER_DESC3 = "Get exciting cashback and offers every time you shop or pay bills.";

  static double btnRadius = 4;


  // https://api.crossroadshelpline.com/api/get-fault-name?vehicle_type=FOUR_WHEELER&fault_type=ACCIDENT


  static String changeDateFormat(String date,String format)
  {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat("MMM d, yyyy - hh:mm a").format(dateTime);

    return DateFormat(format).format(dateTime);
  }
  static bool differentDate(String date)
  {
    DateTime currentTime = DateTime.now();
    DateTime specifiedTime = DateTime.parse(date);

    Duration difference = currentTime.difference(specifiedTime);
    bool isDifferenceLessThan10Minutes = difference.inMinutes.abs() < 10;

    print("Is difference less than 10 minutes: $isDifferenceLessThan10Minutes");

    return difference.inMinutes.abs() < 10;
  }

  static bool currentFood(String date, String startTime, String endTime) {
    // Get the current date in "yyyy-MM-dd" format
    String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    print("date=>$date");
    print("startTime=>$startTime");
    print("endTime=>$endTime");

    // Combine the current date with the given time
    String startDateTimeString = "$formattedDate $startTime";
    String endDateTimeString = "$formattedDate $endTime";

    DateTime startDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(startDateTimeString);
    DateTime endDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(endDateTimeString);
    DateTime currentDate = DateTime.now();

    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(startDate) || currentDate.isAtSameMomentAs(endDate);
  }

  static notFoundText(String text)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),
    );
  }


  static Future<String?> getToken() async {
    String? token = "";


    SharedPreferences sp = await SharedPreferences.getInstance();
    // await Provider.of<StepTrackerProvider>(context, listen: false).getFitData();

    if(Platform.isAndroid)
    {
      token =  await FirebaseMessaging.instance.getToken();
    }
    else
    {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    sp.setString("saveDeviceID", token??"");
    print("token=>$token");

    return token!=null ? token:"";
  }


  static Color getColor(String plan)
  {
    if(plan.toLowerCase() == "lifetime pan india" || plan.toLowerCase() =="instant rsa" || plan.toLowerCase() =="titanium pan india"
        || plan.toLowerCase() =="titanium family plan" || plan.toLowerCase() =="lifetime family plan" || plan.toLowerCase() =="sow package 1")
    {
      return Colors.white;
    }
    else
    {
      return Colors.black;
    }
  }

 static  String getCarImage(String plan)
  {
    if(plan.toLowerCase() == "lifetime pan india" )
    {
      return AppImage.lifetimePanImage;
    }
    else if(plan.toLowerCase() =="platinum pan india")
    {
      return AppImage.platinumPanImage;
    }
    else if(plan.toLowerCase() =="instant rsa")
    {
      return AppImage.instantPanImage;
    }
    else if(plan.toLowerCase() =="titanium family plan")
    {
      return AppImage.titaniumFamilyImage;
    }
    else if(plan.toLowerCase() =="titanium pan india" || plan.toLowerCase().contains("titanium"))
    {
      return AppImage.titaniumPanImage;
    }
    else if(plan.toLowerCase() =="lifetime family plan")
    {
      return AppImage.lifetimeFamilyImage;
    }

    else if(plan.toLowerCase() =="platinum family plan")
    {
      return AppImage.platinumFamilyImage;
    }
    else if(plan.toLowerCase() =="sow package 1")
    {
      return AppImage.sowPackageImage;
    }

    else if(plan.toLowerCase() =="times prime gold plan")
    {
      return AppImage.timesPrimeGoldCardImage;
    }

    else if(plan.toLowerCase() =="mechanic Assistant plan")
    {
      return AppImage.mechanicAssistantCardImage;
    }
    else {
      return AppImage.cardBackground;
    }
  }

  static List<BoxShadow>? searchBoxShadow =  [const BoxShadow(
      offset: Offset(0,3),
      color: Color(0x208F94FB), blurRadius: 5, spreadRadius: 2)];


  static List<String>categoryName = ["Tyre Puncture","Fuel Delivery","Towing Assistance","Key Lockout","Battery Jump Start","Instant Car Repair","Service on Wheel (SOW)","Instant Car Sell","Motor Insurance","RSA for Two Wheeler","Emergency Roadside Inspections","On-Road Emergency Assistance Service","Spares Parts Delivery"];

  static List<List<String>>featureContent = [
    ["Instant on-spot puncture repair at your location","24x7 availability across India","Skilled technicians with quality tools","Free service with Crossroads membership","Other services: Fuel delivery, towing, battery jumpstart, lockout help","🔥 20% discount on tyre repair services (limited time)"],
    ["Get instant fuel delivered anywhere, anytime – no need to tow or push your car.","Experts arrive with the right equipment and follow safe fuel-handling practices.","If you're a Crossroads member, fuel delivery is covered under your plan (fuel charges may apply).","Just call the helpline, share your location, and a technician will be dispatched immediately.","The service covers major highways, cities, and towns across India."],
    ["Get immediate towing assistance anytime, anywhere – no need to worry about the time of day or night.","Experienced technicians equipped with the right tools ensure safe and efficient towing of your vehicle.","Services are available across major highways, cities, and towns throughout India.","From flatbed towing to long-distance towing, choose the service that best suits your needs.","Clear information on costs, with no hidden charges, especially for Crossroads members."],
    ["Assistance is available at any time, day or night.","Services are provided across all regions of India.","Trained professionals equipped with advanced tools handle various lockout scenarios.","Utilization of specialized tools ensures your vehicle remains unharmed during the unlocking process.","Clear and upfront pricing with no hidden charges.","Includes key duplication, smart key programming, and ignition repair or replacement."],
    ["Assistance is available at any time, day or night.","Services are provided across all regions of India.","Trained professionals equipped with advanced tools handle various battery issues","Utilization of specialized equipment ensures your vehicle's battery is jumpstarted without causing any damage.","Clear and upfront pricing with no hidden charges","If the battery cannot be revived, assistance is provided for battery replacement or towing to the nearest service center."],
    ["Assistance is available at any time, day or night","Services are provided across all regions of India.","Trained professionals equipped with advanced tools handle various minor repairs.","Repairs are conducted at your location, eliminating the need to visit a workshop","Clear and upfront pricing with no hidden charges.","Includes engine diagnostics, battery checks, and more"],
    ["Services include engine oil replacement, brake checks, battery inspections, and minor repairs, all performed at your location.","Trained professionals equipped with industry-approved tools ensure high-quality service.","Clear and upfront pricing with no hidden charges.","Commitment to environmentally responsible waste disposal methods.","Assistance is available at any time, day or night.",],
    ["Enter your car details online to get an immediate price estimate.","Assistance is available at any time, day or night.","Streamlined procedures ensure a smooth selling experience.","Leverage Crossroads Helpline's reputation for reliable services."],
    ["Competitive pricing to suit your budget without compromising on coverage.","Simplified claim process with minimal paperwork for a stress-free experience.","Digital processes eliminate the need for physical documents, making it convenient.","Easily buy or renew your motor insurance online from the comfort of your home","Enhance your policy with optional covers for additional protection.","Protection against accidents, theft, natural calamities, fire damage, vandalism, and manmade disasters.","Access to a vast network of over 8,000 cashless garages across India.","Enjoy discounts on your premium for claim-free years."],
    ["Assistance is available at any time, day or night.","Services are provided across all regions of India.","Trained professionals equipped with advanced tools handle various two-wheeler issues.","Repairs are conducted at your location, eliminating the need to visit a workshop.","Clear and upfront pricing with no hidden charges.","Commitment to environmentally responsible waste disposal methods."],
    ["Assistance is available at any time, day or night.","Services are provided across all regions of India.","Trained professionals equipped with advanced tools handle various roadside issues.","Comprehensive inspections to assess your car's condition, from evaluating engine health to checking for fluid leaks.","Clear and upfront pricing with no hidden charges.","Expert guidance on the next steps to restore your vehicle's performance."],
    ["Certified paramedics available 24/7 for timely medical support.","Reliable transportation to your destination with verified drivers.","Secure accommodations ranging from budget to luxury stays.","Assistance is available at any time, day or night.","Services are provided across multiple locations to reach you fast."],
    ["Services are provided across all regions of India.","Includes batteries, tyres, oil, coolant, air filters, and more.","Trained professionals ensure the correct spare parts are matched to your vehicle.","Only certified spare parts are used to maintain vehicle performance and safety.","Proper disposal of old batteries, oils, and tyres to minimize environmental impact.","Hassle-free and secure payment options for your convenience."],

  ];

  static List<String>aboutList = [
    "Crossroads Helpline’s Car Tyre Puncture Service ensures you never get stranded due to a flat tyre. Available 24x7, our experienced technicians provide on-spot puncture repair at your location, using high-quality tools to get you back on the road safely and quickly. Whether you’re missing a spare tyre or just need professional assistance, we’ve got you covered with prompt support and optional towing services, ensuring peace of mind wherever you travel.",
    "Crossroads Helpline offers 24x7 emergency car fuel delivery service to assist stranded drivers who run out of fuel. Whether you're stuck on a highway, in the city, or any remote area, their trained technicians promptly deliver petrol or diesel to your location so you can resume your journey without delay.",
    "Crossroads Helpline offers 24x7 emergency car towing services to assist drivers facing vehicle breakdowns, accidents, or other unforeseen issues. Whether you're stranded on a highway, in the city, or any remote area, their trained professionals promptly provide towing assistance to your location, ensuring your vehicle is safely transported to your desired destination.",
    "Crossroads Helpline offers 24x7 emergency car key lockout services across India. Whether you've locked your keys inside the car, lost them, or experienced a malfunction, their professional team ensures prompt and safe access to your vehicle without causing any damage.",
    "Crossroads Helpline offers 24x7 emergency car battery jumpstart services across India. Whether your vehicle's battery has drained due to leaving lights on, extreme temperatures, or prolonged inactivity, their professional team ensures prompt and safe assistance to revive your vehicle's battery and get you back on the road.",
    "Crossroads Helpline offers 24x7 on-site minor car repair services across India. Whether you're dealing with brake issues, light replacements, or minor electrical problems, their professional technicians provide prompt and efficient repairs at your location, ensuring your journey continues smoothly.",
    "Crossroads Helpline's Service on Wheels (SOW) Plans offer comprehensive car maintenance services delivered directly to your doorstep. Designed for convenience and efficiency, these plans ensure your vehicle receives timely care without the need to visit a workshop.",
    "Crossroads Helpline offers a 24x7 Car Sell Campaign to assist individuals looking to sell their vehicles effortlessly. This service ensures you receive the best price for your car quickly and conveniently, without the usual hassles associated with selling a vehicle.","Crossroads Helpline offers comprehensive motor insurance coverage designed to protect you and your vehicle in various situations. Their services ensure that you can drive with confidence, knowing that you're safeguarded against unforeseen events.​",
    "Crossroads Helpline offers 24x7 emergency roadside assistance for two-wheelers across India. Whether you're facing a flat tyre, dead battery, or fuel shortage, their professional team ensures prompt and safe assistance to get you back on the road.",
    "Crossroads Helpline offers swift and reliable emergency roadside car inspections across India. Whether you're experiencing overheating, fluid leaks, or unusual mechanical sounds, their expert technicians provide on-site diagnostics to identify and address issues promptly, ensuring you get back on the road safely.",
    "Crossroads Helpline offers 24x7 on-road emergency assistance across India, providing comprehensive support during unexpected situations. Whether you're dealing with a medical emergency, vehicle breakdown, or need transportation, their services ensure you're never alone on the road.",
    "Crossroads Helpline offers 24x7 on-road spare parts assistance across India, providing essential components like batteries, tyres, oil, coolant, and air filters directly to your location. This service ensures you're never stranded due to a mechanical issue, offering quick and reliable solutions to get you back on the road swiftly."

  ];

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }


  static void showNoteBottomSheet(BuildContext context,AuthController authController,String bookingID,bool isOrder, void back,) {


    TextEditingController _noteController = TextEditingController();
    TextEditingController _reasonController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reason",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write reason...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Note can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                "Additional Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your information here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Note can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {

                  authController.cancelOrder(bookingID: bookingID,reason: _reasonController.text,comment: _noteController.text,isOrder:isOrder);
                  back;
                  back;
                },

                label: Text("Cancel",style: TextStyle(fontSize: 14,color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: AppColors.secondaryGradient,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),

                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<String>subTitle = ["Our 24/7 Support is Just a Call away.","Get Quick and Reliable Fuel Delivery Service Wherever You Are","Our 24/7 Support is Just a Call away.","Our 24/7 Support is Just a Call away.","Stranded with a dead battery? Our Battery Jump Start service is here to get you back on the road swiftly and safely. Available 24/7, our team ensures professional assistance to revive your vehicle's battery in no time.","Our 24/7 Support is Just a Call away.","Experience hassle-free car maintenance with Service on Wheels. From oil changes to full inspections, our certified mechanics bring the garage to you. Book now and save time, every time.","Crossroads Helpline is here 24/7 to assist you in getting the best price for your car, quickly and easily.",
  "Get the right insurance for your car, giving you confidence and protection every time you drive.","Stranded on the road with a flat Tyre, empty fuel, or a sudden breakdown? Don’t worry! With our expert 2-wheeler roadside assistance, help is just a call away.",
  "Facing unexpected car troubles? Our expert technicians are here to identify issues like overheating, fluid leaks, or mechanical failures with precision. Get back on the road in no time!","Experience peace of mind with our comprehensive on-road emergency assistance services. From ambulance support to hotel bookings, we’re your reliable partner during unexpected situations.","Stranded on the road? Get essential spare parts delivered right to your location — batteries, tyres, oil, coolant, air filters, and more. Quick, efficient, and reliable service at your fingertips!"];
  static List<String>headingTitle = ["Flat Tyre? Quick, Reliable, and Hassle-Free Tyre Puncture Assistance","Out of Fuel? We’re Just a Call Away!","Reliable Towing Assistance Services Near You","Immediate Key Lockout Assistance – Get Back on the Road Fast!","Quick and Reliable Battery Jump Start Service","Reliable Minor Repairs for Your Vehicle at Your Convenience","Expert Car Care, Right at Your Doorstep!","Get the Best Price Instantly","Complete Car Insurance Coverage","Quick & Reliable 2-Wheeler Roadside Assistance Anytime, Anywhere!","Swift and Reliable Emergency Roadside Car Inspection",
    "On-Road Emergency Assistance: Always Here When You Need Us","On-Road Emergency Assistance: Always Here When You Need Us","Convenient Spare Parts Delivery at Your Location!"];
  static List<String>categoryIMage = ["https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Ftyre-1.ac21755a.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Ffuel.d0e3b897.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Ftowing-service.6a5086ba.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FIMG_9470.9ec43f17.webp&w=828&q=75",
  "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FBattery-Jumpstart.2f3a0c5c.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fcar-repairing-3.418ed364.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fservice-on-wheel-image-2.85211773.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fstep-3.970ef15d.webp&w=640&q=75","https://wpblogassets.paytm.com/paytmblog/uploads/2021/09/15_Insurance_-What-is-Vehicle-Insurance-800x500.jpg","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2F2-wheeler-tyre-puncture.ee2af555.jpg&w=828&q=75",
  "https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FBattery-Jumpstart.2f3a0c5c.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FBattery-Jumpstart.2f3a0c5c.webp&w=828&q=75","https://crossroadshelpline.com/_next/image?url=%2F_next%2Fstatic%2Fmedia%2FBattery-Jumpstart.2f3a0c5c.webp&w=828&q=75"];
}

