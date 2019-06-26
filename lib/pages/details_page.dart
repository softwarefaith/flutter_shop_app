import 'package:flutter/material.dart';
import '../Provider/details_info.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);



  @override
    Widget build(BuildContext context) {

    DetailsInfoProvide detailProvider = DetailsInfoProvide();
    detailProvider.getGoodsInfo(goodsId);

    return Container(
       child:  Text("$goodsId"),
    );
  }
}
