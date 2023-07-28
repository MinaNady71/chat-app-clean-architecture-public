import 'package:flutter/material.dart';


Widget loadingOrErrorImageWidget(double radius,String imageAssets,double width,double height, ){
 return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(imageAssets,
        width: width,
        height: height,
        fit: BoxFit.cover,));
}
