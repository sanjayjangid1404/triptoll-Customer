import 'package:flutter/cupertino.dart';

import '../util/appContants.dart';

class Slider {
  final String? sliderImageUrl;
  final String? sliderHeading;
  final String? sliderSubHeading;

  Slider(
      {@required this.sliderImageUrl,
      @required this.sliderHeading,
      @required this.sliderSubHeading});
}

final sliderArrayList = [
    Slider(
        sliderImageUrl: 'assets/images/slider_1.png',
        sliderHeading: AppContants.SLIDER_HEADING_1,
        sliderSubHeading: AppContants.SLIDER_DESC1),
    Slider(
        sliderImageUrl: 'assets/images/slider_2.png',
        sliderHeading: AppContants.SLIDER_HEADING_2,
        sliderSubHeading: AppContants.SLIDER_DESC2),
    Slider(
        sliderImageUrl: 'assets/images/slider_3.png',
        sliderHeading: AppContants.SLIDER_HEADING_3,
        sliderSubHeading: AppContants.SLIDER_DESC3),
  ];
