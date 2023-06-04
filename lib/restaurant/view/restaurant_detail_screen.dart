import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/widget/product_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:delivery_app/restaurant/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;

  final RestaurantModel pItem;
  
  const RestaurantDetailScreen({super.key, required this.pItem, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: pItem.name,
      child: FutureBuilder<RestaurantDetailModel>(
        future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            return CustomScrollView(
        slivers: [
          renderTop(model: snapshot.data!),
          renderDetail(model: snapshot.data!),
          renderLabel(),
          renderProduct(model: snapshot.data!)
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

 SliverList renderProduct({
  required RestaurantDetailModel model
 }){
  return SliverList(
    delegate : SliverChildBuilderDelegate((context, index){
      return ProductCard(product : model.products[index]);
    },
    childCount: model.products.length,)
  );
}