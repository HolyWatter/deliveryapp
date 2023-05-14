import 'package:delivery_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(16),
      child: IntrinsicHeight(
        child: Row(
          children: [
             ClipRRect(
              borderRadius : BorderRadius.circular(10),
               child: Image.asset(
                  'asset/img/food/ddeok_bok_gi.jpg',
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
                  children: const [
                    Text("asd",
                    style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.w500 
                    ),),
                    Text("내용들어갑니다. 내용들어갑니다. 내용들어갑니다. 내용들어갑니다. 내용들어갑니다.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: BDOY_TEXT_COLOR
                    ),
                    ),
                    Text("₩ 10000",
                    style: TextStyle(
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