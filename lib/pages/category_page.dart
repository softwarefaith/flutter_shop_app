import 'package:flutter/material.dart';

import '../service/service_method.dart';
import 'dart:convert';

import '../config/service_url.dart';
import '../model/category.dart';
import 'package:provider/provider.dart';

import '../model/categoryGoodsList.dart';


class  ChildCategoryProvider extends ChangeNotifier {

  List<CategoryBigSubModel> childCategoryList = [];


  int childIndex = 0;

  String categoryId = "4";



  getChildCategory(List list,String id){
    childIndex = 0;
    childCategoryList=list;

    print("通知发送===>${childCategoryList.toString()}");
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(index){



    childIndex=index;
    notifyListeners();
  }



}

class  GoodCategoryProvider extends ChangeNotifier {

  List<CategoryListData> childCategoryList = [];

  getChildCategory(List list){



    childCategoryList= list!=null?list:[];
    print("通知发送===>${childCategoryList.toString()}");
    notifyListeners();
  }


}

class  Test extends ChangeNotifier {

  String title = '';

  setName(String temp){
    title=temp;
    print("通知发送===>${title}");
    notifyListeners();
  }


}


class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {


    String test = "我就不给你数据....你咬我呀";



   return  MultiProvider(

        providers: [
          Provider<String>.value(value: test), //用于数据传递...
          ChangeNotifierProvider<ChildCategoryProvider>(builder: (_) => ChildCategoryProvider(),child: Text("Child"),),
          ChangeNotifierProvider<GoodCategoryProvider>(builder: (_) => GoodCategoryProvider(),child: Text(""),),

        ],
       child: Scaffold(
           appBar: AppBar(
             title: Text(
                 "商品分类"
             ),
           ),


           body: Container(
               child: Row(
                 children: <Widget>[
                   LeftCategoryNav(
                   ),
                   Column(
                     children: <Widget>[
                       RightCategoryNav(
                       ),

                       Flexible(

                         child: CategoryGoodsList(),

                       )


                     ],
                   )
                 ],
               )
           )
       ),


    );

  }




}


class LeftCategoryNav extends StatefulWidget {


  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

   int index = 0;

  List list = [];
  @override
  void initState() {
    // TODO: implement initState
    _getCategory();

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    
    if(list.length == 0){
      
      return Text('数据加载中...');
    }
    
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.red,
            width: 0.5
          )
        )
      ),
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index){
             return _leftInkWel(index);
          })
    );
  }

  void _getCategory()async{
    await httpRequest(servicePathOfCategory).then((val){
      var data = json.decode(val.toString());
      CategoryBigModelList category= CategoryBigModelList.fromJson(data);
      setState(() {

        list =category.data;
        print("_getCategory====>${list.toString()}");
        //刷新右边第一个

        index = 0;
        var childList = list[index].bxMallSubDto;
        String id = list[index].mallCategoryId;

        Provider.of<ChildCategoryProvider>(context).getChildCategory(childList,id);

      });

    });
  }

  Widget _leftInkWel(int index){


    String title  =  list[index].mallCategoryName;

    return InkWell(
      onTap: (){
        print(title);
        this.index = index;

        var childList = list[index].bxMallSubDto;
        String id = list[index].mallCategoryId;

        Provider.of<ChildCategoryProvider>(context).getChildCategory(childList,id);

        var categoryId= list[index].mallCategoryId;

        _getGoodList(categoryId:categoryId);


      },
      child: Container(
          height: 60,
          //padding: EdgeInsets.only(left: 10,top: 20),
          decoration: BoxDecoration(
            color: this.index == index? Colors.deepOrangeAccent :Colors.white,
            border:Border(
                bottom:BorderSide(width: 1,color:Colors.black12)
            )
          ),
          child: Center(
            child: Text(title)
          ),
      ),
    );


  }

   void _getGoodList({String categoryId = '4'})async {
     var data={
       'categoryId':categoryId,
       'categorySubId':"",
       'page':1
     };
     await httpRequest(servicePathOfGetMallGoods,formData:data ).then((val){
       var data = json.decode(val.toString());
       CategoryGoodsListModel  goodsListModel = CategoryGoodsListModel.fromJson(data);

       //商品详情
       Provider.of<GoodCategoryProvider>(context).getChildCategory(goodsListModel.data);


       print('分类商品列表：>>>>>>>>>>>>>${data}');
     });

   }
}

 class RightCategoryNav extends StatefulWidget {
   @override
   _RightCategoryNavState createState() => _RightCategoryNavState();
 }

 class _RightCategoryNavState extends State<RightCategoryNav> {

  List list = ["323"];

  bool isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
   @override
   Widget build(BuildContext context) {



     return Consumer<ChildCategoryProvider>(
         builder:(context, childCategory, child){


           print("收到数据===>${childCategory.childCategoryList.toString()}===>${child.toString()}");

           if(childCategory.childCategoryList.length == 0){

            String value =  Provider.of<String>(context);

             return Text('${value}');
           }

           return Container(

               child: Container(

                 width: 270,
                 height: 40,
//                 child: Text('${childCategory.childCategoryList[0].mallSubName}'),
                 child:  ListView.builder(
                     scrollDirection: Axis.horizontal,
                     itemCount: childCategory.childCategoryList.length,
                     itemBuilder: (context,index){

                           return _rightInkWell(childCategory.childCategoryList[index],index);
                     }
                 ),
                 decoration: BoxDecoration(
                     border: Border(
                         bottom: BorderSide(
                             color: Colors.blue,
                             width: 1.0
                         )
                     )

                 ),

               ),
           );

         }

     );

   }

   Widget _rightInkWell(CategoryBigSubModel subModel,index){

     isCheck = (index == Provider.of<ChildCategoryProvider>(context).childIndex)?true:false;


     String item = subModel.mallSubName;
     return InkWell(
       onTap: (){
             print(item);
             Provider.of<ChildCategoryProvider>(context).changeChildIndex(index);

             _getGoodList(categorySubId:subModel.mallSubId);

         },

       child: Container(
         padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
         child: Text(
           item,
         ),
         decoration: BoxDecoration(
             color: isCheck?Colors.amberAccent: Colors.white,

             border: Border(

              right: BorderSide(
                color: Colors.green,
                width: 1.0
              )
           )

         ),
       ),
     );
   }

  void _getGoodList({String categorySubId = ''})async {
    var data={
      'categoryId':Provider.of<ChildCategoryProvider>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1
    };
    await httpRequest(servicePathOfGetMallGoods,formData:data ).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel  goodsListModel = CategoryGoodsListModel.fromJson(data);

      //商品详情
      Provider.of<GoodCategoryProvider>(context).getChildCategory(goodsListModel.data);


      print('分类商品列表：>>>>>>>>>>>>>${data}');
    });

  }

 }

//商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  CategoryGoodsListModel goodsListModel;

  List<CategoryListData> dataSource = [];

  @override
  void initState() {
    // TODO: implement initState
    //this._getGoodList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


   return Consumer(
     builder: (context,GoodCategoryProvider goodsCategoryProvider,widget){
       dataSource = goodsCategoryProvider.childCategoryList;
       if (dataSource.length == 0) {
         return Container(
           child: Text(
               "我就是没数据"
           ),
         );
       }
       print("商品列表时候偶倒通知");
       return Container(
           width: 265,
           child: ListView.builder(
             itemCount: dataSource.length,
             itemBuilder: (
                 context, index) {
               return _listWidget(
                   index
               );
             },
           )
       );
     },
   );
    
    

  }

  void _getGoodList({String categoryId = '4'})async {
    var data={
      'categoryId':categoryId,
      'categorySubId':"",
      'page':1
    };
    await httpRequest(servicePathOfGetMallGoods,formData:data ).then((val){
      var data = json.decode(val.toString());
      goodsListModel = CategoryGoodsListModel.fromJson(data);



      if(mounted){
        setState(() {
          dataSource = goodsListModel.data;
        });
      }
      print('分类商品列表：>>>>>>>>>>>>>${data}');
    });

  }



  Widget _listWidget(index) {

    CategoryListData data = dataSource[index];
    return InkWell(

      onTap: (){},

      child: Container(

        child: _GoodsItem(data.image,data.goodsName,"${data.presentPrice}","${data.oriPrice}"),
      ),

    );

  }


}

@immutable
class _GoodsItem extends StatelessWidget {

   final String imageUrl;
   final String title;
   final String price;
   final String oriPrice;

   _GoodsItem(this.imageUrl,this.title,this.price,this.oriPrice);


  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.all(8.0),

       child: Row(

         children: <Widget>[

             Expanded(
               flex: 1,
               child: Image.network(imageUrl),
             ),

            Expanded(
             flex: 1,
             child: _rightInfo(),
            ),



         ],
       ),



    );
  }

  Widget  _rightInfo(){



    return Container(

      padding: EdgeInsets.only(left: 8,right: 8.0),

        child: Column(

          children: <Widget>[

            Text("${title}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.deepOrangeAccent
              ),

            ),


            Text("${price}"),
            Text("${oriPrice}",
                style: TextStyle(
                color: Colors.grey, decoration: TextDecoration.lineThrough,
               ),
            ),
          ],

        ),

    );


    }



}

