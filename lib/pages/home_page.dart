import 'package:flutter/material.dart';

import '../service/service_method.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert' show json;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/service_url.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';

//class HomePage extends StatelessWidget {
////
////
////  @override
////  Widget build(BuildContext context) {
////    return Scaffold(
////      body:  FutureBuilder(
////        future: getHomePageContent(),
////        builder: (BuildContext context, AsyncSnapshot snapshot) {
////
////          print("HomePage ---${snapshot.data}");
////          /*表示数据成功返回*/
////          if (snapshot.hasData) {
////
////            return Text("${snapshot.data.toString()}");
////          } else {
////            return Text("首页");
////          }
////        },
////      ),
////    );
////  }
////}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getHotGoods();
  }

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("百姓生活"), backgroundColor: Colors.redAccent),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("HomePage ---${snapshot.data}");
          /*表示数据成功返回*/
          if (snapshot.hasData) {
            var jsonMap = json.decode(snapshot.data);
            var dataMap = jsonMap['data'];
            print("swipDataList====>${dataMap.runtimeType}");

            List<Map> swipDataList =
                (dataMap['slides'] as List).cast(); // 顶部轮播组件数
            List<Map> navigatorList =
                (dataMap['category'] as List).cast(); //类别列表

            String advertesPicture =
                dataMap['advertesPicture']['PICTURE_ADDRESS']; //广告图片

            String leaderImage = dataMap['shopInfo']['leaderImage']; //店长图片
            String leaderPhone = dataMap['shopInfo']['leaderPhone']; //店长电话

            List<Map> recommendList =
                (dataMap['recommend'] as List).cast(); // 商品推荐

            String floor1Title =
                dataMap['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            String floor2Title =
                dataMap['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            String floor3Title =
                dataMap['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            List<Map> floor1 = (dataMap['floor1'] as List).cast(); //楼层1商品和图片
            List<Map> floor2 = (dataMap['floor2'] as List).cast(); //楼层1商品和图片
            List<Map> floor3 = (dataMap['floor3'] as List).cast(); //楼层1商品和图片

            print("swipDataList====>" + swipDataList.toString());
//
//            return  SingleChildScrollView(
//              child:Column(
//                children: <Widget>[
////                Text("首页"),
//                  SwiperDiy(swiperDataList: swipDataList),
//                  TopNavigator(navigatorList:navigatorList),
//                  AdBanner(advertesPicture:advertesPicture),   //广告组件
//                  LeaderPhone(leaderImage:leaderImage,leaderPhone: leaderPhone),  //广告组件
//                  Recommend(recommendList:recommendList),
//
//                  Floor(floorTitle: floor1Title,floorContents: floor1),
//                  Floor(floorTitle: floor2Title,floorContents: floor2),
//                  Floor(floorTitle: floor3Title,floorContents: floor3),
//                  _hotGoods(),
//                ],
//
//
//              )
//            );
            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                  key:_footerKey,
                  bgColor:Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: '',
                  moreInfo: '加载中',
                  loadReadyText:'上拉加载....'

              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swipDataList),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(advertesPicture: advertesPicture), //广告组件
                  LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone), //广告组件
                  Recommend(recommendList: recommendList),

                  Floor(floorTitle: floor1Title, floorContents: floor1),
                  Floor(floorTitle: floor2Title, floorContents: floor2),
                  Floor(floorTitle: floor3Title, floorContents: floor3),
                  _hotGoods(),
                ],
              ),

              loadMore: () async{

                var formPage = {'page': page};

              await  httpRequest(servicePathOfHomePageExplosion, formData: formPage).then((val) {
                  var data = json.decode(val.toString());
                  print('爆款专区=====>${val}');
                  List<Map> newGoodsList = (data['data'] as List).cast();

                  if (mounted) {
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  } else {
                    print('未转载....');
                  }
                });

              },
            );
          } else {
            return Text("加载中。。。");
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  //热销商品的数据
  void _getHotGoods() async {
    var formPage = {'page': page};

    httpRequest(servicePathOfHomePageExplosion, formData: formPage).then((val) {
      var data = json.decode(val.toString());
      print('爆款专区=====>${val}');
      List<Map> newGoodsList = (data['data'] as List).cast();

      if (mounted) {
        setState(() {
          hotGoodsList.addAll(newGoodsList);
          page++;
        });
      } else {
        print('未转载....');
      }
    });
  }

  //火爆专区标题
  Widget hotTitles = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
    ),
    child: Text('火爆专区'),
  );

  //火爆专区子项
  Widget _widgetList() {
    if (hotGoodsList.length != 0) {
      print("_widgetList===>");
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            print("爆款点击");
          },
          child: Container(
            width: 160,
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  val['image'],
                  width: 150,
                ),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Expanded(
                        child: Text(
                      '￥${val['price']}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text("");
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitles,
          _widgetList(),
        ],
      ),
    );
  }
}

/*
利用第三方实现轮播图
 */
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
//    print('设备宽度:${ScreenUtil.screenWidth}');
//    print('设备高度:${ScreenUtil.screenHeight}');
//    print('设备像素密度:${ScreenUtil.pixelRatio}');
    return Container(
      height: ScreenUtil().setHeight(300),
      child: Swiper(
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index]['image']}",
              fit: BoxFit.fill);
        },
      ),
    );
  }
}

/*


 */

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print("点击了导航");
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告图片
class AdBanner extends StatelessWidget {
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

//店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launghURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launghURL() async {
    String url = 'tel:' + leaderPhone;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 170,
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget _recommedList() {
    return Container(
        height: 180,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendList.length,
            itemBuilder: (BuildContext context, int index) {
              return _item(index);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommedList()],
      ),
    );
  }
}

// 楼层-
class Floor extends StatelessWidget {
  final String floorTitle;
  final List floorContents;

  Floor({Key key, this.floorTitle, this.floorContents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FloorTitle(picture_address: floorTitle),
          FloorContent(floorGoodsList: floorContents)
        ],
      ),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String picture_address;

  FloorTitle({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _secondRow()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _secondRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print("点击了楼层商品");
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

//火爆专区
