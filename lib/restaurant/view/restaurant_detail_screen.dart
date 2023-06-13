import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/widget/product_card.dart';
import 'package:delivery_app/rating/component/rating_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/widget/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final RestaurantModel pItem;
  const RestaurantDetailScreen({super.key, required this.pItem, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {

    final state = ref.watch(restaurantDetailProvider(widget.id));

    if(state == null){
      return const DefaultLayout(child: Center(child: CircularProgressIndicator(),));
    }

    return DefaultLayout(
      title: widget.pItem.name,
      child: CustomScrollView(
        slivers: [
          renderTop(model: state),
          if(state is! RestaurantDetailModel)renderLoading(),
          if(state is RestaurantDetailModel)renderDetail(model: state),
          if(state is RestaurantDetailModel)renderLabel(),
          if(state is RestaurantDetailModel)renderProduct(model: state),
          const SliverPadding(
            padding : EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: RatingCard(
              rating: 4,
              email: 'asd@naver.com',
              images: [],
              avartarImage: AssetImage('asset/img/logo/codefactory_logo.png'),
              content: '맛좋다. 맛좋다. 맛좋다맛좋다. 맛좋다. 맛좋다맛좋다맛좋다맛좋다맛좋다',
            ),
            ),
          )
        ],
      )
    );
  }

  SliverPadding renderLoading(){
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver : SliverList(
        delegate: SliverChildListDelegate(
          List.generate(3, (index) => SkeletonParagraph(
            style: const SkeletonParagraphStyle(
              lines: 5
            ),
          )
      )))
      );
  }


  SliverToBoxAdapter renderTop({
    required RestaurantModel model
  }){
    return SliverToBoxAdapter(
            child: RestuarantCard.fromModel(model: model, isDetail: true,),
          );
  }
}

SliverToBoxAdapter renderDetail({
  required RestaurantDetailModel model
}){
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        model.detail,
        style: const TextStyle(
          fontSize: 12,
          color: BDOY_TEXT_COLOR
        ),
      ),
    ),
  );
}

SliverToBoxAdapter renderLabel () {
  return const SliverToBoxAdapter(child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Text("메뉴" ,
     style : TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600
    )),
  ),);
}

 SliverList renderProduct({
  required RestaurantDetailModel model
 }){
  return SliverList(
    delegate : SliverChildBuilderDelegate((context, index){
      return ProductCard(product : model.products[index]);
    },
    childCount: model.products.length,)
  );
}