import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestuarantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double ratings; 
  final bool isDetail;
  final String?  heroKey;

  const RestuarantCard({super.key,
   this.isDetail = false,
  required this.image,
  this.heroKey, 
  required this.name, 
  required this.tags, 
  required this.ratingsCount, 
  required this.deliveryTime, 
  required this.deliveryFee, 
  required this.ratings});

  factory RestuarantCard.fromModel({ required RestaurantModel model, bool isDetail = false}){
    return RestuarantCard(
     image : Image.network('http://localhost:3000${model.thumbUrl}',
              fit: BoxFit.cover,),
    name : model.name,
    tags : List<String>.from(model.tags),
    ratingsCount : model.ratingsCount,
    deliveryTime : model.deliveryTime,
    deliveryFee : model.deliveryFee,
    ratings: model.ratings,
    isDetail: isDetail,
    heroKey: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: ObjectKey(heroKey),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12),
            child: image,
          ),
        ),
        const SizedBox(height: 15,),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDetail ?16 :0
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(name, style:  const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),),
              Text(tags.join(' · '), 
              style: const TextStyle(
                color: BDOY_TEXT_COLOR,
                 fontSize: 14
                 ),
                 ),
                Row(
                  children: [
                    _IconText(icon: Icons.star_border_outlined, label: ratings.toString()),
                    const SizedBox(width: 10,),
                    _IconText(icon: Icons.receipt, label: ratingsCount.toString(),),
                    const SizedBox(width: 10,),
                    _IconText(icon: Icons.timelapse_outlined ,label: '$deliveryTime 분',),
                    const SizedBox(width: 10,),
                    _IconText(icon: Icons.monetization_on, label: deliveryFee ==0 ? 'FREE' : deliveryFee.toString())
                  ],
                ) 
            ],
          ),
        )

      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({required this.icon, required this.label, Key ? key }) : super(key : key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children:  [
        Icon(icon, 
        color: PRIMARY_COLOR,
        size : 14.0),
        const SizedBox(width: 8.0,),
        Text(
          label ,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
        )
      ],
    );
  }
}