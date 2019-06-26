import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';


Handler detailsHandler = Handler(

   handlerFunc: (BuildContext context, Map<String, List<String>> params){

      String goodsId = params['id'].first;
      print("detail id ====>${goodsId}");

      return DetailsPage(goodsId);
    }
);