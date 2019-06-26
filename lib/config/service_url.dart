const serviceUrl='http://v.jspang.com:8088/baixing/';

//商家首页信息
const servicePathOfHomePageContext='homePageContext';

//商家首页爆款区
const servicePathOfHomePageExplosion='Explosion';

const servicePathOfCategory ='Category';

const servicePathOfGetMallGoods ='getMallGoods';

//getGoodDetailById

const servicePathOfgetGoodDetailById ='getGoodDetailById';

const servicePath={
  servicePathOfHomePageContext:serviceUrl+'wxmini/homePageContent', // 商家首页信息

   servicePathOfHomePageExplosion:serviceUrl+'wxmini/homePageBelowConten',

   servicePathOfCategory:serviceUrl+'wxmini/getCategory',//商品分类

  servicePathOfGetMallGoods:serviceUrl+'wxmini/getMallGoods',//商品

  servicePathOfgetGoodDetailById:serviceUrl+'wxmini/getGoodDetailById'
};