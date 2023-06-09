import 'package:delivery_app/common/model/model_with_id.dart';
import 'package:delivery_app/user/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel implements IModelWithId {
  @override
  final String id;
  final UserModel user;
  final int rating;
  final String content;
  final dynamic imageUrls;

  RatingModel(
      {required this.id,
      required this.user,
      required this.rating,
      required this.content,
      required this.imageUrls});

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}
