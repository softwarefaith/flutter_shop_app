import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class RoutManager{



  static String root = '/';

  static String detailsPage = '/detail';

  static void configureRoutes(Router router){

    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String,List<String>> params){
        print('Error======>Router was Not FOUND!!!');
      },
    );
    router.define(detailsPage, handler: detailsHandler);
  }
}

