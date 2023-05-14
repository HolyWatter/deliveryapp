import 'package:delivery_app/product/model/product_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';

class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<ProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name, 
    required super.thumbUrl,
    required super.tags, 
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson({
    required Map<String, dynamic> json
  }){
    return RestaurantDetailModel(
      id: json['id'], 
      name: json['name'], 
      thumbUrl: json['thumbUrl'], 
      tags: List<String>.from(json['tags']),
      priceRange: RestaurantPriceRange.values.firstWhere((element) => element.name == json['priceRange']), 
      ratings: json['ratings'], 
      ratingsCount: json['ratingsCount'], 
      deliveryTime: json['deliveryTime'], 
      deliveryFee: json['deliveryFee'], 
      detail: json['detail'], 
      products: json['products'].map<ProductModel>((x)=> ProductModel(id: x['id'], imgUrl: x['imgUrl'], detail: x['detail'], price: x['price'], name: x['name'],)).toList()

      );
  }
}