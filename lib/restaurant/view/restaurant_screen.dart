import 'package:delivery_app/common/const/data.dart';
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
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final foodRes = await dio.get(
      'http://localhost:3000/restaurant?after=0&count=4',
   options: Options(
      headers: {
        'authorization' : 'Bearer $accessToken',
      }
    ));
    return foodRes.data['data'];
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
                  final pItem = RestaurantModel.fromJson(json : item);
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