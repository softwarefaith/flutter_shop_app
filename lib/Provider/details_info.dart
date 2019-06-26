import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';

class DetailsInfoProvide with ChangeNotifier{

  DetailsModel goodsInfo ;

  //从后台获取商品信息

  getGoodsInfo(String id )async {
    var formData = { 'goodId':id, };

    httpRequest(servicePathOfgetGoodDetailById,formData:formData).then((val){
      var responseData= json.decode(val.toString());
      print(responseData);
      goodsInfo=DetailsModel.fromJson(responseData);

      notifyListeners();
    });


  }

}