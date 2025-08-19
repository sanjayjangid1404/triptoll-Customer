import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:triptoll/controller/authController.dart';

import '../../util/appColors.dart';
import '../../util/appContants.dart';
import '../../util/app_fonts.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  TextEditingController fNameCt = TextEditingController();
  TextEditingController lNameCt = TextEditingController();
  TextEditingController emailCt = TextEditingController();

  String? selectedGender;
  final List<String> genderList = ['Male', 'Female', 'Other'];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) =>
       Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.primaryGradient,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("My Profile",style: TextStyle(fontSize: 18,color: Colors.white),),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: BottomWaveClipper(),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: AppColors.primaryGradient,
                        alignment: Alignment.center,

                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30,top: 80,right: 30),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),

                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(authController.getUserName()!,style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                                  Text(authController.getUserPhone()??"",style: TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.w500),),


                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 30,),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),

                color: AppColors.primaryGradient,
                child: Text("Edit Profile",style: TextStyle(fontSize: 16,color: Colors.white),),
              ),

              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: fNameCt,
                      style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        border: OutlineInputBorder(



                          borderRadius: BorderRadius.circular(4),
                        ),
                        fillColor: Color(0xFFC11F1F),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                        labelText : "First Name",
                        labelStyle : TextStyle(
                          color: Color(0xFF868686),
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: lNameCt,
                      style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        border: OutlineInputBorder(



                          borderRadius: BorderRadius.circular(4),
                        ),
                        fillColor: Color(0xFFC11F1F),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                        labelText : "Last Name",
                        labelStyle : TextStyle(
                          color: Color(0xFF868686),
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailCt,
                      style: TextStyle(fontSize: 14,fontFamily: AppFonts.poppinsRegular),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        border: OutlineInputBorder(



                          borderRadius: BorderRadius.circular(4),
                        ),
                        fillColor: Color(0xFFC11F1F),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),

                          borderRadius: BorderRadius.circular(4),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Adjust the vertical padding
                        labelText : "Email",
                        labelStyle : TextStyle(
                          color: Color(0xFF868686),
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              value: selectedGender,
              items: genderList.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
          ),


              SizedBox(height: 30,),

              //action Button
              InkWell(
                onTap: (){
                  // Get.offAllNamed(RouteHelper.getHomeView());



                },
                child: Container(

                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  //padding: const EdgeInsets.symmetric(vertical: 17),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: AppColors.primaryGradient,
                    /*gradient: LinearGradient(
                            begin: Alignment(1.00, 0.00),
                            end: Alignment(-1, 0),
                            colors: [ AppColors.primaryGradient,AppColors.secondaryGradient],
                          ),*/
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppContants.btnRadius),
                    ),
                  ),
                  child:/*authController!.isLoading ? SpinKitThreeBounce(color: Colors.white):*/ Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Update'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.60,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height);

    final secondControlPoint = Offset(3 * size.width / 4, size.height);
    final secondEndPoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy,
      firstEndPoint.dx, firstEndPoint.dy,
    );

    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy,
      secondEndPoint.dx, secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
