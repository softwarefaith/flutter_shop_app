import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';





Future  httpRequest(urlKey,{formData}) async {

  try{




    Response response;

    Dio dio = new Dio();

    dio.options.contentType = ContentType.parse(
        "application/x-www-form-urlencoded"
    );


    var path = servicePath[urlKey];

    print('request begin ===>${path}');

    if(formData != null) {
      response = await  dio.post(path,data: formData);
    } else {
      response = await  dio.post(path);
    }



    if(response.statusCode==200){
      return response.data;
    } else {
      throw Exception("service error......");
    }

  }catch(e){
    print('getHomePageContent ERROR:======>${e}');
  }


}



Future getHomePageContent() async {

  try{


    print('getHomePageContent begin ===>');

    Response response;

    Dio dio = new Dio();
    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon':'115.02932','lat':'35.76189'};

    //String path =  "http://v.jspang.com:8088/baixing/"+"wxmini/homePageContent";
    var path = servicePath[servicePathOfHomePageContext];


    response = await  dio.post(path,data: formData);

    if(response.statusCode==200){
      return response.data;
    } else {
      throw Exception("service error......");
    }

  }catch(e){
    print('getHomePageContent ERROR:======>${e}');
  }


}