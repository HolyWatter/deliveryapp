enum RestaurantPriceRange{
  expensive,
  medium,
  cheap, 
}

class RestaurantModel {
  final String id;
  final String name;
  final List<String> tags;
  final String thumbUrl;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.ratingsCount ,
    required this.tags,
     required this.id,  required this.name,  required this.thumbUrl,  required this.priceRange,  required this.ratings,  required this.deliveryTime,  required this.deliveryFee
  });

  factory RestaurantModel.fromJson({
    required Map<String , dynamic> json,
  }){
    return RestaurantModel(
      tags: List<String>.from(json['tags']),
      id: json['id'], 
      name: json['name'], 
      thumbUrl: json['thumbUrl'], 
      ratingsCount : json['ratingsCount'],
      priceRange: RestaurantPriceRange.values.firstWhere((element) => element.name == json['priceRange']), 
      ratings: json['ratings'], 
      deliveryTime: json['deliveryTime'], 
      deliveryFee: json['deliveryFee']);
  }
}

