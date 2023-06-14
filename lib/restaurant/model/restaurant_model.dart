import 'package:delivery_app/common/model/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId {
  @override
  final String id;
  final String name;
  final List<String> tags;
  final String thumbUrl;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel(
      {required this.ratingsCount,
      required this.tags,
      required this.id,
      required this.name,
      required this.thumbUrl,
      required this.priceRange,
      required this.ratings,
      required this.deliveryTime,
      required this.deliveryFee});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
