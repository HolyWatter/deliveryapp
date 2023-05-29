import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String name;
  final String id;
  final String imgUrl;
  final String detail;
  final int price;
  
  ProductModel({required this.id,required this.imgUrl, required this.detail,required this.price, required this.name});

  factory ProductModel.fromJson(Map<String, dynamic> json)
  => _$ProductModelFromJson(json);
}