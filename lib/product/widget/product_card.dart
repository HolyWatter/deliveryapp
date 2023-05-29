import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final  ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          children: [
             ClipRRect(
              borderRadius : BorderRadius.circular(10),
               child: Image.network(
                  'http://localhost:3000/${product.imgUrl}',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                ),
             ),
              const SizedBox(width: 16,),
              Expanded(child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(product.name,
                    style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.w500 
                    ),),
                     Text(product.detail,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      color: BDOY_TEXT_COLOR
                    ),
                    ),
                     Text('₩ ${product.price}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600
                    ),)
                  ],
                )
              )
          ],
        ),
      ),
    );
  }
}