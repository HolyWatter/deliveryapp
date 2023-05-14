import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/widget/product_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/widget/restaurant_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  final RestaurantModel pItem;
  
  const RestaurantDetailScreen({super.key, required this.pItem, required this.id});

  Future<Map<String, dynamic>> getDetail() async{
    final token = await storage.read(key: ACCESS_TOKEN_KEY);
    final dio = Dio();

    final detailRes = await dio.get('http://localhost:3000/restaurant/$id',

    options: Options(
      headers: {
        'authorization' : 'Bearer $token'
      }
    ));

  return detailRes.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: pItem.name,
      child: FutureBuilder<Map<String, dynamic>>(
        future: getDetail(),
        builder: (_, AsyncSnapshot<Map<String , dynamic>> snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final item = RestaurantDetailModel.fromJson(
            json : snapshot.data!
          );
            return CustomScrollView(
        slivers: [
          renderTop(model: item),
          renderDetail(model: item),
          renderLabel(),
          renderProduct()
        ],
      );

      })
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model
  }){
    return SliverToBoxAdapter(
            child: RestuarantCard.fromModel(model: model, isDetail: true,),
          );
  }
}

SliverToBoxAdapter renderDetail({
  required RestaurantDetailModel model
}){
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        model.detail,
        style: const TextStyle(
          fontSize: 12,
          color: BDOY_TEXT_COLOR
        ),
      ),
    ),
  );
}

SliverToBoxAdapter renderLabel () {
  return const SliverToBoxAdapter(child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Text("메뉴" ,
     style : TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600
    )),
  ),);
}

 SliverList renderProduct(){
  return SliverList(
    delegate : SliverChildBuilderDelegate((context, index){
      return const ProductCard();
    },
    childCount: 10,)
  );
}