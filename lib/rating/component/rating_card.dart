import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/rating/model/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avartarImage;
  final List<Image> images;

  final int rating;
  final String email;
  final String content;

  const RatingCard(
      {super.key,
      required this.avartarImage,
      required this.images,
      required this.rating,
      required this.email,
      required this.content});

  factory RatingCard.fromModel({
    required RatingModel model,
  }) {
    return RatingCard(
        avartarImage:
            NetworkImage('http://localhost:3000/${model.user.imageUrl}'),
        images: model.imageUrls == null
            ? []
            : model.imageUrls.map((e) => Image.network((e).toList())),
        rating: model.rating,
        email: model.user.username,
        content: model.content);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(avartarImage: avartarImage, email: email, rating: rating),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          SizedBox(
            height: 100,
            child: _Images(
              images: images,
            ),
          )
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avartarImage;
  final int rating;
  final String email;

  const _Header(
      {required this.avartarImage, required this.rating, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avartarImage,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
        ...List.generate(
          5,
          (index) => index < rating
              ? const Icon(
                  Icons.star,
                  color: PRIMARY_COLOR,
                )
              : const Icon(
                  Icons.star_border,
                  color: PRIMARY_COLOR,
                ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(color: BDOY_TEXT_COLOR, fontSize: 14.0),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, e) => Padding(
              padding:
                  EdgeInsets.only(right: index == images.length - 1 ? 0 : 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
