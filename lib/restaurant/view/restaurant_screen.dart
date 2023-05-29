import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:delivery_app/restaurant/widget/restaurant_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
    final dio = Dio();

  @override
  Future<List> paginateRestaurant ()async {

    final dio = Dio();

    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );
   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot){
              if(!snapshot.hasData){
                return Container();
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 14,
                  );
                },
                itemBuilder: (_, index){
                  final item = snapshot.data![index];
                  final pItem = RestaurantModel.fromJson(item);
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                      MaterialPageRoute(builder: (_)=> RestaurantDetailScreen(pItem: pItem, id : pItem.id))
                    );
                    },
                    child: RestuarantCard.fromModel(model : pItem));
                },
              );
            }
          ),
        )
      ),
    );
  }
}